#path where you can dump all the device diagnostics downloaded via Intune
$path = "C:\path\to\folder\with\downloaded\diagnostics"
$zipDump = $path + "\dump"
$csvDump = $path + "\csvDump"
if(!(test-path $zipDump)){
    New-Item -Path $zipDump -ItemType Directory
}
if(!(test-path $csvDump)){
    New-Item -Path $csvDump -ItemType Directory
}

$content = get-childitem $path | where-object {$_.name -match "DiagLogs"}

#Unzipping everything
foreach($zip in $content){
    $zipPath = $zip.directoryname + "\" + $zip.name
    <#specifically unzipping into a directory related to the system name. As the diagnostics collected are named similarly
    between devices, we want to make sure there aren't any conflicts with file/directory names. Possibility of having
    multiple diagnostics files per machine will be taken care of when putting the CSV together later#>
    $folderName = $zipDump + "\" + $zip.Name
    if(!(test-Path $folderName)){
        New-Item -Path $folderName -ItemType Directory
    }
    Expand-Archive -path $zipPath -DestinationPath $folderName
    Remove-Item $zipPath -recurse -force
    $cabFolder = get-childitem $folderName | Where-Object{$_.Name -match "MDMDiagnostics_mdmlogs"}
    $cabFile = get-childitem $cabfolder.fullname
    expand.exe $cabFile.fullName -f:DeviceHash* $csvDump
    Remove-Item $folderName -recurse -force
}
Remove-Item $zipDump -recurse -force
#All Device Hashes should now be in their own folder, so we just need to combine them

$output = $path + "\output"
if(!(test-path $output)){
    New-Item -Path $output -ItemType Directory
}
$outCSV = $output + "\hardwareHashes.csv"

Get-ChildItem -Path $csvDump -Filter *.csv | Select-Object -ExpandProperty FullName | Import-Csv | Export-Csv -path $outCSV -NoTypeInformation -Append
Remove-Item $csvDump -recurse -force
