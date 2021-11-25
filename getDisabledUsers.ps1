$users = Get-ADUser -Searchbase "Distinguished Name of Group/OU working within" -Filter {Enabled -eq $false} 
$disabledUserOU = "Distinguished Name of the Disabled Users OU"#CHANGEME PER TENANT#

foreach($user in $users){
    Move-ADObject -Identity $user -TargetPath $disabledUserOU
    #write-host $user
}