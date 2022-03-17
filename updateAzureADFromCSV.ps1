<#Update Active Directory reporting and titling based on a CSV.
Expected format for the CSV is EmployeeNumber,LastName,FirstName,PreferredFirstName,CurrentWorkEmail,SupervisorWorkEmail,
SupervisorName,JobTitle,DepartmentCode,DepartmentDescription,TypeCode (wherein DepartmentDescription is the title of the
department and TypeCode is People Manager or Individual Contributer)

NOTE:  This script does NOT update names or email addresses.

Krystina Kyle, 3/3/2022#>

connect-azuread

$csv = import-csv -path "\\this\is\the\path\to\the.csv"

foreach($csvuser in $csv){
    $user = get-azureaduser -ObjectId $csvuser.currentworkemail
    $supervisor = Get-AzureADUserManager -ObjectId $csvuser.currentworkemail
    <#Manager Checking#>
    if($supervisor.UserPrincipalName -notlike $csvuser.SupervisorWorkEmail){
        $actualSupervisor = Get-AzureADUser -ObjectId $csvuser.SupervisorWorkEmail
        Set-AzureADUserManager -ObjectId $csvuser.currentworkemail -RefObjectId $actualSupervisor.ObjectId
    }
    <#Title Checking#>
    if($csvuser.JobTitle -notlike $user.JobTitle){
        Set-AzureADUser -ObjectId $csvuser.CurrentWorkEmail -JobTitle $csvuser.JobTitle
    }
    <#Department and Type Code Checking#>
    $department = ($csvuser.DepartmentDescription + " - " + $csvuser.TypeCode)
    if($department -notlike $user.department){
        Set-AzureADUser -ObjectId $csvuser.CurrentWorkEmail -Department $department
    }
}