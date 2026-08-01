# Phase 2: Move AD Distribution Groups to Unsynced OU
$TargetOU = "OU=Unsynced-Groups,OU=NonSyncOU,DC=yourdomain,DC=com"

Get-ADGroup -Filter {GroupCategory -eq "Distribution"} | ForEach-Object {
    $GroupDN = $_.DistinguishedName
    if ($GroupDN -notlike "*$TargetOU*") {
        Write-Host "Moving group: $GroupDN"
        Move-ADObject -Identity $GroupDN -TargetPath $TargetOU
    }
}
