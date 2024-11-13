$groupName = "'Intune-ScriptTesting'"
$userCSV = Import-Csv -path .\users.csv
connect-mggraph -scopes user.ReadWrite.All,Group.ReadWrite.All,GroupMember.ReadWrite.All

$group = Get-MgGroup -Filter "DisplayName eq $groupName"
foreach($user in $userCSV){
    $email = $user.Email
    $newMember = get-MgUser -Filter "UserPrincipalName eq $email"
    New-MgGroupMember -GroupId $group.id -DirectoryObjectId $newMember.id
}