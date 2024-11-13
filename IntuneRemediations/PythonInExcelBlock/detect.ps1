$regLocation = "HKCU:\Software\Policies\Microsoft\Office\16.0\excel\"
#reg add HKCU\software\policies\microsoft\office\16.0\excel\security /v PythonFunctionWarnings /t REG_DWORD /d 2 /f
$keys = get-childitem $reglocation

if($keys.getvalue("PythonFunctionWarnings" -ne 2)){
    Write-Host "Remediation Needed"
    Exit 1;
}else{
    Write-Host "Remediation Not Needed"
    Exit 0;
}