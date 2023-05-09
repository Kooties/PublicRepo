$accname = "tech"

$acc = Get-LocalUser $accname

if($accname.sid -match "S-1-5-21-\d{10}-\d{10}-\d{10}-500"){
    return 1;
}