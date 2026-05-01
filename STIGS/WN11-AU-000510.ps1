<#
.SYNOPSIS
    This PowerShell script ensures the System event log maximum size meets the minimum required size of 32768 KB.

.NOTES
    Author          : Matt Stefano
    LinkedIn        : linkedin.com/in/mattstefano/
    GitHub          : github.com/MattStefano
    Date Created    : 04-30-2026
    Last Modified   : 04-30-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000510
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-AU-000510/

.TESTED ON
    Date(s) Tested  : 04-30-2026
    Tested By       : Matt Stefano
    Systems Tested  : Microsoft Windows 11
    PowerShell Ver. : 5.1.26100.8115

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN11-AU-000510.ps1 
#>


$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System"
$valueName = "MaxSize"
$minimumValue = 32768

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Get current value if it exists
$currentValue = $null
try {
    $currentValue = (Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop).$valueName
} catch {
    $currentValue = $null
}

# Remediate only if value is missing or below minimum
if ($null -eq $currentValue -or $currentValue -lt $minimumValue) {
    New-ItemProperty -Path $registryPath `
                     -Name $valueName `
                     -Value $minimumValue `
                     -PropertyType DWORD `
                     -Force | Out-Null

    Write-Output "Remediation applied: $valueName set to $minimumValue"
} else {
    Write-Output "Compliant: $valueName is already $currentValue (>= $minimumValue)"
}
