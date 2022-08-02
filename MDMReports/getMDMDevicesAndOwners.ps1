<#PS Script to get MDM managed devices and their owners from Intune
Krystina Kyle, 2022#>

Connect-AzureAD
Connect-PnPOnline -url "$sharepointURL"
$dateTime = Get-Date
$date = $dateTime.ToShortDateString().replace('/','-')
$fileName = "MDM Installed $date.csv"
$devices = Get-AzureADDevice -all $true | Where-Object {($_.DeviceOSType -notlike "Windows") -and ($_.IsManaged -eq $true) -and ($_.IsCompliant -eq $true)}
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

$string = $ownersAndDevices | ConvertTo-Csv -NoTypeInformation | Out-String
$content = [System.Text.Encoding]::UTF8.GetBytes($string)
$stream = [System.IO.MemoryStream]$content

Add-PnPFile -FileName $fileName -Folder "Shared Documents/MDM Installed" -Stream $stream -ContentType "Document"

$ownersAndDevices.clear()
Disconnect-AzureAD
Disconnect-PnPOnline
