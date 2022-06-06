Add-Type -assembly "Microsoft.Office.Interop.Outlook"
add-type -assembly "System.Runtime.Interopservices"

$days = 1..31
$months = 1..12
$years = 1930..2014
$30dayMonths = 4,6,9,11

$openings = get-content -path .\dobOpenings.txt
$closings = get-content -path .\dobEndings.txt
$subjects = get-content -path .\emailSubjects.txt
$firstNames = get-content -path .\firstNames.txt
$lastNames = get-content -path .\lastNames.txt
$states = get-content -path .\states.txt
$templatePath = get-childitem ".\" -Filter "template.oft"

function New-SeedExample {
    param(
        [bool]$negIncluded,
        [bool]$negOnly
    )
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

    if($negOnly){
        $exampleTypes = 7..12
    }elseif ($negIncluded) {
        $exampleTypes = 1..14
    }else{
        $exampleTypes = 1..6
    }

    $example = $exampleTypes | get-random
    switch($example)
    {
        1 {$exampleData = "$open`My birthday is $monthName $day, $year$closing"}
        2 {$exampleData = "$open $firstName was born on the $dayst of $monthName, $year$closing"}
        3 {$exampleData = "$open My date of birth is $month/$day/$year$closing"}
        4 {$exampleData = "$open`:`nName: $firstName $lastName`nDOB: $month/$day/$year`nState: $state`nHere you go$closing"}
        5 {$exampleData = "$open My birthdate is $monthName $day, $year$closing"}
        6 {$exampleData = "$open My birthday is $month/$day/$year$closing"}
        7 {$exampleData = "$open I do not feel comfortable sharing that information at this time$closing"}
        8 {$exampleData = "$open I am not giving you that information$closing"}
        9 {$exampleData = "$open You should not need this information$closing"}
        10 {$exampleData = "$open`:`nName: $firstName $lastName `nDOB: N/A`nState: $state`nHere you are$closing"}
        11 {$exampleData = "$open You don't need my birthday for this$closing"}
        12 {$exampleData = "$open You don't need my birthdate for this$closing"}
        13 {$exampleData = "$open You don't need my birth day for this$closing"}
        14 {$exampleData = "$open You don't need my birth date for this$closing"}
    }
    
    return $exampleData
}
function new-EmailExample {
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        $body,$iteration,$savePath
    )

    $obj = New-Object -comObject Outlook.Application
    #$mail = $obj.CreateItemFromTemplate(".\template.oft")
    $Mail = $obj.CreateItemFromTemplate($templatePath.FullName.ToString())
    $Mail.Recipients.Add("email@email.com") | Out-Null
    $mail.Subject = $subjects | get-random
    $Mail.Body = $body
    $writePath = "$PSScriptRoot\$savePath\$iteration.msg"
    $Mail.SaveAs($writePath)
    $obj.quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($obj)  | Out-Null
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($mail)  | Out-Null
}

[uint16]$numberOfTXTExamples = Read-Host "How many TXT examples would you like?"
[uint16]$numberOfEMLExamples = Read-Host "How many EML examples would you like?"
$negativeIncluded = Read-Host "Do you need negative test cases included?`nPlease enter true or false:"
$negativeOnly = Read-Host "Do you ONLY need negative test cases?`nPlease enter true or false:"

try {
    $negativeIncluded = [System.Convert]::ToBoolean($negativeIncluded)
    $negativeOnly = [System.Convert]::ToBoolean($negativeOnly)
}
catch {
    {throw 'Error parsing booleans'}
}

if($negativeOnly -eq $true){
    $writePath = "onlyNegative"
}elseif($negativeIncluded -eq $false){
    $writePath = "onlyPositive"
}else{
    $writePath = "testCases"
}

for($i=1; $i -le $numberOfTXTExamples; $i++){
    $data = New-SeedExample -negIncluded $negativeIncluded -negOnly $negativeOnly
    $data | Out-File -FilePath ".\$writePath\$i.txt"
}

for($i=1; $i -le $numberOfEMLExamples; $i++){
    $data = New-SeedExample -negIncluded $negativeIncluded -negOnly $negativeOnly
    New-EmailExample -body $data -iteration $i -savePath $writePath
}
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($obj)  | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($mail)  | Out-Null