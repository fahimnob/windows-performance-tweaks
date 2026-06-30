@echo off
:: Restore-Services.bat
:: Double-click this file. It will auto-elevate to Administrator,
:: find the newest ServiceBackup_*.csv on your Desktop, and restore from it.
:: To restore from a specific backup instead, drag-and-drop the CSV
:: onto this .bat file, or run: Restore-Services.bat "C:\path\to\backup.csv"

net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -ArgumentList '%*' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"

set "BACKUPFILE=%~1"

if "%BACKUPFILE%"=="" (
    echo No backup file specified, looking for the newest one on the Desktop...
    for /f "delims=" %%F in ('powershell -NoProfile -Command "Get-ChildItem '%USERPROFILE%\Desktop\ServiceBackup_*.csv' | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName"') do set "BACKUPFILE=%%F"
)

if "%BACKUPFILE%"=="" (
    echo No backup file found on Desktop. Run Disable-NonMicrosoftServices.bat first,
    echo or pass a backup CSV path as an argument / drag it onto this script.
    pause
    exit /b 1
)

echo Restoring services from: %BACKUPFILE%
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Restore-Services.ps1" -BackupFile "%BACKUPFILE%"

echo.
pause
