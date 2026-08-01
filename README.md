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
│   ├── 01-Move-ADGroupsToUnsyncedOU.ps1       # Move AD groups out of sync scope
│   ├── 02-Recreate-CloudDistributionGroups.ps1# Recreate groups natively in Exchange Online
│   └── 03-Validate-MigrationStatus.ps1        # Post-migration validation audit
└── templates/
    └── Master_Backup_Sample.csv               # Sample CSV backup template
```

---

## 🚀 Phase-by-Phase Execution Guide

### Phase 1: On-Premises Backup & Export
Before making any structural changes, all existing Distribution Groups, including their members and managers, were exported to CSV files for backup and migration staging.

* **Master Backup:** Exported all groups, SMTP addresses, member lists, and `ManagedBy` configurations into a master CSV file (`C:\Migration\All_Groups_Master_Backup.csv`).
* **Batching:** Divided the master data into manageable batches (e.g., 10 groups per batch) to ensure controlled execution and easy troubleshooting.

---

### Phase 2: Unsyncing Groups from Azure AD Sync Scope
To allow Exchange Online to manage these groups natively, the groups were moved out of the Azure AD Connect sync scope on-premises.

1. **Target OU Structure:** Identified non-syncing Organizational Unit (OU) path:
   ```text
   OU=Unsynced-Groups,OU=NonSyncOU,DC=yourdomain,DC=com
   ```
2. **Execute Active Directory Migration Script:**  
   Run `scripts/01-Move-ADGroupsToUnsyncedOU.ps1` on the Domain Controller to safely move all distribution groups into the unsynced OU.

---

### Phase 3: Directory Synchronization (Delta Sync)
Trigger Azure AD Connect Delta Synchronization on the Azure AD Connect Server to remove the synced group objects from Microsoft 365, turning them into soft-deleted cloud objects.

```powershell
Start-ADSyncSyncCycle -PolicyType Delta
```

---

### Phase 4: Purging Soft-Deleted Cloud Objects
Connect to Exchange Online PowerShell and permanently purge soft-deleted distribution groups to free up primary SMTP addresses and aliases.

```powershell
# Connect to Exchange Online
Connect-ExchangeOnline

# Hard-delete soft-deleted groups to clear email aliases
Get-Group -SoftDeletedGroup -ResultSize Unlimited | Remove-Group -PermanentlyDelete -Confirm:$false
```

---

### Phase 5: Batch Recreation in Exchange Online
Recreate the distribution groups natively in Exchange Online using the staged CSV batches.

* Run `scripts/02-Recreate-CloudDistributionGroups.ps1` in Exchange Online PowerShell.

---

### Phase 6: Post-Migration Validation & Verification
After executing all migration batches, run the audit script to cross-check the Master Backup CSV against active Exchange Online distribution groups to guarantee zero data loss.

* Run `scripts/03-Validate-MigrationStatus.ps1` to perform automated verification.

---

## 📊 Final Status & Conclusion
* **Total Groups Migrated:** 100% Complete
* **Group Management Authority:** Transferred completely to Microsoft 365 Exchange Admin Center (EAC).
* **Delivery Status:** Fully operational. All external and internal mail delivery restrictions, members, and group managers have been validated successfully.
