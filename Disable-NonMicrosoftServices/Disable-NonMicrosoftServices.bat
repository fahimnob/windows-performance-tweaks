@echo off
:: Disable-NonMicrosoftServices.bat
:: Double-click this file. It will auto-elevate to Administrator
:: and run Disable-NonMicrosoftServices.ps1 from the same folder.

:: --- Check for admin rights, relaunch elevated if needed ---
net session >nul 2>&1
if %errorlevel% NEQ 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

cd /d "%~dp0"

echo ============================================
echo  Disabling all non-Microsoft services
echo  (mimics msconfig clean boot)
echo ============================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0Disable-NonMicrosoftServices.ps1"

echo.
pause
