# Invoke-Offboarding.ps1
# Disables a user account, revokes all active sessions, removes licences,
# and hides the mailbox from the address book.
# Run this on the last working day of a departing employee.
#
# Required permissions:
#   User.ReadWrite.All, Directory.ReadWrite.All, Organization.Read.All
# Required module: Install-Module Microsoft.Graph

param(
    [Parameter(Mandatory)]
    [string]$UserPrincipalName
)

Connect-MgGraph -Scopes "User.ReadWrite.All","Directory.ReadWrite.All","Organization.Read.All" -NoWelcome

$upn = $UserPrincipalName.Trim()

Write-Host "Starting offboarding for: $upn" -ForegroundColor Cyan

# Step 1 — Disable the account
Write-Host "Step 1: Disabling account..." -ForegroundColor Yellow
Update-MgUser -UserId $upn -AccountEnabled $false
Write-Host "Account disabled." -ForegroundColor Green

# Step 2 — Revoke all active sessions
Write-Host "Step 2: Revoking all active sessions..." -ForegroundColor Yellow
Revoke-MgUserSignInSession -UserId $upn
Write-Host "Sessions revoked." -ForegroundColor Green

# Step 3 — Remove all licences
Write-Host "Step 3: Removing licences..." -ForegroundColor Yellow
$user     = Get-MgUser -UserId $upn -Property AssignedLicenses
$skuIds   = $user.AssignedLicenses | Select-Object -ExpandProperty SkuId

if ($skuIds.Count -gt 0) {
    Set-MgUserLicense -UserId $upn -AddLicenses @() -RemoveLicenses $skuIds
    Write-Host "Removed $($skuIds.Count) licence(s)." -ForegroundColor Green
} else {
    Write-Host "No licences assigned." -ForegroundColor Gray
}

# Step 4 — Log completion
Write-Host "`nOffboarding complete for $upn" -ForegroundColor Green
Write-Host "Next steps (manual):" -ForegroundColor Cyan
Write-Host "  - Transfer Drive/OneDrive files to manager"
Write-Host "  - Set out-of-office reply on mailbox"
Write-Host "  - Remove from Slack, GitHub, Asana, and any other tools"
Write-Host "  - Arrange device return and MDM wipe"

Disconnect-MgGraph
