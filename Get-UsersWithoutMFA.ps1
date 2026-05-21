# Get-UsersWithoutMFA.ps1
# Reports all users in the tenant who do not have MFA configured.
# Useful for compliance audits and proactive security checks.
#
# Required permissions: User.Read.All, UserAuthenticationMethod.Read.All
# Install module if needed: Install-Module Microsoft.Graph

param(
    [string]$OutputPath = ".\users-without-mfa.csv"
)

# Connect to Microsoft Graph
Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes "User.Read.All","UserAuthenticationMethod.Read.All" -NoWelcome

$results = @()
$users = Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled |
         Where-Object { $_.AccountEnabled -eq $true }

Write-Host "Checking MFA status for $($users.Count) active users..." -ForegroundColor Cyan

foreach ($user in $users) {
    $methods = Get-MgUserAuthenticationMethod -UserId $user.Id

    # A user with only one method has just the password — no MFA
    $hasMFA = $methods.Count -gt 1

    if (-not $hasMFA) {
        $results += [PSCustomObject]@{
            DisplayName       = $user.DisplayName
            UserPrincipalName = $user.UserPrincipalName
            MFAConfigured     = "No"
        }
    }
}

if ($results.Count -eq 0) {
    Write-Host "All active users have MFA configured." -ForegroundColor Green
} else {
    Write-Host "$($results.Count) users found without MFA." -ForegroundColor Yellow
    $results | Export-Csv -Path $OutputPath -NoTypeInformation
    Write-Host "Results saved to $OutputPath" -ForegroundColor Green
    $results | Format-Table -AutoSize
}

Disconnect-MgGraph
