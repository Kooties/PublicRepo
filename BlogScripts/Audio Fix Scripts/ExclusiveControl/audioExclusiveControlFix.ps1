
<#Need to check/change permissions for the audio setting hive; currently looking at: https://www.progress.com/blogs/how-to-change-registry-permissions-with-powershell

Looks like will need to grab the ACL, create a rule to add to the ACL, add the rule to the ACL, then "write the ACL back to disk", basically#>

$key = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey("SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio",[Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree,[System.Security.AccessControl.RegistryRights]::ChangePermissions)

$oldacl = $key.GetAccessControl()
$newacl = $key.GetAccessControl()
#where to make changes to the ACL
$identity    = "SYSTEM"
$rights      = "FullControl"
$inheritance = "ContainerInherit, ObjectInherit"
$propagation = "None"
$type        = "Allow"

$rule = New-Object System.Security.AccessControl.RegistryAccessRule($identity, $rights, $inheritance, $propagation, $type)
$newacl.setaccessrule($rule)
$key.setaccesscontrol($newacl)

#########Input Devices
#audio Exclusive Control
$devices = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture\*\Properties\"
foreach($device in $devices){
    if($device.property -contains "{b3f8fa53-0004-438e-9003-51a46e139bfc},3"){
        #Set reg value
        Set-ItemProperty -Path $device.pspath -Name "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" -value 0
    }else{
        <#Create regkey#>
        New-ItemProperty -path $device.PSPath -name "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" -propertytype Dword -value 0
    }
}

#Audio Enhancements
$devices = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture\*\FxProperties\"
foreach($device in $devices){
    if($device.property -contains "{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5"){
        #Set reg value
        Set-ItemProperty -Path $device.pspath -Name "{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5" -value 1
    }else{
        <#Create regkey#>
        New-ItemProperty -path $device.PSPath -name "{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5" -propertytype Dword -value 1
    }
}

#########Output Devices
#audio Exclusive Control
$devices = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render\*\Properties\"
foreach($device in $devices){
    if($device.property -contains "{b3f8fa53-0004-438e-9003-51a46e139bfc},3"){
        #Set reg value
        Set-ItemProperty -Path $device.pspath -Name "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" -value 0
    }else{
        <#Create regkey#>
        New-ItemProperty -path $device.PSPath -name "{b3f8fa53-0004-438e-9003-51a46e139bfc},3" -propertytype Dword -value 0
    }
}

#Audio Enhancements
$devices = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render\*\FxProperties\"
foreach($device in $devices){
    if($device.property -contains "{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5"){
        #Set reg value
        Set-ItemProperty -Path $device.pspath -Name "{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5" -value 1
    }else{
        <#Create regkey#>
        New-ItemProperty -path $device.PSPath -name "{1da5d803-d492-4edd-8c23-e0c0ffee7f0e},5" -propertytype Dword -value 1
    }
}

#reset ACL to previous
$key.setaccesscontrol($oldacl)