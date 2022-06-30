function Compare-RegExDate{
    param(
        [string]$inputString
    )
    <#Day, Year, Month, and Numbered Months will be the same format no matter which date format we use, so setting variables#>
    $regDay = '([0-3]{1}?[0-9]{1}|[\d])'
    $regYear = '([1-2][0-9]{3})|[\d]{2}'
    $months = '([Jj](an)(uary)?|[Ff](eb)(ruary)?|[Mm](ar)(ch)?|[Aa](pr)(il)?|[Mm](ay)|[Jj](un)(e)?|[Jj](ul)(y)?|[Aa](ug)(ust)?|[Ss](ep)(tember)?|[Ss](ept)|[Oo](ct)(ober)?|[Nn](ov)(ember)?|[Dd](ec)(ember)?)'
    $numericalMonths = '(([1][0-2])|[0][\d]{1}|[\d]{1})'
    <#Using an arrayList so we can adaptavely add different formats later if needed, and can step through each comparison separately without having to
    load the whole thing at once#>
    [System.Collections.ArrayList]$testRegEx = @() 

    <#Different date formats; optional parts of the date will be shown in square brackets, with $day, $month, and $year representing their
    respective noun.  $year should be noted to be either a 2 or 4 digit representation of year.#>

    <#This regex will match dates formatted as:"$day[nd] [day] [of] $month[,][ ][up to six other words, like 'in the year of our Lord'] $year"#>
    $testRegEx += "(($regDay([\D]{2})?(\s[Dd]ay)?((\sof\s)|(\s?\-\s?)|\s|\/)($months|$numericalMonths))([,-\/]|\s)(([\s]?(\w*)[\s]){0,6})?\s?($regYear))"
    <#This regex will match dates formatted as:"$month $day [,] $year"#>
    $testRegEx += "(($months)\s$regDay[,]?\s($regYear))"
    <#This regex will match dates formatted as:"$month/$day/$year".  Allows for a forwardslash, hypen, comma, or period between#>
    $testRegEx += "($numericalMonths[\/\-,.]$regDay[\/\-,.]($regYear))"
    <#This regex will match dates formatted as:"$day/$month/$year".  Allows for a forwardslash, hypen, comma, or period between#>
    $testRegEx += "($regDay[\/\-,]$numericalMonths[\/\-,]($regYear))"
    <#This regex will match dates formatted as ISO 8601:"$year/$month/$day".  Allows for a forwardslash, hypen, comma, or period between#>
    $testRegEx += "($regYear[\/\-,]$numericalMonths[\/\-,]($regDay))"

    <#Steps through each entry on the ArrayList and tests the input string.  If a match is found, returns the boolean value $true and ends function.
    If a match is not found, will return the boolean value $false before ending function.#>
    foreach($testCase in $testRegEx){
        if($inputString -match $testCase){
            return $true
        }
    }
    return $false
}

