$DomainName = (Get-ADDomain).DNSRoot
$DCList = Get-ADDomainController -Filter * -Server $DomainName | Select-Object Hostname,Site,OperatingSystem

$logObject = New-Object PSOBject -Property @{
    Date = $date
    Time = $time
    EventID = $eventID
    Domain = $domain
    ErrorCode = $errorCode
    MachineName = $machineName
    IPAddress = $ipAddress
}
$allIssues = @{}

foreach($dc in $dclist){
    $logFile = "\\$dc\c$\Windows\debut\netlogon.log"
    $backupLogFile = "\\$dc\c$\Windows\debut\netlogon.bak"
    $log = get-content $logFile
    $backupLog = get-content $backupLogFile
    $fullLogs = $log + $backupLog
    foreach($fullLog in $fullLogs){
        $allIssues += [PSCustomObject]@{
            Date = $date
            Time = $time
            EventID = $eventID
            Domain = $domain
            ErrorCode = $errorCode
            MachineName = $machineName
            IPAddress = $ipAddress
        }
    }
}