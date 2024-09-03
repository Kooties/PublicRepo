<#This is literally taken from Reddit: https://www.reddit.com/r/Intune/comments/1b8wf8x/adjusting_communication_settings_via_remediation/#>

if(((Get-ItemProperty HKCU:\Software\Microsoft\Multimedia\Audio).UserDuckingPreference)){
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Multimedia\Audio -Name UserDuckingPreference -Value 3
}else{
    New-ItemProperty -Path HKCU:\Software\Microsoft\Multimedia\Audio -Name UserDuckingPreference -PropertyType "DWord" -Value 3 | Out-Null
}