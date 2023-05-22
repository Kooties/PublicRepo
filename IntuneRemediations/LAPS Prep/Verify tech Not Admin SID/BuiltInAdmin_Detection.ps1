$accname = "tech"

$acc = Get-LocalUser $accname

if($acc.sid -match "S-1-5-21-\d{10}-\d{10}-\d{10}-500"){
    Write-Host "Is 500; needs remediation"
    return 1;
}else{
    Write-Host "Is not 500; nothing necessary"
    return 0;
}