# PowerShell Scripts for Microsoft 365 Administration

A collection of PowerShell scripts I use for Microsoft 365 admin tasks. These came out of my time at DXC Technology where I administered M365 for a large enterprise user base and had to find ways to do repetitive admin tasks faster.

The Microsoft Graph PowerShell module has replaced the older individual modules (MSOL, Azure AD v2) for most tasks. These scripts use the Graph module where possible.

---

## Scripts

| Script | What it does |
|--------|-------------|
| [Get-UsersWithoutMFA.ps1](./Get-UsersWithoutMFA.ps1) | Report all users without MFA |
| [Set-BulkLicence.ps1](./Set-BulkLicence.ps1) | Assign licences from CSV |
| [Invoke-Offboarding.ps1](./Invoke-Offboarding.ps1) | Disable account and revoke access |

---

## Requirements

- PowerShell 7+ (recommended) or Windows PowerShell 5.1
- Microsoft Graph PowerShell module: `Install-Module Microsoft.Graph`
- Appropriate permissions in your M365 tenant — see each script for required scopes

---

## A note on permissions

These scripts require admin-level permissions in your M365 tenant. Always test in a non-production environment first. The required Graph API permissions are listed as comments at the top of each script.
