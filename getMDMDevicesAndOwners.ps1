<#PS Script to get MDM managed devices and their owners from Intune
Krystina Kyle, 2022#>

Connect-AzureAD
$devices = Get-AzureADDevice | Where-Object {($_.DeviceOSType -notlike "Windows") -and ($_.IsManaged -eq $true) -and ($_.IsCompliant -eq $true)}
$ownersAndDevices = New-Object System.Data.DataTable
[void]$ownersAndDevices.Columns.Add("Display Name")
[void]$ownersAndDevices.Columns.Add("Email Address")
[void]$ownersAndDevices.Columns.Add("Device Type")

foreach($device in $devices){
    $owner = Get-AzureADDeviceRegisteredOwner -ObjectId $device.ObjectId
    if($device.DeviceOSType -like "AndroidForWork"){
        $os = "Android"
    }elseif($device.DeviceOSType -like "IPhone"){
        $os = "iOS"
    }
    [void]$ownersAndDevices.Rows.Add($owner.DisplayName, $owner.UserPrincipalName, $os)
}

#return $ownersAndDevices

$ownersAndDevices | Export-CSV -Path .\MDMDevicesandOwners.csv -NoTypeInformation

$ownersAndDevices.clear()
