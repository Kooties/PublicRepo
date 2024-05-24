<#Install Chrome using the latest installer available from Google#>
$Path = $env:TEMP
$Installer = "chrome_installer.exe"
Invoke-WebRequest "https://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $Path$Installer
Start-Process -FilePath $Path$Installer -Args "/silent /install" -Verb RunAs -Wait
Remove-Item $Path$Installer

<# This portion of the combined script has been sourced from the
Google Workspace Admin Help center here https://support.google.com/a/answer/9250996?hl=en&fl=1&sjid=3323556608127888066-NA
and modified to remove portions not necessary for an Intune
deployment, including admin checking, verifying that domains are
added to the "allowed to log in" list, and user-facing error handling -Krys#>

<# This script downloads Google Credential Provider for Windows from
https://tools.google.com/dlpage/gcpw/, then installs and configures it.
Windows administrator access is required to use the script. #>

<# Set the following key to the domains you want to allow users to sign in from.

For example:
$domainsAllowedToLogin = "acme1.com,acme2.com"
#>

$domainsAllowedToLogin = "acme1.com,acme2.com"

<# Choose the GCPW file to download. 32-bit and 64-bit versions have different names #>
$gcpwFileName = 'gcpwstandaloneenterprise.msi'
if ([Environment]::Is64BitOperatingSystem) {
    $gcpwFileName = 'gcpwstandaloneenterprise64.msi'
}

<# Download the GCPW installer. #>
$gcpwUrlPrefix = 'https://dl.google.com/credentialprovider/'
$gcpwUri = $gcpwUrlPrefix + $gcpwFileName
Write-Host 'Downloading GCPW from' $gcpwUri
Invoke-WebRequest -Uri $gcpwUri -OutFile $gcpwFileName

<# Run the GCPW installer and wait for the installation to finish #>
$arguments = "/i `"$gcpwFileName`""
$installProcess = (Start-Process msiexec.exe -ArgumentList $arguments -PassThru -Wait)

<# Check if installation was successful #>
if ($installProcess.ExitCode -ne 0) {
    exit $installProcess.ExitCode
}

<# Set the required registry key with the allowed domains #>
$registryPath = 'HKEY_LOCAL_MACHINE\Software\Google\GCPW'
$name = 'domains_allowed_to_login'
[microsoft.win32.registry]::SetValue($registryPath, $name, $domainsAllowedToLogin)
