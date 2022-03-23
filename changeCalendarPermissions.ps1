<#Changes calendar permissions to give Limited Details to specific users within the tenant
Krystina Kyle, 2/3/2022#>

Connect-ExchangeOnline
#Filter removes external users
$allMailboxes = Get-User -ResultSize unlimited | Where-Object {$_.UserPrincipalName -like "*butcherbox.com"}

<#Use $permGroup for if you are using a mail-enabled security group#>
$permGroup = get-group -identity "PeopleOpsRecruiting@MASXLLC.onmicrosoft.com"
$groupMembers = $permGroup.members

foreach($mailbox in $allMailboxes){
    if($mailbox.WhenCreated -gt [DateTime]::Now.AddDays(-7)){
        foreach($member in $groupMembers){
            $name = $mailbox.exchangeobjectid
            try {Add-MailboxFolderPermission -Identity $name`:\Calendar -User $member -AccessRights LimitedDetails}
            catch {Set-MailboxFolderPermission -Identity $name`:\Calendar -User $member -AccessRights LimitedDetails}
       }
    }
}
$outCSV = ".\outputCSV.csv"
$outHASH = @{}
foreach($mailbox in $allMailboxes){
    $name = $mailbox.exchangeobjectid
    foreach($member in $groupMembers){
        $outHASHvalue = get-MailboxFolderPermission -Identity $name`:\Calendar -User $member
        Export-CSV -InputObject $outHASHvalue -path $outCSV -append
    }
}
Export-CSV -InputObject $outHASH -path $outCSV

$twoDaysAgo = [DateTime]::Now.AddDays(-2)
$now = [DateTime]::Now
$auditLog = Search-UnifiedAuditLog -StartDate $twoDaysAgo -EndDate $now -RecordType AzureActiveDirectory -Operations "Add Member to Group"
foreach($log in $auditLog){
    if(($log.AuditData | ConvertFrom-Json).ModifiedProperties.NewValue -contains "People Ops Recruiting"){
        $user = ($log.AuditData | ConvertFrom-Json).ObjectId
        Write-Host "$user was added to People Ops Recruiting"
    }
}

$allMailboxes = Get-User -filter "DisplayName -eq 'Ian Shann'"




<#

AuditLogs 
| where OperationName contains "account"
| where TimeGenerated < ago(20m)
| project  TargetResources[0].userPrincipalName
| where TargetResources contains "autotest"

$appID = "b111189a-9b19-4e22-bc1c-3e92845943d4"
$tenantID = "350c7acd-ee85-44bd-8aab-638a15a0f600"
$secretID = "4e4c1f65-c5dc-493a-942b-cda49f6a969e"
$secretValue = "~sg7Q~KZw-ODs_wgtxEK5OTdQSQCSYC9aa5rW"

NewUserCreatedInTenant https://598846c7-3def-4da5-b301-cf82c4698d60.webhook.eus2.azure-automation.net/webhooks?token=hVSxCZwprZ6tC%2fL3i5Ht%2b%2bqDoPbNtkINsjDPjgFyd%2fY%3d


AuditLogs
| where OperationName contains "Add user"
| project  TargetResources[0].userPrincipalName



#>