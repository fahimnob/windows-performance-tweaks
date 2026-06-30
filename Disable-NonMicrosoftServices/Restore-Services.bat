@echo off
:: Restore-Services.bat
:: Creator: fahimnob
:: Purpose: Restore services from backup CSV
:: Double-click this file. It will auto-elevate to Administrator,
:: find the newest ServiceBackup_*.csv on your Desktop, and restore from it.
:: To restore from a specific backup instead, drag-and-drop the CSV
:: onto this .bat file, or run: Restore-Services.bat "C:\path\to\backup.csv"

setlocal enabledelayedexpansion

net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -ArgumentList \"%*\" -Verb RunAs"
    exit /b
)

cd /d "%~dp0"

set "BACKUPFILE=%~1"

if "%BACKUPFILE%"==\"\" (
    echo No backup file specified, looking for the newest one on the Desktop...
    for /f "delims=" %%F in ('powershell -NoProfile -Command "Get-ChildItem '%USERPROFILE%\Desktop\ServiceBackup_*.csv' 2>$null | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName"') do (
        set "BACKUPFILE=%%F"
    )
)

if "%BACKUPFILE%"==\"\" (
    echo No backup file found on Desktop. Run Disable-NonMicrosoftServices.bat first,
    echo or pass a backup CSV path as an argument / drag it onto this script.
    pause
    exit /b 1
)

echo ============================================
echo  Restoring services from backup
echo  Creator: fahimnob
echo ============================================
echo.
echo Restoring services from: %BACKUPFILE%
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$BackupFile = '%BACKUPFILE%'; " ^
    "$Services = Import-Csv $BackupFile; " ^
    "$RestoredCount = 0; " ^
    "foreach ($Service in $Services) { " ^
    "  try { " ^
    "    $ServiceName = $Service.'Service Name'; " ^
    "    $OriginalStatus = $Service.'Original Status'; " ^
    "    $StartupType = if ($OriginalStatus -eq 'Running') { 'Automatic' } elseif ($OriginalStatus -eq 'Stopped') { 'Manual' } else { 'Disabled' }; " ^
    "    Set-Service -Name $ServiceName -StartupType $StartupType -ErrorAction SilentlyContinue; " ^
    "    if ($OriginalStatus -eq 'Running') { " ^
    "      Start-Service -Name $ServiceName -ErrorAction SilentlyContinue; " ^
    "    } " ^
    "    Write-Host \"[RESTORED] $($Service.'Display Name') to $StartupType\"; " ^
    "    $RestoredCount++; " ^
    "  } catch { " ^
    "    Write-Host \"[ERROR] Could not restore $($Service.'Service Name')\"; " ^
    "  } " ^
    "} " ^
    "Write-Host \"\`n========================================\`nTotal services restored: $RestoredCount\`n========================================\`"

echo.
echo ============================================
echo  Restore Complete!
echo ============================================
echo.
echo  WARNING: A restart is REQUIRED for changes
echo  to fully take effect.
echo.
echo  Your services have been restored to their
echo  previous state. Please restart your PC now.
echo ============================================
echo.
pause