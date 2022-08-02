Connect-AzureAD
$sharepointURL = "Sharepoint Site URL"
Connect-PnPOnline -url $sharepointURL

$todaysDate = Get-Date
$thisMonthsParts = $todaysDate.ToShortDateString().replace('/','-') | ConvertFrom-String -Delimiter "\-"
$thisMonthsComparator = "MDM Installed " + $thisMonthsParts.P1.ToString() + "-[\d]{1,2}-" + $thisMonthsParts.P3.ToString() + ".csv"

$lastMonthsDateTime = (Get-Date).AddDays(-31)
$lastMonthsParts = $lastMonthsDateTime.ToShortDateString().replace('/','-') | ConvertFrom-String -Delimiter "\-"
$lastMonthsComparator = "MDM Installed " + $lastMonthsParts.P1.ToString() + "-[\d]{1,2}-" + $lastMonthsParts.P3.ToString() + ".csv"

$date = $todaysDate.ToShortDateString().replace('/','-')
$comparisonFileName = "MDM Change Log $date.csv"

$changes = New-Object System.Data.DataTable
[void]$changes.Columns.Add("Display Name")
[void]$changes.Columns.Add("Email Address")
[void]$changes.Columns.Add("Change Type")

$sharepointFiles = Get-PnPFolderItem -FolderSiteRelativeUrl "Shared Documents/Has MDM"

foreach($file in $sharepointFiles){
    if($file.Name -match $thisMonthsComparator){
        $thisMonthsReportName = $file.Name
    }elseif($file.Name -match $lastMonthsComparator){
        $lastMonthsReportName = $file.Name
    }
}

$thisMonthsReport = Get-PnPFile -url "S$sharepointURL/Has MDM/$thisMonthsReportName" -AsString | ConvertFrom-Csv
$lastMonthsReport = Get-PnPFile -url "S$sharepointURL/Has MDM/$lastMonthsReportName" -AsString | ConvertFrom-Csv

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
$stream = [System.IO.MemoryStream]$content

Add-PnPFile -FileName $comparisonFileName -Folder "Shared Documents/Change Logs" -Stream $stream -ContentType "Document"


$changes.clear()
Disconnect-AzureAD
Disconnect-PnPOnline
