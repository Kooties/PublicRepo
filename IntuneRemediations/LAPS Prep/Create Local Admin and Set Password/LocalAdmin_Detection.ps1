$accname = "tech"

if($acc = get-localuser -Name $accname){
    if($acc.Enabled -eq $false){
        Enable-LocalUser -Name $accname
    }
    if($acc.passwordlastset){
        Exit 0;
    }else{
        Exit 1;
    }
}else{
    Exit 1;
}