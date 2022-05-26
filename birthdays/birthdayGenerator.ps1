Add-Type -assembly "Microsoft.Office.Interop.Outlook"
add-type -assembly "System.Runtime.Interopservices"

$days = 1..31
$months = 1..12
$years = 1900..2014
$30dayMonths = 4,6,9,11

$openings = get-content -path .\dobOpenings.txt
$closings = get-content -path .\dobEndings.txt
$subjects = get-content -path .\emailSubjects.txt
$firstNames = get-content -path .\firstNames.txt
$lastNames = get-content -path .\lastNames.txt
$states = get-content -path .\states.txt
$templatePath = get-childitem ".\" -Filter "*.oft"

function New-SeedExample {
    $day = $days | get-random
    $month = $months | get-random
    $year = $years | get-random
    $open = $openings | get-random
    $closing = $closings | get-random
    $firstName = $firstNames | get-random
    $lastName = $lastNames | get-random
    $state = $states | get-random
    if($30dayMonths -contains $month){
        while($day > 30){
            $day = $days | get-random
        }
    }
    if($month -eq 2){
        if($year%4 -eq 0){
            while($day > 29){
                $day = $days | get-random
            }
        }else{
            while($day > 28){
                $day = $days | get-random
            }
        }
    }
    switch ($month)
    {
        1 {$monthName = "January"}
        2 {$monthName = "February"}
        3 {$monthName = "March"}
        4 {$monthName = "April"}
        5 {$monthName = "May"}
        6 {$monthName = "June"}
        7 {$monthName = "July"}
        8 {$monthName = "August"}
        9 {$monthName = "September"}
        10 {$monthName = "October"}
        11 {$monthName = "November"}
        12 {$monthName = "December"}
    }
    switch($day)
    {
        1 {$dayst = "1st"}
        2 {$dayst = "2nd"}
        3 {$dayst = "3rd"}
        21 {$dayst = "21st"}
        31 {$dayst = "31st"}
        22 {$dayst = "22nd"}
        23 {$dayst = "23rd"}
        Default {
            $dayst = "$day" + "th"
        }
    }
    $exampleTypes = 1..4
    $example = $exampleTypes | get-random
    switch($example)
    {
        1 {$exampleData = "$open$monthName $day, $year$closing"}
        2 {$exampleData = "$open the $dayst of $monthName, $year$closing"}
        3 {$exampleData = "$open$month/$day/$year$closing"}
        4 {$exampleData = "$open`:`nName: $firstName $lastName`nDOB: $month/$day/$year`nState: $state`n Here you go$closing"}
    }
    
    return $exampleData
}
function new-EmailExample {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        $body,$iteration
    )

    $obj = New-Object -comObject Outlook.Application
    #$mail = $obj.CreateItemFromTemplate(".\template.oft")
    $Mail = $obj.CreateItemFromTemplate($templatePath.FullName.ToString())
    $Mail.Recipients.Add("email@email.com") | Out-Null
    $mail.Subject = $subjects | get-random
    $Mail.Body = $body
    $writePath = "$PSScriptRoot\birthdays\$iteration.msg"
    $Mail.SaveAs($writePath)
    $obj.quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($obj) | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($mail)  | Out-Null
}

[uint16]$numberOfTXTExamples = Read-Host "How many TXT examples would you like?"
[uint16]$numberOfEMLExamples = Read-Host "How many EML examples would you like?"

for($i=1; $i -le $numberOfTXTExamples; $i++){
    $data = New-SeedExample
    $data | Out-File -FilePath ".\birthdays\$i.txt"
}

for($i=1; $i -le $numberOfEMLExamples; $i++){
    $data = New-SeedExample
    New-EmailExample -body $data -iteration $i
}