Function Get-RandomPassword
{
    #define parameters
    param([int]$PasswordLength = 20)
 
    #ASCII Character set for Password
    $CharacterSet = @{
            Uppercase   = (97..122) | Get-Random -Count 10 | % {[char]$_}
            Lowercase   = (65..90)  | Get-Random -Count 10 | % {[char]$_}
            Numeric     = (48..57)  | Get-Random -Count 10 | % {[char]$_}
            SpecialChar = (33..47)+(58..64)+(91..96)+(123..126) | Get-Random -Count 10 | % {[char]$_}
    }
 
    #Frame Random Password from given character set
    $StringSet = $CharacterSet.Uppercase + $CharacterSet.Lowercase + $CharacterSet.Numeric + $CharacterSet.SpecialChar
 
    $str = -join(Get-Random -Count $PasswordLength -InputObject $StringSet) | ConvertTo-SecureString -AsPlainText -Force
    return $str
}

$pw = Get-RandomPassword
$accname = "tech"

$acc = get-localuser -Name $accname -ErrorAction Continue
if($acc){
    Set-LocalUser -Name $accname -Password $pw
    Write-Host "Set password"
}else{
    New-LocalUser -Name $accname -Description "LAPS Account" -Password $pw
    Add-LocalGroupMember -Group "Administrators" -Member $accname
    Write-Host "Created account and set password"
}
