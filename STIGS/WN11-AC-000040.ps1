<#
.SYNOPSIS
    This PowerShell script enforces password complexity requirements to ensure strong password composition policies are applied.

.NOTES
    Author          : Matt Stefano
    LinkedIn        : linkedin.com/in/mattstefano/
    GitHub          : github.com/MattStefano
    Date Created    : 05-02-2026
    Last Modified   : 05-02-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AC-000040
    Documentation   : https://stigaview.com/products/win11/v2r7/WN11-AC-000040/

.TESTED ON
    Date(s) Tested  : 05-02-2026
    Tested By       : Matt Stefano
    Systems Tested  : Microsoft Windows 11
    PowerShell Ver. : 5.1.26100.8115

.USAGE
    Example syntax:
    PS C:\> .\STIG-ID-WN11-AC-000040.ps1 
#>


$tempInf = "$env:TEMP\secpol.inf"
$tempSdb = "$env:TEMP\secpol.sdb"

# Export current security policy
secedit /export /cfg $tempInf | Out-Null

# Read and modify the file
$content = Get-Content $tempInf

# Replace or add PasswordComplexity setting
if ($content -match "PasswordComplexity") {
    $content = $content -replace "PasswordComplexity\s*=\s*\d+", "PasswordComplexity = 1"
} else {
    $content += "PasswordComplexity = 1"
}

# Save updated config
$content | Set-Content $tempInf

# Apply updated security policy
secedit /configure /db $tempSdb /cfg $tempInf /areas SECURITYPOLICY | Out-Null

# Cleanup
Remove-Item $tempInf -Force -ErrorAction SilentlyContinue
Remove-Item $tempSdb -Force -ErrorAction SilentlyContinue

Write-Output "Remediation applied: Password complexity requirements enabled"
