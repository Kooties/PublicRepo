$connection = Get-AutomationConnection -Name AzureRunAsConnection

Connect-AzureAD -tenantId $connection.TenantId -ApplicationId $connection.ApplicationId -CertificateThumbprint $connection.CertificateThumbprint
Connect-PnPOnline -ClientId $connection.ApplicationId -url "$sharepointURL" -tenant $tenantName -Thumbprint $connection.CertificateThumbprint
$domain = Get-AzureADDomain | Where-Object {($_.AuthenticationType -like "Federated")}
$domainName = $domain.Name
$dateTime = Get-Date
$date = $dateTime.ToShortDateString().replace('/','-')
$hasMDMReportName = "MDM Installed $date.csv"
$noMDMReportName = "MDM Not Installed $date.csv"
$thisMonthsParts = $dateTime.ToShortDateString().replace('/','-') | ConvertFrom-String -Delimiter "\-"
$thisMonthsComparator = "MDM Installed " + $thisMonthsParts.P1.ToString() + "-[\d]{1,2}-" + $thisMonthsParts.P3.ToString() + ".csv"
$lastMonthsDateTime = (Get-Date).AddDays(-31)
$lastMonthsParts = $lastMonthsDateTime.ToShortDateString().replace('/','-') | ConvertFrom-String -Delimiter "\-"
$lastMonthsComparator = "MDM Installed " + $lastMonthsParts.P1.ToString() + "-[\d]{1,2}-" + $lastMonthsParts.P3.ToString() + ".csv"
$comparisonFileName = "MDM Change Log $date.csv"
$devices = Get-AzureADDevice -all $true | Where-Object {($_.DeviceOSType -notlike "Windows") -and ($_.IsManaged -eq $true) -and ($_.IsCompliant -eq $true)}
$ownersAndDevices = New-Object System.Data.DataTable
[void]$ownersAndDevices.Columns.Add("Display Name")
[void]$ownersAndDevices.Columns.Add("Email Address")
[void]$ownersAndDevices.Columns.Add("Device Type")
$changes = New-Object System.Data.DataTable
[void]$changes.Columns.Add("Display Name")
[void]$changes.Columns.Add("Email Address")
[void]$changes.Columns.Add("Change Type")

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
$stream1 = [System.IO.MemoryStream]$content

$file1 = Add-PnPFile -FileName $hasMDMReportName -Folder "Shared Documents/MDM Reporting/MDM Installed" -Stream $stream1 -ContentType "Document"
$ownersAndDevices.clear()
[void]$ownersAndDevices.Columns.Remove("Device Type")

$activeUsers = Get-AzureADUser -all $true | Where-Object {($_.UserPrincipalName -like "*$domainName") -and ($_.UserType -like "Member") -and ($_.AssignedLicenses)}

foreach($user in $activeUsers){
    $userDevices = Get-AzureADUserRegisteredDevice -ObjectId $user.ObjectId | Where-Object {($_.DeviceOSType -notlike "Windows") -and ($_.IsManaged -eq $true) -and ($_.IsCompliant -eq $true)}
    if(!$userDevices){
        [void]$ownersAndDevices.Rows.Add($user.DisplayName,$user.UserPrincipalName)
    }
}

$string = $ownersAndDevices | ConvertTo-Csv -NoTypeInformation | Out-String
$content = [System.Text.Encoding]::UTF8.GetBytes($string)
$stream2 = [System.IO.MemoryStream]$content

$file2 = Add-PnPFile -FileName $noMDMReportName -Folder "Shared Documents/MDM Reporting/No MDM" -Stream $stream2 -ContentType "Document"

$ownersAndDevices.clear()

$sharepointFiles = Get-PnPFolderItem -FolderSiteRelativeUrl "Shared Documents/MDM Reporting/MDM Installed"

foreach($file in $sharepointFiles){
    if($file.Name -match $thisMonthsComparator){
        $thisMonthsReportName = $file.Name
    }elseif($file.Name -match $lastMonthsComparator){
        $lastMonthsReportName = $file.Name
    }
}

$thisMonthsReport = Get-PnPFile -url "$sharepointURL/Shared Documents/MDM Reporting/MDM Installed/$thisMonthsReportName" -AsString | ConvertFrom-Csv
$lastMonthsReport = Get-PnPFile -url "$sharepointURL/Shared Documents/MDM Reporting/MDM Installed/$lastMonthsReportName" -AsString | ConvertFrom-Csv

foreach($line in $thisMonthsReport){
    $inReport = $lastMonthsReport | Where-Object {$_."Email Address" -eq $line."Email Address"}
    if(!$inReport){
        $name = $line."Display Name"
        $email = $line."Email Address"
        [void]$changes.Rows.Add($name, $email, "Added")
    }
}

foreach($line in $lastMonthsReport){
    $inReport = $thisMonthsReport | Where-Object {$_."Email Address" -eq $line."Email Address"}
    if(!$inReport){
        $name = $line."Display Name"
        $email = $line."Email Address"
        [void]$changes.Rows.Add($name, $email, "Removed")
    }
}

$string = $changes | ConvertTo-Csv -NoTypeInformation | Out-String
$content = [System.Text.Encoding]::UTF8.GetBytes($string)
$stream3 = [System.IO.MemoryStream]$content

$file3 = Add-PnPFile -FileName $comparisonFileName -Folder "Shared Documents/MDM Reporting/Change Logs" -Stream $stream3 -ContentType "Document"


$changes.clear()

Disconnect-AzureAD
Disconnect-PnPOnline