$accname = "tech"
$acc = Get-LocalUser -name $accname
$group = get-wmiobject Win32_group | Where-Object {$_.Name -like "Administrators"}
$members = $group.GetRelated("win32_useraccount")
foreach($member in $members){
    if($member.name -like $acc){
        return 0
    }
}
return 1