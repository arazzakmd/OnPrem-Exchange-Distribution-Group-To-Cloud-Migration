# On-Premises Distribution Groups Migration to Exchange Online (Cloud)

## 📌 Scope & Overview
De-coupling On-Premises Distribution Groups from Azure AD Connect Sync and re-creating them as native Exchange Online Cloud Distribution Groups.

### Executive Summary
This documentation outlines the complete step-by-step procedure implemented to migrate synced Distribution Groups from On-Premises Active Directory to native Exchange Online Cloud Distribution Groups. This process eliminates hybrid sync dependency for group management while ensuring zero loss of group email addresses, membership data, and ownership permissions.

---

## 🛠️ Prerequisites & Required Tools
* Active Directory Domain Controller Access
* Active Directory PowerShell Module
* Azure AD / Entra Connect Sync Server Access
* Exchange Online PowerShell Module (`ExchangeOnlineManagement`)
* Global Admin / Exchange Admin Credentials

---

## 📂 Repository Structure
```text
.
├── README.md                                  # Main Documentation & Overview
├── scripts/
│   ├── 01-Move-ADGroupsToUnsyncedOU.ps1       # Script to move AD groups out of sync scope
│   ├── 02-Recreate-CloudDistributionGroups.ps1# Script to recreate groups in EXO
│   └── 03-Validate-MigrationStatus.ps1        # Post-migration validation script
└── templates/
    └── Master_Backup_Sample.csv               # Sample CSV schema for backup/export
