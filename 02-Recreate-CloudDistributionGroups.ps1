# Phase 5: Batch Recreation in Exchange Online
$BatchNumber = 1 # Incremented per batch
$DefaultCloudAdmin = "admin@yourdomain.com" # Replace with your Tenant Admin Email
$CsvPath = "C:\Migration\Batch${BatchNumber}_Exported.csv"

Import-Csv -Path $CsvPath | ForEach-Object {
    $GroupName = $_.DisplayName
    $Alias = $_.GroupAlias
    $PrimaryEmail = $_.PrimarySmtpAddress
    $Members = $_.Members -split ";"
    $ManagedByList = $_.ManagedBy -split ";"
    $RequireAuth = [System.Convert]:ToBoolean($_.RequireSenderAuthenticationEnabled)

    # 1. Create Cloud Group (Using Primary SMTP as Unique Name)
    New-DistributionGroup -Name $PrimaryEmail -DisplayName $GroupName -Alias $Alias -PrimarySmtpAddress $PrimaryEmail -Type "Distribution" -RequireSenderAuthenticationEnabled $RequireAuth
    Start-Sleep -Milliseconds 500

    # 2. Assign Members
    foreach ($Member in $Members) {
        if ($Member) {
            Add-DistributionGroupMember -Identity $PrimaryEmail -Member $Member -ErrorAction SilentlyContinue
        }
    }

    # 3. Assign Managers / Owners
    foreach ($Manager in $ManagedByList) {
        if ($Manager -like "*administrator*" -or -not $Manager) { 
            $ManagerToAssign = $DefaultCloudAdmin 
        } else { 
            $ManagerToAssign = $Manager 
        }
        Set-DistributionGroup -Identity $PrimaryEmail -ManagedBy @{Add=$ManagerToAssign} -ErrorAction SilentlyContinue
    }
}