function Compare-RegExDriversLicense{
    param(
        [string]$inputString
    )
    <#Using arrayLists so we can adaptavely add different formats later if needed, and can step through each comparison separately without having to
    load the whole thing at once#>
    [System.Collections.ArrayList]$testRegEx = @()
    [System.Collections.ArrayList]$regexDLKeywords = @()
    [System.Collections.ArrayList]$regexTrackingKeywords = @() 
    
    <#The following includes every driver's license format found within the United States.  Each format is a different entry, even for states with multiple
    formats having been used in recent history.  Effort has been made to purge duplicate expressions.#>
    $testRegEx += '([\d]{7,8})'
    $testRegEx += '([\d]{7})'
    $testRegEx += '([a-zA-Z][\d]{8})'
    $testRegEx += '([\d]{9})'
    $testRegEx += '([9][\d]{8})'
    $testRegEx += '([a-zA-Z][\d]{7})'
    $testRegEx += '([\d]{2}\-[\d]{3}\-[\d]{4})'
    $testRegEx += '([a-zA-Z]{1}[\d]{12})'
    $testRegEx += '([a-zA-Z]{1}[\d]{3}(\s|\.|\-)?)[\d]{3}(\s|\.|\-)?)[\d]{2}(\s|\.|\-)?[\d]{3})(\s|\.|\-)?)[\d]{1})'
    $testRegEx += '([a-zA-Z]{1}[\d]{3}(\s|\.|\-)?[\d]{3}(\s|\.|\-)?[\d]{3}(\s|\.|\-)?[\d]{3})'
    $testRegEx += '([a-zA-Z]{1}[\d]{8})'
    $testRegEx += '([a-zA-Z]{2}[\d]{6}[a-zA-Z]{1})'
    $testRegEx += '([a-zA-Z]{1}[\d]{3}(\s|\.|\-)?[\d]{4}(\s|\.|\-)?[\d]{4})'
    $testRegEx += '([\d]{4}(\s|\.|\-)?[\d]{2}(\s|\.|\-)?[\d]{4})'
    $testRegEx += '([\d]{3}[a-zA-Z]{2}[/d]{4})'
    $testRegEx += '([a-zA-Z]{1}[\d]{2}(\s|\.|\-)?[\d]{2}(\s|\.|\-)?[\d]{4})'
    $testRegEx += '([a-zA-Z]{1}[\d]{2}(\s|\.|\-)?[\d]{3}(\s|\.|\-)?[\d]{3})'
    $testRegEx += '([a-zA-Z]{1}[\d]{9})'
    $testRegEx += '([\d]{3}(\s|\.|\-)[\d]{2}(\s|\.|\-)[\d]{4})'
    $testRegEx += '(([\d]{9}[0]{4})|([0-1]{1}[0-9]{1}[\d]{3}[1-2]{1}[\d]{3}41[0-3]{1}[0-9]{1}))'
    $testRegEx += '([\d]{10})'
    $testRegEx += '([0]{1}[0-9]{1}|[1]{1}[0-2]{1})[a-zA-Z]{3}[\d]{2}([0-2]{1}[/d]{1}|[3]{1}[0-1]{1})[\d]{1})'
    $testRegEx += '([a-zA-Z]{1}[\d]{14})'
    $testRegEx += '([a-zA-Z]{1}[\d]{4}(\s|\.|\-)[/d]{5}(\s|\.|\-)[/d]{5})'
    $testRegEx += '([/d]{9})'
    $testRegEx += '([/d]{3}[/d]{3}[/d]{3})'
    $testRegEx += '([/d]{12})'
    $testRegEx += '([a-zA-Z]{3}(\s|\.|\-)?[\d]{2}(\s|\.|\-)?[\d]{4})'
    $testRegEx += '([a-zA-Z]{1}[\d]{4,8})'
    $testRegEx += '([a-zA-Z]{2}[\d]{3,7})'
    $testRegEx += '([\d]{2}(\s|\.|\-)?[\d]{3}(\s|\.|\-)?[\d]{3})'
    $testRegEx += '([\d]{7}[a-zA-Z]{1})'
    $testRegEx += '([a-zA-Z]{1}[\d]{2}(\s|\.|\-)[\d]{2}(\s|\.|\-)[\d]{4})'
    $testRegEx += '([a-zA-Z]{3}[\*]{2}[a-zA-Z]{2}[\d]{3}[a-zA-Z]{1}[\d]{1})'
    $testRegEx += '([a-zA-Z]{1}[\d]{6})'
    $testRegEx += '([a-zA-Z]{1}[\d]{13}'
    $testRegEx += '([a-zA-Z]{1}[\d]{3}}(\s|\.|\-)[\d]{4}(\s|\.|\-)[\d]{4}(\s|\.|\-)[\d]{2})'
    $testRegEx += '([\d]{6}}(\s|\.|\-)[\d]{3})'

    $regexDLKeywords += '([Dd]riv((e)|(ing)))'
    $regexDLKeywords += '([Ll]icense)'

    $regexTrackingKeywords += '([Uu]([Ss])?[Pp][Ss]))'
    $regexTrackingKeywords += '([Ff](ed)[Ee](x))'
    $regexTrackingKeywords += '([Dd][Hh][Ll])'
    $regexTrackingKeywords += '([Tt](rack)(ing)?)'
    $regexTrackingKeywords += '([Ll](a)([Ss]|[Zz])(er)'
    $regexTrackingKeywords += '([Ss](hip)(ping)?)'

    <#Steps through each entry on the ArrayList and tests the input string.  If a match is found, returns the boolean value $true and ends function.
    If a match is not found, will return the boolean value $false before ending function.#>
    foreach($testCase in $testRegEx){
        if($inputString -match $testCase){
            if($inputString -match $regexTrackingKeywords){
                return $false
            }else{
                return $true
            }
        }else{

        }
    }
    return $false
}



Export-ModuleMember -Function Compare-RegExDate
Export-ModuleMember -Function Compare-RegExDriversLicense