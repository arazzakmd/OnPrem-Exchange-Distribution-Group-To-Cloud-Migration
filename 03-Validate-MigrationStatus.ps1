# Phase 6: Post-Migration Validation & Verification
$CloudGroups = Get-DistributionGroup -ResultSize Unlimited | Select-Object -ExpandProperty PrimarySmtpAddress
$MasterCsvPath = "C:\Migration\All_Groups_Master_Backup.csv"
$MissingGroups = @()

Import-Csv -Path $MasterCsvPath | ForEach-Object {
    if ($CloudGroups -notcontains $_.PrimarySmtpAddress) {
        $MissingGroups += $_
    }
}

if ($MissingGroups.Count -eq 0) {
    Write-Host "SUCCESS: All groups from Master CSV are present in Cloud!" -ForegroundColor Green
} else {
    Write-Host "WARNING: Missing groups found." -ForegroundColor Red
    $MissingGroups | Format-Table DisplayName, PrimarySmtpAddress
}
