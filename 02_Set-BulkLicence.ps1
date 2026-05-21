# Set-BulkLicence.ps1
# Assigns a Microsoft 365 licence to multiple users from a CSV file.
#
# CSV format required:
#   UserPrincipalName
#   user@company.com
#   user2@company.com
#
# Required permissions: User.ReadWrite.All, Organization.Read.All
# Required module: Install-Module Microsoft.Graph

param(
    [Parameter(Mandatory)]
    [string]$CsvPath,

    [Parameter(Mandatory)]
    [string]$SkuId  # Licence SKU ID — get this by running Get-MgSubscribedSku
)

Connect-MgGraph -Scopes "User.ReadWrite.All","Organization.Read.All" -NoWelcome

$users = Import-Csv -Path $CsvPath
$success = 0
$failed  = 0

foreach ($row in $users) {
    $upn = $row.UserPrincipalName.Trim()
    try {
        $addLicence = @{ SkuId = $SkuId }
        Set-MgUserLicense -UserId $upn `
            -AddLicenses @($addLicence) `
            -RemoveLicenses @()

        Write-Host "Assigned licence to $upn" -ForegroundColor Green
        $success++
    }
    catch {
        Write-Warning "Failed for $upn : $_"
        $failed++
    }
}

Write-Host "`nCompleted. Success: $success | Failed: $failed" -ForegroundColor Cyan
Disconnect-MgGraph
