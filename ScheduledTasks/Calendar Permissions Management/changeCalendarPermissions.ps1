<#Changes calendar permissions to give Limited Details to specific users within the tenant
Krystina Kyle, 2/3/2022#>

Connect-ExchangeOnline
#Filter removes external users
$allMailboxes = Get-User -ResultSize unlimited | Where-Object {($_.UserPrincipalName -like "*contoso.onmicrosoft.com")}# -and ($_.WhenCreated -gt [DateTime]::Now.AddDays(-7))}

<#Use $permGroup for if you are using a mail-enabled security group#>
$permGroup = get-group -identity "PermissionsGroup@contoso.onmicrosoft.com"
$groupMembers = $permGroup.members

foreach($mailbox in $allMailboxes){
    foreach($member in $groupMembers){
        $name = $mailbox.exchangeobjectid
        $perms = Get-MailboxFolderPermission -Identity $name`:\Calendar -User $member
        if(!$perms){
            Add-MailboxFolderPermission -Identity $name`:\Calendar -User $member -AccessRights LimitedDetails
        }elseif($perms.AccessRights -like "AvailabilityOnly"){
            Set-MailboxFolderPermission -Identity $name`:\Calendar -User $member -AccessRights LimitedDetails
        }elseif(($perms.AccessRights -notlike "editor") -and ($perms.AccessRights -notlike "Owner") -and ($perms.AccessRights -notlike "LimitedDetails")){
            try {Add-MailboxFolderPermission -Identity $name`:\Calendar -User $member -AccessRights LimitedDetails}
            catch {Set-MailboxFolderPermission -Identity $name`:\Calendar -User $member -AccessRights LimitedDetails}
		}
    }
}

$mike = get-user -identity "mike@contoso.onmicrosoft.com"
$tom = get-user -identity "tom@contoso.onmicrosoft.com"
$perms = Get-MailboxFolderPermission -Identity $name`:\Calendar -User $member
foreach($user in $users){
    $name = $mailbox.exchangeobjectid
    Set-MailboxFolderPermission -Identity $name`:\Calendar -User reba@contoso.onmicrosoft.com -AccessRights Editor -SendNotificationToUser $false
}

foreach($mailbox in $allMailboxes){
    $name = $mailbox.exchangeobjectid
    Remove-MailboxFolderPermission -Identity $name`:\Calendar -User $member.userPrincipalName -Force
    try {Add-MailboxFolderPermission -Identity $name`:\Calendar -User $member.userPrincipalName -AccessRights LimitedDetails}
    catch {Set-MailboxFolderPermission -Identity $name`:\Calendar -User $member.userPrincipalName -AccessRights LimitedDetails}
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

$appID = "appID"
$tenantID = "tenantID"
$secretID = "secretID"
$secretValue = "secretValue"

NewUserCreatedInTenant https://598846c7-3def-4da5-b301-cf82c4698d60.webhook.eus2.azure-automation.net/webhooks?token=hVSxCZwprZ6tC%2fL3i5Ht%2b%2bqDoPbNtkINsjDPjgFyd%2fY%3d


AuditLogs
| where OperationName contains "Add user"
| project  TargetResources[0].userPrincipalName



#>