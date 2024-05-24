$Path = $env:TEMP
$Installer = "chrome_installer.exe"
Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $Path$Installer
Start-Process -FilePath $Path$Installer -Args "/silent /install" -Verb RunAs -Wait
Remove-Item $Path$Installer

Start-Transcript c:\windows\temp\Logs\GCPWInstallerScript.log

<# This script downloads Google Credential Provider for Windows from
https://tools.google.com/dlpage/gcpw/, then installs and configures it.
Windows administrator access is required to use the script. #>

<# Set the following key to the domains you want to allow users to sign in from.

For example:
$domainsAllowedToLogin = "acme1.com,acme2.com"
#>

$domainsAllowedToLogin = "acme1.com,acme2.com"

#Add-Type -AssemblyName System.Drawing
#Add-Type -AssemblyName PresentationFramework

#<# Check if one or more domains are set #>
#if ($domainsAllowedToLogin.Equals('')) {
#    $msgResult = [System.Windows.MessageBox]::Show('The list of domains cannot be empty! Please edit this script.', 'GCPW', 'OK', 'Error')
#    exit 5
#}


<# Choose the GCPW file to download. 32-bit and 64-bit versions have different names #>

$installed = Test-Path -Path "C:\Program Files\Google\Credential Provider"

if(!$installed){
    $gcpwFileName = 'gcpwstandaloneenterprise64.msi'


<# Run the GCPW installer and wait for the installation to finish #>
$arguments = "/i `"$gcpwFileName`""
$installProcess = (Start-Process msiexec.exe -ArgumentList $arguments -PassThru -Wait)
}

<# Set the required registry key with the allowed domains #>
$registryPath = 'HKEY_LOCAL_MACHINE\Software\Google\GCPW'
$name = 'domains_allowed_to_login'
[microsoft.win32.registry]::SetValue($registryPath, $name, $domainsAllowedToLogin)

Stop-Transcript