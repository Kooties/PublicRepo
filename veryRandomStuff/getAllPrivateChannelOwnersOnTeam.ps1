Connect-MicrosoftTeams

$teamName = Read-Host "What is the Display Name of the Team we'll we working within?"

$team = Get-Team -DisplayName $teamName

$privateChannels = Get-TeamChannel -GroupId $team.GroupId | Where-Object {$_.MembershipType -like "*Private*"}

$channelOwners = New-Object System.Data.DataTable
[void]$channelOwners.Columns.Add("Channel Name")
[void]$channelOwners.Columns.Add("Owner Name")

foreach($channel in $privateChannels){
    $owner = Get-TeamChannelUser -GroupId $team.GroupId -DisplayName $channel.DisplayName -Role Owner
    [void]$channelOwners.Rows.Add($channel.DisplayName,$owner.Name)
}

$channelOwners | Export-CSV -Path .\TeamsChannelOwners.csv -NoTypeInformation
$channelOwners.clear()