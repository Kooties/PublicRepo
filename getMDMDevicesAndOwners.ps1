<#PS Script to get MDM managed devices and their owners from Intune
Krystina Kyle, 2022#>

Connect-AzureAD

$devices = Get-AzureADDevice | Where-Object {($_.DeviceOSType -notlike "Windows") -and ($_.IsManaged -eq $true)}
$ownersAndDevices = New-Object System.Data.DataTable
[void]$ownersAndDevices.Columns.Add("Display Name")
[void]$ownersAndDevices.Columns.Add("Email Address")
[void]$ownersAndDevices.Columns.Add("Device Type")
[void]$ownersAndDevices.Columns.Add("Is Managed")
[void]$ownersAndDevices.Columns.Add("Is Compliant")

foreach($device in $devices){
    $owner = Get-AzureADDeviceRegisteredOwner -ObjectId $device.ObjectId
    [void]$ownersAndDevices.Rows.Add($owner.DisplayName, $owner.UserPrincipalName, $device.DeviceOSType, $device.IsManaged, $device.IsCompliant)
}

return $ownersAndDevices
$ownersAndDevices.clear()