Connect-AzureAD

$domain = Get-AzureADDomain | Where-Object {($_.AuthenticationType -like "Federated")}
$domainName = $domain.Name

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

$usersWithoutDevice | Export-Csv -Path .\MDMusersWithoutDevices.csv -NoTypeInformation

$usersWithoutDevice.clear()
