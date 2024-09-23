Get-ADSyncToolsTls12RegValue {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$RegPath,

        [Parameter(Mandatory = $true, Position = 1)]
        [string]$RegName
    )
    $regItem = Get-ItemProperty -Path $RegPath -Name $RegName -ErrorAction Ignore
    $output = "" | Select-Object Path, Name, Value
    $output.Path = $RegPath
    $output.Name = $RegName

    If ($regItem -eq $null) {
        $output.Value = "Not Found"
    } Else {
        $output.Value = $regItem.$RegName
    }
    $output
}

Function Check-Tls12 {
    $regSettings = @()
    $regKeys = @(
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319',
        'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319',
        'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server',
        'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client'
    )

    foreach ($regKey in $regKeys) {
        $regSettings += Get-ADSyncToolsTls12RegValue $regKey 'SystemDefaultTlsVersions'
        $regSettings += Get-ADSyncToolsTls12RegValue $regKey 'SchUseStrongCrypto'
        $regSettings += Get-ADSyncToolsTls12RegValue $regKey 'Enabled'
        $regSettings += Get-ADSyncToolsTls12RegValue $regKey 'DisabledByDefault'
    }

    $regSettings | Format-Table -AutoSize
}

Function Enable-Tls12 {
    Write-Host "Enabling TLS 1.2..."

    # Set TLS 1.2 registry settings
    $regKeys = @(
        'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319',
        'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319',
        'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server',
        'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client'
    )

    foreach ($regKey in $regKeys) {
        If (-Not (Test-Path $regKey)) {
            New-Item $regKey -Force | Out-Null
        }
    }

    # Set values for each key
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' -Name 'SystemDefaultTlsVersions' -Value 1 -Force
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value 1 -Force
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -Name 'SystemDefaultTlsVersions' -Value 1 -Force
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value 1 -Force

    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Name 'Enabled' -Value 1 -Force
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Name 'DisabledByDefault' -Value 0 -Force
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Name 'Enabled' -Value 1 -Force
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Name 'DisabledByDefault' -Value 0 -Force

    Write-Host "TLS 1.2 has been enabled. Please restart the server." -ForegroundColor Cyan
}

Function Disable-Tls12 {
    Write-Host "Disabling TLS 1.2..."

    # Disable TLS 1.2 registry settings
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' -Name 'SystemDefaultTlsVersions' -Value 0 -Force
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value 0 -Force
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -Name 'SystemDefaultTlsVersions' -Value 0 -Force
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value 0 -Force

    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Name 'Enabled' -Value 0 -Force
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Name 'DisabledByDefault' -Value 1 -Force
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Name 'Enabled' -Value 0 -Force
    Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Name 'DisabledByDefault' -Value 1 -Force

    Write-Host "TLS 1.2 has been disabled. Please restart the server." -ForegroundColor Yellow
}

Function Uninstall-Tls12 {
    Write-Host "Uninstalling TLS 1.2 settings..."

    # Remove TLS 1.2 registry keys
    Remove-Item -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\.NETFramework\v4.0.30319' -Recurse -Force
    Remove-Item -Path 'HKLM:\SOFTWARE\Microsoft\.NETFramework\v4.0.30319' -Recurse -Force
    Remove-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server' -Recurse -Force
    Remove-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client' -Recurse -Force

    Write-Host "TLS 1.2 settings have been uninstalled. Please restart the server." -ForegroundColor Red
}

# Main Menu
Function Show-Menu {
    Clear-Host
    Write-Host "TLS 1.2 Management Script"
    Write-Host "--------------------------"
    Write-Host "1. Enable TLS 1.2"
    Write-Host "2. Check TLS 1.2 status"
    Write-Host "3. Disable TLS 1.2"
    Write-Host "4. Uninstall TLS 1.2"
    Write-Host "0. Exit"
}

# Main Program Loop
Do {
    Show-Menu
    $choice = Read-Host "Please select an option (0-4)"
    
    Switch ($choice) {
        1 { Enable-Tls12 }
        2 { Check-Tls12 }
        3 { Disable-Tls12 }
        4 { Uninstall-Tls12 }
        0 { Write-Host "Exiting script..."; Exit }
        Default { Write-Host "Invalid option. Please select a valid option." -ForegroundColor Red }
    }
    Pause
} Until ($choice -eq 0)
