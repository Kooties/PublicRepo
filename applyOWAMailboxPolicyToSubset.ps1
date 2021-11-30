$allUsers = Get-AzureADUser -All $true
$applyPolicy = "Name or part of Name of Group for Policy"
$mailboxPolicyName = "Policy to Apply"

foreach($user in $allUsers){
    $groups = Get-AzureADUserMembership -ObjectID $user.ObjectID
    foreach($group in $groups){
        if($group.DisplayName -match $applyPolicy){
            Set-CASMailbox -Identity $user.UserPrincipalName -OwaMailboxPolicy $mailboxPolicyName
        }
    }
}
