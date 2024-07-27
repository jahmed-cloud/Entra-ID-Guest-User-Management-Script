# create Azure Resource Group

$RGroupName = "Powershell-rg"
$RGroupLocation = "Central India"

New-AzResourceGroup -Name $RGroupName -Location $RGroupLocation

# Remove Azure Resource Group

Remove-AzResourceGroup -Name $RGroupName -Force

# Remove all Azure Resource Group

$ExisitingResourceGroup = Get-AzResourceGroup -Name $RGroupName

$AllResourceGroup = Get-AzResourceGroup

foreach($Group in $AllResourceGroup)
{
    'Removing Resource Group' + $Group.ResourceGroupName
    Remove-AzResourceGroup -Name $Group.ResourceGroupName -Force
}