@echo off
:: Disable-NonMicrosoftServices.bat
:: Creator: fahimnob
:: Purpose: Disable all non-Microsoft services (mimics msconfig clean boot)
:: Double-click this file. It will auto-elevate to Administrator
:: and disable all third-party services. Everything is self-contained.

setlocal enabledelayedexpansion

:: --- Check for admin rights, relaunch elevated if needed ---
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"

:: Make the whole console text green (foreground = Light Green on black)
color 0A

echo ============================================
echo  Disabling all non-Microsoft services
echo  (mimics msconfig clean boot)
echo  Creator: fahimnob
echo ============================================
echo.

:: Create backup file on Desktop with timestamp
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
for /f "tokens=1-2 delims=/:" %%a in ('time /t') do (set mytime=%%a-%%b)
set "BACKUPFILE=%USERPROFILE%\Desktop\ServiceBackup_%mydate%_%mytime%.csv"

echo Creating backup file: %BACKUPFILE%
echo Service Name,Display Name,Original Status >> "%BACKUPFILE%"

:: Get all services and backup their status
for /f "tokens=*" %%A in ('powershell -NoProfile -Command "Get-Service | ForEach-Object { $_.Name + ',"' + $_.DisplayName + '," + $_.Status }"') do (
    echo %%A >> "%BACKUPFILE%"
)

echo.
echo Backup created successfully.
echo.
echo Disabling non-Microsoft services...
echo.

:: Disable all non-Microsoft services using PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$Services = Get-Service; " ^
    "$DisabledCount = 0; " ^
    "foreach ($Service in $Services) { " ^
    "  try { " ^
    "    $RegPath = \"HKLM:\\SYSTEM\\CurrentControlSet\\Services\\$($Service.Name)\"; " ^
    "    $ImagePath = (Get-ItemProperty $RegPath -Name ImagePath -ErrorAction SilentlyContinue).ImagePath; " ^
    "    $IsMicrosoft = $ImagePath -match '(System32|SysWOW64|Windows|WinSxS)' -or $Service.Name -match '^(Microsoft|Windows|Intel|NVIDIA|AMD)'; " ^
    "    if (-not $IsMicrosoft -and $ImagePath) { " ^
    "      if ($Service.StartType -ne 'Disabled') { " ^
    "        Set-Service -Name $Service.Name -StartupType Disabled -ErrorAction SilentlyContinue; " ^
    "        Stop-Service -Name $Service.Name -Force -ErrorAction SilentlyContinue; " ^
    "        Write-Host \"[DISABLED] $($Service.DisplayName) ($($Service.Name))\"; " ^
    "        $DisabledCount++; " ^
    "      } " ^
    "    } " ^
    "  } catch { " ^
    "  } " ^
    " } " ^
    "Write-Host \"`n========================================`nTotal services disabled: $DisabledCount`n========================================`"

echo.
echo ============================================
echo  Complete!
echo ============================================
echo.
echo  Backup location (Desktop):
echo  %BACKUPFILE%
echo.
echo  WARNING: A restart is REQUIRED for changes
echo  to fully take effect.
echo.
echo  To restore services later, run:
echo  Restore-Services.bat
echo ============================================
echo.

:: Restore console color to default (light gray on black)
color 07

pause
