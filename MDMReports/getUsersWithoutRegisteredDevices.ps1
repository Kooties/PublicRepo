Connect-AzureAD
Connect-PnPOnline -url "$sharepointURL"

$domain = Get-AzureADDomain | Where-Object {($_.AuthenticationType -like "Federated")}
$domainName = $domain.Name
$dateTime = Get-Date
$date = $dateTime.ToShortDateString().replace('/','-')
$fileName = "MDM Not Installed $date.csv"

$activeUsers = Get-AzureADUser -all $true | Where-Object {($_.UserPrincipalName -like "*$domainName") -and ($_.UserType -like "Member") -and ($_.AssignedLicenses)}

$usersWithoutDevice = New-Object System.Data.DataTable
[void]$usersWithoutDevice.Columns.Add("Display Name")
[void]$usersWithoutDevice.Columns.Add("Email Address")

foreach($user in $activeUsers){
    $userDevices = Get-AzureADUserRegisteredDevice -ObjectId $user.ObjectId | Where-Object {($_.DeviceOSType -notlike "Windows") -and ($_.IsManaged -eq $true) -and ($_.IsCompliant -eq $true)}
    if(!$userDevices){
        [void]$usersWithoutDevice.Rows.Add($user.DisplayName,$user.UserPrincipalName)
    }
}


$string = $usersWithoutDevice | ConvertTo-Csv -NoTypeInformation | Out-String
$content = [System.Text.Encoding]::UTF8.GetBytes($string)
$stream = [System.IO.MemoryStream]$content

Add-PnPFile -FileName $fileName -Folder "Shared Documents/No MDM" -Stream $stream -ContentType "Document"

$usersWithoutDevice.clear()

Disconnect-AzureAD
Disconnect-PnPonline