<#
.SYNOPSIS
    This PowerShell script disables HTTP-based printing.

.NOTES
    Author          : Matt Stefano
    LinkedIn        : linkedin.com/in/mattstefano/
    GitHub          : github.com/MattStefano
    Date Created    : 04-30-2026
    Last Modified   : 04-30-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000110
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-CC-000110/

.TESTED ON
    Date(s) Tested  : 04-30-2026
    Tested By       : Matt Stefano
    Systems Tested  : Microsoft Windows 11
    PowerShell Ver. : 5.1.26100.8115

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN11-CC-000110.ps1 
#>


$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers"
$valueName = "DisableHTTPPrinting"
$desiredValue = 1

# Ensure the registry path exists
if (-not (Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
}

# Get current value (if it exists)
$currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

if ($null -eq $currentValue) {
    # Value does not exist, create it
    New-ItemProperty -Path $registryPath `
                     -Name $valueName `
                     -Value $desiredValue `
                     -PropertyType DWord `
                     -Force | Out-Null

    Write-Output "[$valueName] created and set to $desiredValue."
}
elseif ($currentValue.$valueName -ne $desiredValue) {
    # Value exists but is incorrect, update it
    Set-ItemProperty -Path $registryPath `
                     -Name $valueName `
                     -Value $desiredValue

    Write-Output "[$valueName] updated to $desiredValue."
}
else {
    # Already compliant
    Write-Output "[$valueName] is already set correctly ($desiredValue)."
}
