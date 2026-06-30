@echo off
:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Administrative privileges confirmed. Starting optimization...
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
:: 1. REALTEK ETHERNET OPTIMIZATION
:: --------------------------------------------------------
echo Configuring Realtek Ethernet Adapter...

:: Force 1.0 Gbps Full Duplex
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Speed & Duplex' -DisplayValue '1.0 Gbps Full Duplex' -ErrorAction SilentlyContinue"

:: Disable Power-Saving Restrictions
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Energy-Efficient Ethernet' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Green Ethernet' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Gigabit Lite' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Auto Disable Gigabit' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'WOL & Shutdown Link Speed' -DisplayValue 'Not Speed Down' -ErrorAction SilentlyContinue"

:: Maximize Buffers (Values can vary by driver; sets max standard values)
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Receive Buffers' -DisplayValue '512' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Transmit Buffers' -DisplayValue '512' -ErrorAction SilentlyContinue"

:: Enable Hardware Offloading
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'IPv4 Checksum Offload' -DisplayValue 'Rx & Tx Enabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'TCP Checksum Offload (IPv4)' -DisplayValue 'Rx & Tx Enabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'UDP Checksum Offload (IPv4)' -DisplayValue 'Rx & Tx Enabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Large Send Offload v2 (IPv4)' -DisplayValue 'Enabled' -ErrorAction SilentlyContinue"

echo Realtek settings applied.
echo.

:: --------------------------------------------------------
:: 2. INTEL WI-FI 6 OPTIMIZATION
:: --------------------------------------------------------
echo Configuring Intel Wi-Fi 6 Adapter...

:: Maximize Throughput Standards & Channels
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName '802.11ax Wireless Mode' -DisplayValue '802.11ax' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Channel Width for 2.4GHz' -DisplayValue 'Auto' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Channel Width for 5GHz' -DisplayValue 'Auto' -ErrorAction SilentlyContinue"

:: Roaming & Power Tuning
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Roaming Aggressiveness' -DisplayValue '1. Lowest' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Transmit Power' -DisplayValue '5. Highest' -ErrorAction SilentlyContinue"

:: MIMO & Traffic Offloading
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'MIMO Power Save Mode' -DisplayValue 'No SMPS' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Packet Coalescing' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue"
powershell -Command "Set-NetAdapterAdvancedProperty -Name '*' -DisplayName 'Throughput Booster' -DisplayValue 'Disabled' -ErrorAction SilentlyContinue"

echo Intel Wi-Fi settings applied.
echo.

:: --------------------------------------------------------
:: 3. WINDOWS WIRELESS POWER PLAN OPTIMIZATION
:: --------------------------------------------------------
echo Setting Windows Wireless Adapter to Maximum Performance...

:: Updates the active power scheme's wireless subkey to Maximum Performance (000) for both AC and DC power
powershell -Command "$activePlan = (powercfg /getactivescheme).Split()[3]; powercfg /setacvalueindex $activePlan 19cbb8fa-0579-4c8e-8019-d483c57406de 12bbebe6-58d6-4636-95bb-3217ef867c1a 0"
powershell -Command "$activePlan = (powercfg /getactivescheme).Split()[3]; powercfg /setdcvalueindex $activePlan 19cbb8fa-0579-4c8e-8019-d483c57406de 12bbebe6-58d6-4636-95bb-3217ef867c1a 0"
:: Apply changes immediately
powercfg /setactivescheme $activePlan

echo Windows Power settings applied.
echo.
echo =======================================================
echo OPTIMIZATION COMPLETE!
echo Note: Network adapters may briefly reset to apply changes.
echo It is highly recommended to restart your PC.
echo =======================================================
pause