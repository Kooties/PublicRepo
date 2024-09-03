<#This is literally taken from Reddit: https://www.reddit.com/r/Intune/comments/1b8wf8x/adjusting_communication_settings_via_remediation/#>

if((Get-ItemProperty HKCU:\Software\Microsoft\Multimedia\Audio).UserDuckingPreference -eq 3){
    Write-Host "Compliant"
    exit 0
}else{
    Write-Host "Not compliant"
    exit 1
}