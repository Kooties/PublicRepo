$accname = "tech" #Enter the account name you want to use here
$acc = get-localuser -Name $accname -ErrorAction Continue

#See if account exists and has a password
if($acc){
    if($acc.Enabled -eq $false){
        Enable-LocalUser -Name $accname
    }
        #Make sure account isn't the local admin account renamed
    if($acc.sid -match "S-1-5-21-\d{10}-\d{10}-\d{10}-500"){
        Write-Host "Acct default SID; needs remediation"
        Exit 1;
    }
    if(!$acc.passwordlastset){
        Write-Host "Acct doesn't have password; needs remediation"
        Exit 1;
    }
}else{
    Write-Host "Acct doesn't exist; needs remediation"
    Exit 1;
}

