$task = Get-ScheduledTask -TaskName "Fix Exclusive Audio Control"

if($task){
    Write-Host "Scheduled Task Already Exists"
    Exit 0
}else{
    Write-Host "Installing"
    Exit 1
}