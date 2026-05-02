<#
.SYNOPSIS
    This PowerShell script prevents users from controlling Windows Installer installations by enforcing system-level installation behavior.

.NOTES
    Author          : Matt Stefano
    LinkedIn        : linkedin.com/in/mattstefano/
    GitHub          : github.com/MattStefano
    Date Created    : 05-02-2026
    Last Modified   : 05-02-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000310
    Documentation   : hhttps://stigaview.com/products/win11/v2r7/WN11-CC-000310/

.TESTED ON
    Date(s) Tested  : 05-02-2026
    Tested By       : Matt Stefano
    Systems Tested  : Microsoft Windows 11
    PowerShell Ver. : 5.1.26100.8115

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000310.ps1 
#>


$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$valueName = "EnableUserControl"
$desiredValue = 0

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

# Apply remediation if missing or non-compliant
if ($null -eq $currentValue -or $currentValue -ne $desiredValue) {
    New-ItemProperty -Path $registryPath `
                     -Name $valueName `
                     -Value $desiredValue `
                     -PropertyType DWORD `
                     -Force | Out-Null

    Write-Output "Remediation applied: $valueName set to $desiredValue"
} else {
    Write-Output "Compliant: $valueName already set to $desiredValue"
}
