Connect-AzureAd
$userEmail = "Person@contoso.com"

$apps = Get-AzureADApplication -all $true
$ownedApps = [System.Collections.ArrayList]@()

foreach($application in $apps){
    $owner = Get-AzureADApplicationOwner -ObjectId $application.ObjectId
    if($owner.UserPrincipalName -like $userEmail){
        $ownedApps += $application
    }
}

$ownedApps | Select-Object -Property DisplayName,AppId,ObjectId | Export-Csv -Path .\PersonsApplications.csv

$groups = Get-AzureADGroup -all $true
$ownedGroups = [System.Collections.ArrayList]@()

foreach($group in $groups){
    $owner = Get-AzureADGroupOwner -ObjectId $group.ObjectId
    if($owner.UserPrincipalName -like $userEmail){
        $ownedGroups += $group
    }
}

$ownedGroups | Select-Object -Property DisplayName,ObjectId,Description | Export-Csv -Path .\PersonsGroups.csv

$principals = Get-AzureADServicePrincipal -all $true
$ownedServicePrincipals = [System.Collections.ArrayList]@()
$servicePrincipalsWithOwners = [System.Collections.ArrayList]@()
$ServicePrincipals = New-Object System.Data.DataTable
[void]$ServicePrincipals.Columns.Add("Display Name")
[void]$ServicePrincipals.Columns.Add("Owner")
[void]$ServicePrincipals.Columns.Add("Object ID")

foreach($principal in $principals){
    $owner = Get-AzureADServicePrincipalOwner -ObjectId $principal.ObjectId
    if($owner){
        $ServicePrincipals.Rows.Add($principal.DisplayName,$owner.DisplayName)
    }
    if($owner.UserPrincipalName -like $userEmail){
        $ownedServicePrincipals += $principal
    }
}

foreach($principal in $servicePrincipalsWithOwners){
    $owner = Get-AzureADServicePrincipalOwner -ObjectId $principal.ObjectId
    $null = $ServicePrincipals.Rows.Add($principal.DisplayName,$owner.DisplayName,$principal.ObjectId)
}

$string = $ServicePrincipals | ConvertTo-Csv -NoTypeInformation | Out-String
$content = [System.Text.Encoding]::UTF8.GetBytes($string)
$stream1 = [System.IO.MemoryStream]$content

$ownedServicePrincipals | Select-Object -Property DisplayName,ObjectId,Description | Export-Csv -Path .\PersonsServicePrincipals.csv

$ServicePrincipals | Export-Csv -Path .\AllOwnedServicePrincipals.csv -NoTypeInformation