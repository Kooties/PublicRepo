Remove-Item -Path c:\Staging\audioExclusiveControlFix.ps1 -Force

Disable-ScheduledTask -TaskName "Fix Exclusive Audio Control"
Unregister-ScheduledTask -TaskName "Fix Exclusive Audio Control" -confirm:$false