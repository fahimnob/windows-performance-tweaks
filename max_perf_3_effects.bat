@echo off
:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrative privileges confirmed. Customizing appearance for Max Performance...
    echo.
) else (
    echo #######################################################
    echo ERROR: You must run this script as an ADMINISTRATOR!
    echo Right-click the file and select 'Run as administrator'.
    echo #######################################################
    pause
    exit /b
)

:: --------------------------------------------------------
:: SET VISUAL EFFECTS TO CUSTOM (3)
:: --------------------------------------------------------
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 3 /f

:: --------------------------------------------------------
:: TURN OFF ALL FLUFF ANIMATIONS & TRANSITIONS (MAX PERFORMANCE)
:: --------------------------------------------------------
:: Disables window animations when minimizing/maximizing
reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d 0 /f

:: Disables taskbar animations
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAnimations /t REG_DWORD /d 0 /f

:: Disables combobox animation, smooth scrolling lists, menu fading, selection fade
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9012028010000000 /f

:: Disables folder fade, peek, and drag contents visibility
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewAlphaSelect /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ListviewShadow /t REG_DWORD /d 0 /f

:: --------------------------------------------------------
:: FORCE ENABLE ONLY THE CHOSEN 3
:: --------------------------------------------------------
:: 1. Smooth edges of screen fonts (FontSmoothing = 2)
reg add "HKCU\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f
reg add "HKCU\Control Panel\Desktop" /v FontSmoothingType /t REG_DWORD /d 2 /f

:: 2. Show thumbnails instead of icons (IconsOnly = 0)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v IconsOnly /t REG_DWORD /d 0 /f

:: 3. Show shadows under windows (DropShadow = 1)
:: Note: This modifies the user preference mask to retain window borders drop shadow
reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d 9412028010000000 /f

:: --------------------------------------------------------
:: RESTART WINDOWS EXPLORER TO APPLY INSTANTLY
:: --------------------------------------------------------
echo Restarting Windows Explorer to apply changes...
taskkill /f /im explorer.exe
start explorer.exe

echo.
echo =======================================================
echo SUCCESS: Maximum Performance Profile Applied!
echo Only Font Smoothing, Thumbnails, and Window Shadows are enabled.
echo =======================================================
pause