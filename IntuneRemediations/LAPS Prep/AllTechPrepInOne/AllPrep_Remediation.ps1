Function Get-RandomPassword
{
    #define parameters
    param([int]$PasswordLength = 20)
 
    #ASCII Character set for Password
    $CharacterSet = @{
            Uppercase   = (97..122) | Get-Random -Count 10 | ForEach-Object {[char]$_}
            Lowercase   = (65..90)  | Get-Random -Count 10 | ForEach-Object {[char]$_}
            Numeric     = (48..57)  | Get-Random -Count 10 | ForEach-Object {[char]$_}
            SpecialChar = (33..47)+(58..64)+(91..96)+(123..126) | Get-Random -Count 10 | ForEach-Object {[char]$_}
    }
 
    #Frame Random Password from given character set
    $StringSet = $CharacterSet.Uppercase + $CharacterSet.Lowercase + $CharacterSet.Numeric + $CharacterSet.SpecialChar
 
    $str = -join(Get-Random -Count $PasswordLength -InputObject $StringSet) | ConvertTo-SecureString -AsPlainText -Force
    return $str
}

$accname = "tech"
$pw = Get-RandomPassword
$acc = get-localuser -Name $accname -ErrorAction Continue
#See if account exists and has a password
if($acc){
    if($acc.Enabled -eq $false){
        Enable-LocalUser -Name $accname
    }
    #Make sure account isn't the local admin account renamed
    if($acc.sid -match "S-1-5-21-\d{10}-\d{10}-\d{10}-500"){
        Rename-LocalUser -Name $accname -NewName "Administrator"
        Disable-LocalUser -Name "Administrator"
        New-LocalUser -Name $accname -Description "LAPS Account" -Password $pw
        Write-Host "Renamed default admin and created LAPS account"
    }
}else{
    New-LocalUser -Name $accname -Description "LAPS Account" -Password $pw
    Write-Host "Created LAPS account"
}