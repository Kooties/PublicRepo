$name = "Zoom"
$paths = [System.Collections.ArrayList]@()
$installedVersions = [System.Collections.ArrayList]@()
$installer = ".\ZoomInstallerFull.msi"
$version = Get-AppLockerFileInformation -Path $installer | Select-Object -ExpandProperty Publisher | Select-Object BinaryVersion

if([System.Environment]::Is64BitProcess){
    if(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"){
        $MachineRegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall";
        $null = $paths.Add($MachineRegistryPath)
    }
    if(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"){
        $UserRegistryPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall";
        $null = $paths.Add($UserRegistryPath)
    }
    if(Test-Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"){
        $MachineRegistryPath32bit = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall";
        $null = $paths.Add($MachineRegistryPath32bit)
    }
    if(Test-Path "HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"){
        $UserRegistryPath32bit = "HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall";
        $null = $paths.Add($UserRegistryPath32bit)
    }
}else{
    if(Test-Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"){
        $MachineRegistryPath32bit = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall";
        $null = $paths.Add($MachineRegistryPath32bit)
    }
    if(Test-Path "HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"){
        $UserRegistryPath32bit = "HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall";
        $null = $paths.Add($UserRegistryPath32bit)
    }
}

foreach($path in $paths){
    $RegistryKeys = Get-ChildItem -Path $path
    foreach($key in $RegistryKeys){
        if($key.GetValue("DisplayName") -like $name){
            $null = $installedVersions.Add([PSCustomObject]@{
                Name = $key.GetValue("DisplayName");
                Version = $key.GetValue("DisplayVersion");
                Path = $key
            })
        }
    }
}

foreach($installedVersion in $installedVersions){
    if($installedVersion.Version -ne $version){
        Return 0
    }else{
        Return 1707
    }
}




