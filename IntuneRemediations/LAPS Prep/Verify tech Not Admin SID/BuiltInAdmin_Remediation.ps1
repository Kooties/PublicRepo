$accname = "tech"

Rename-LocalUser -Name $accname -NewName "Administrator"
Disable-LocalUser -Name "Administrator"
New-LocalUser -Name $accname -Description "LAPS Account" -Password $pw
Add-LocalGroupMember -Group "Administrators" -Member $accname
Write-Host "Created account and added to admin group"