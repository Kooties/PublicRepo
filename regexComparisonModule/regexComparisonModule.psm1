function Compare-RegExDate{
    param(
        [string]$inputString
    )
    $regDay = '([0-3]{1}?[0-9]{1}|[\d])'
    $regYear = '([1-2][0-9]{3})|[\d]{2}'
    $months = '([Jj](an)(uary)?|[Ff](eb)(ruary)?|[Mm](ar)(ch)?|[Aa](pr)(il)?|[Mm](ay)|[Jj](un)(e)?|[Jj](ul)(y)?|[Aa](ug)(ust)?|[Ss](ep)(tember)?|[Ss](ept)|[Oo](ct)(ober)?|[Nn](ov)(ember)?|[Dd](ec)(ember)?)'
    $numericalMonths = '(([1][0-2])|[0][\d]{1}|[\d]{1})'

    $regEx1 = "(($regDay((\sof\s)|(\s?\-\s?)|\s|\/)($months|$numericalMonths))([,-\/]|\s)\s?($regYear))"
    $regEx2 = "(($months)\s$regDay[,]?\s($regYear))"
    $regEx3 = "($numericalMonths[\/\-,.]$regDay[\/\-,.]($regYear))"
    $regEx4 = "($regDay[\/\-,]$numericalMonths[\/\-,]($regYear))"

    $dateExpression = $regEx1+"|"+$regEx2+"|"+$regEx3+"|"+$regEx4

    if($inputString -match $dateExpression){
        return $true
    }else{
        return $false
    }
}

Export-ModuleMember -Function Compare-RegExDate