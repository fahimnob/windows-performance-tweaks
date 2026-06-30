@echo off
:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrative privileges confirmed. Optimizing system performance...
    echo.
) else (
    echo ERROR: Run as administrator!
    pause
    exit /b
)

:: --------------------------------------------------------
:: DISABLE WINDOWS TELEMETRY & BACKGROUND TRACKING
:: --------------------------------------------------------
:: Stops Windows from using CPU/Network to upload diagnostic data
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
sc config DiagTrack start= disabled
net stop DiagTrack

:: --------------------------------------------------------
:: OPTIMIZE CPU TASK SCHEDULING (Gives games/active apps priority)
:: --------------------------------------------------------
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Priority" /t REG_DWORD /d 6 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f

:: --------------------------------------------------------
:: DISABLE HIBERNATION (Frees up gigabytes of storage & stops constant disk writes)
:: --------------------------------------------------------
powercfg -h off

:: --------------------------------------------------------
:: REDUCE MOUSE/KEYBOARD RESPONSE DELAY
:: --------------------------------------------------------
reg add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d 8 /f
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v DelayBeforeAcceptance /t REG_SZ /d 0 /f

echo.
echo =======================================================
echo PERFORMANCE TWEAKS APPLIED!
echo Please restart your PC for changes to take effect.
echo =======================================================
pause