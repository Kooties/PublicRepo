$virtual_networks = Get-AzVirtualNetwork | Select -Property Name, ResourceGroupName, Location



del azvirtualnetwork.txt



write-host "VNET-Name, ResourceGroupName, Location, VNET CIDRs, Subnets_Name1, Subnets_CIDRs1, Subnets_Name2, Subnets_CIDRs2, Subnets_Name3, Subnets_CIDRs3, Subnets_Name4, Subnets_CIDRs4, Subnets_Name5, Subnets_CIDRs5, Subnets_Name6, Subnets_CIDRs6, Subnets_Name7, Subnets_CIDRs7"
Write-Output "VNET-Name, ResourceGroupName, Location, VNET CIDRs, Subnets_Name1, Subnets_CIDRs1, Subnets_Name2, Subnets_CIDRs2, Subnets_Name3, Subnets_CIDRs3, Subnets_Name4, Subnets_CIDRs4, Subnets_Name5, Subnets_CIDRs5, Subnets_Name6, Subnets_CIDRs6, Subnets_Name7, Subnets_CIDRs7" >> azvirtualnetwork.txt




foreach ($vn in $virtual_networks) {

$AddressPrefixes = (Get-AzVirtualNetwork -Name ($vn).Name | Select -ExpandProperty AddressSpace).AddressPrefixes
$SubnetsNames = Get-AzVirtualNetwork -Name ($vn).Name | Select -ExpandProperty Subnets | Select -Property Name, AddressPrefix | ConvertTo-Json | jq -r '[.[] | .Name, .AddressPrefix[]] | @csv'
$SubnetsNames_replace = $SubnetsNames -replace '\"',''
$SubnetsNames_split = $SubnetsNames_replace -split ","
$VNET_Name = if ($vn.Name) { $vn.Name } else { 'null' }
$VNET_ResourceGroupName = if ($vn.ResourceGroupName) { $vn.ResourceGroupName } else { 'null' }
$Location = if ($vn.location) { $vn.location } else { 'null' }
$VNET_CIDRs = if ($AddressPrefixes) { $AddressPrefixes } else { 'null' }
$Subnets_Name1 = if ($SubnetsNames_split[0]) { $SubnetsNames_split[0] } else { 'null' }
$Subnets_CIDRs1 = if ($SubnetsNames_split[1]) { $SubnetsNames_split[1] } else { 'null' }
$Subnets_Name2 = if ($SubnetsNames_split[2]) { $SubnetsNames_split[2] } else { 'null' }
$Subnets_CIDRs2 = if ($SubnetsNames_split[3]) { $SubnetsNames_split[3] } else { 'null' }
$Subnets_Name3 = if ($SubnetsNames_split[4]) { $SubnetsNames_split[4] } else { 'null' }
$Subnets_CIDRs3 = if ($SubnetsNames_split[5]) { $SubnetsNames_split[5] } else { 'null' }
$Subnets_Name4 = if ($SubnetsNames_split[6]) { $SubnetsNames_split[6] } else { 'null' }
$Subnets_CIDRs4 = if ($SubnetsNames_split[7]) { $SubnetsNames_split[7] } else { 'null' }
$Subnets_Name5 = if ($SubnetsNames_split[8]) { $SubnetsNames_split[8] } else { 'null' }
$Subnets_CIDRs5 = if ($SubnetsNames_split[9]) { $SubnetsNames_split[9] } else { 'null' }
$Subnets_Name6 = if ($SubnetsNames_split[10]) { $SubnetsNames_split[10] } else { 'null' }
$Subnets_CIDRs6 = if ($SubnetsNames_split[11]) { $SubnetsNames_split[11] } else { 'null' }
$Subnets_Name7 = if ($SubnetsNames_split[12]) { $SubnetsNames_split[12] } else { 'null' }
$Subnets_CIDRs7 = if ($SubnetsNames_split[13]) { $SubnetsNames_split[13] } else { 'null' }

Write-Host "$VNET_Name, $VNET_ResourceGroupName, $Location, $VNET_CIDRs, $Subnets_Name1, $Subnets_CIDRs1, $Subnets_Name2, $Subnets_CIDRs2, $Subnets_Name3, $Subnets_CIDRs3, $Subnets_Name4, $Subnets_CIDRs4, $Subnets_Name5, $Subnets_CIDRs5, $Subnets_Name6, $Subnets_CIDRs6, $Subnets_Name7, $Subnets_CIDRs7"
Write-Output "$VNET_Name, $VNET_ResourceGroupName, $Location, $VNET_CIDRs, $Subnets_Name1, $Subnets_CIDRs1, $Subnets_Name2, $Subnets_CIDRs2, $Subnets_Name3, $Subnets_CIDRs3, $Subnets_Name4, $Subnets_CIDRs4, $Subnets_Name5, $Subnets_CIDRs5, $Subnets_Name6, $Subnets_CIDRs6, $Subnets_Name7, $Subnets_CIDRs7" >> .\azvirtualnetwork.txt
}