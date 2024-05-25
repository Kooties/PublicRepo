Set-Location "C:\Program Files\Google\Credential Provider"
$folder = Get-Item *

Set-Location $folder.Name

.\gcp_setup.exe /uninstall /quiet