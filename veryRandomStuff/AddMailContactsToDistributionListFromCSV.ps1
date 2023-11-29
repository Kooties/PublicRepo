<#Takes a CSV with First, Last, and Email fields and adds those to a new or existing Distribution List in O365#>

Import-Module ExchangeOnlineManagement
Add-Type -AssemblyName System.Windows.Forms
Connect-ExchangeOnline

<#Initializing the .NET object for the File Browser; only allows selection of CSV files#>
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
InitialDirectory = [Environment]::GetFolderPath('Desktop') 
Filter = 'Comma Separated Values File (.csv)|*.CSV' }

$logFile = "C:\Logs\NewDistributionList.log"
   
<#Name of the Distribution list#>
$groupName = Read-Host -Prompt "Name of the Distribution Group being Created or Added To"
#Write-Host "Successfully read $groupName"
Write-Host "Please select the CSV to read user information from:"
Start-Sleep -seconds 1


<#Pops up a file window to take the CSV to be added to the distribution list#>
$null = $FileBrowser.ShowDialog()

<#Fills the Objects and People To Add variables for use later#>
$objectsToAdd = Import-Csv -Path $FileBrowser.FileName
#Write-Host "Successfully filled `$objectsToAdd"
$peopleToAdd=@()
#Write-Host "Successfully created `$peopleToAdd"

<#Creates a Mail Contact to later add to the Distribution List if one does not yet exist#>
foreach($objectToAdd in $objectsToAdd){
    try{
        $temp = Get-MailContact -Identity $objectToAdd.Email -ErrorAction Stop | Out-Null
        Write-Host "$temp is a pre-existing MailContact" -ErrorAction Stop
        Add-Content -Path $logfile -Value "$temp is a pre-existing MailContact" 
        $peopleToAdd += $temp.EmailAddresses.substring(5)
        #Write-Host "$temp added to PeopleToAdd"
    }catch{
        New-MailContact -Name ($objectToAdd.First + " " + $objectToAdd.Last) -ExternalEmailAddress $objectToAdd.Email | Out-Null
        Write-Host "New mail contact created for $objectToAdd.First $objectToAdd.Last"
        Add-Content -Path $logfile -Value "New mail contact created for $objectToAdd.First $objectToAdd.Last" 
        $peopleToAdd += $objectToAdd.Email
        #Write-Host "New person added to people"
    }
}

<#Variable for users who were not added to the distribution list so they don't get lost in the fray of logging#>
$usersToCheckManually=@()
<#Adds mail contacts created in last bit to distribution list.  If the distribution list does not yet exist,
the Catch statement creates the list.#>
try{
    Get-DistributionGroup -identity $groupName -ErrorAction Stop
    foreach($personToAdd in $peopleToAdd){
        try{
            Add-DistributionGroupMember -identity $groupName -member $personToAdd -ErrorAction Stop | Out-Null
            Write-Host "Added $personToAdd to $groupName"
            Add-Content -Path $logfile -Value "Added $personToAdd to $groupName" 
        }catch{
            Write-Host "$personToAdd could not be added programmatically"
            Add-Content -Path $logfile -Value "$personToAdd could not be added programmatically" 
            $usersToCheckManually += $personToAdd
        }
    }
}catch{
    New-DistributionGroup -Name $groupName | Out-Null
    Write-Host "Created $groupName"
    Add-Content -Path $logfile -Value "Created $groupName" 
        foreach($personToAdd in $peopleToAdd){
        try{
            Add-DistributionGroupMember -identity $groupName -member $personToAdd -ErrorAction Stop | Out-Null
            Write-Host "Added $personToAdd to $groupName"
            Add-Content -Path $logfile -Value "Added $personToAdd to $groupName" 
        }catch{
            Write-Host "$personToAdd could not be added programmatically"
            $usersToCheckManually += $personToAdd
            Add-Content -Path $logfile -Value "$personToAdd could not be added programmatically" 
        }
    }
}

Write-Host "$usersToCheckManually need to be manually checked and possibly added"
Add-Content -Path $logfile -Value "$usersToCheckManually need to be manually checked and possibly added" 

Write-Host "Script End"
Add-Content -Path $logfile -Value "Script End" 










$allMailboxes = Get-User -ResultSize unlimited | Where-Object {$_.UserPrincipalName -like "*butcherbox.com"}

<#Use $permGroup for if you are using a mail-enabled security group#>
$permGroup = get-group -identity "PeopleOpsRecruiting@MASXLLC.onmicrosoft.com"
$groupMembers = $permGroup.members

foreach($mailbox in $allMailboxes){
    if($mailbox.WhenCreated -gt [DateTime]::Now.AddDays(-14)){
        foreach($member in $groupMembers){
            $name = $mailbox.exchangeobjectid
            try {Add-MailboxFolderPermission -Identity $name`:\Calendar -User $member -AccessRights LimitedDetails}
            catch {Set-MailboxFolderPermission -Identity $name`:\Calendar -User $member -AccessRights LimitedDetails}
       }
    }
}