Remove-Item -Path HKLM:\SOFTWARE\Google\GCPW -Force -Confirm:$false
Remove-Item -Path 'HKLM:\SOFTWARE\WOW6432Node\Google\Update\ClientState\{430FD4D0-B729-4F61-AA34-91526481799D}' -Force -Confirm:$false
Remove-Item -Path 'HKLM:\SOFTWARE\WOW6432Node\Google\Update\ClientState\{32987697-A14E-4B89-84D6-630D5431E831}' -Force -Confirm:$false

Set-Location "C:\Program Files\Google\Credential Provider"
$folder = Get-ChildItem
Set-Location $folder.Name
.\gcp_setup.exe /uninstall
