Connect-AzureAD

$users = get-azureADUser -all

Add-MailboxFolderPermission -Identity Employees@MASXLLC.onmicrosoft.com:\Calendar -User PeopleOpsRecruiting@MASXLLC.onmicrosoft.com -AccessRights LimitedDetails -SharingPermissionFlags None