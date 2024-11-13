$userGroupName = "userGroupName"
$deviceGroupName = "deviceGroupName"
Connect-MgGraph -Scopes User.Read.All,Device.Read.All,Group.ReadWrite.All,GroupMember.ReadWrite.All
$group = Get-MgGroup -Filter "DisplayName eq '$userGroupName'"
$people = Get-MgGroupMember -groupid $group.id
$deviceGroup = Get-MgGroup -Filter "DisplayName eq '$deviceGroupName'"

foreach($person in $people){
    $devices = Get-MgUserOwnedDevice -UserId $person.id
    foreach($device in $devices){
        New-MgGroupMember -GroupId $deviceGroup.id -DirectoryObjectId $device.id
    }
}