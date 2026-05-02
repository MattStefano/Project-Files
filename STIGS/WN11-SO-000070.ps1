<#
.SYNOPSIS
    This PowerShell script enforces a maximum inactivity timeout to automatically lock the system after a period of user inactivity.

.NOTES
    Author          : Matt Stefano
    LinkedIn        : linkedin.com/in/mattstefano/
    GitHub          : github.com/MattStefano
    Date Created    : 05-01-2026
    Last Modified   : 05-01-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000070
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-SO-000070/

.TESTED ON
    Date(s) Tested  : 05-01-2026
    Tested By       : Matt Stefano
    Systems Tested  : Microsoft Windows 11
    PowerShell Ver. : 5.1.26100.8115

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN11-SO-000070.ps1 
#>


$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "InactivityTimeoutSecs"
$desiredValue = 900

# Ensure registry path exists
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

# Remediate if missing, zero (disabled), or above allowed maximum
if ($null -eq $currentValue -or $currentValue -eq 0 -or $currentValue -gt $desiredValue) {
    New-ItemProperty -Path $registryPath `
                     -Name $valueName `
                     -Value $desiredValue `
                     -PropertyType DWORD `
                     -Force | Out-Null

    Write-Output "Remediation applied: $valueName set to $desiredValue"
} else {
    Write-Output "Compliant: $valueName is $currentValue (<= $desiredValue and not 0)"
}
