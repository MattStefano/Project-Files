<#
.SYNOPSIS
    This PowerShell script disables camera access from the Windows lock screen.

.NOTES
    Author          : Matt Stefano
    LinkedIn        : linkedin.com/in/mattstefano/
    GitHub          : github.com/MattStefano
    Date Created    : 04-30-2026
    Last Modified   : 04-30-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000005
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-CC-000005/

.TESTED ON
    Date(s) Tested  : 04-30-2026
    Tested By       : Matt Stefano
    Systems Tested  : Microsoft Windows 11
    PowerShell Ver. : 5.1.26100.8115

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000005.ps1 
#>


$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
$valueName = "NoLockScreenCamera"
$desiredValue = 1

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Set the registry value
New-ItemProperty -Path $registryPath `
                 -Name $valueName `
                 -Value $desiredValue `
                 -PropertyType DWORD `
                 -Force | Out-Null

# Verify
$currentValue = (Get-ItemProperty -Path $registryPath -Name $valueName).$valueName

if ($currentValue -eq $desiredValue) {
    Write-Output "Remediation successful: $valueName is set to $desiredValue"
} else {
    Write-Output "Remediation failed: $valueName is not set correctly"
}
