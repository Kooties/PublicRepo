$accname = "tech"

$acc = get-localuser -Name $accname -ErrorAction Continue

if($acc){
    if($acc.Enabled -eq $false){
        Enable-LocalUser -Name $accname
    }
    if($acc.passwordlastset){
        Write-Host "Account enabled w/ password"
        Exit 0;
    }else{    
        Write-Host "Account has no password; remediate"
        Exit 1;
    }
}else{
    Write-Host "Account does not exist; remediate"
    Exit 1;
}
