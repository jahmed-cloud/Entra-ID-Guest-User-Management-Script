# create Azure Resource Group

$RGroupName = "Powershell-rg"
$RGroupLocation = "Central India"

$ResoruceGroup = New-AzResourceGroup -Name $RGroupName -Location $RGroupLocation

"Provisioning state" + $ResoruceGroup.ProvisioningState

$ResoruceGroup

$ExisitingResourceGroup = Get-AzResourceGroup -Name $RGroupName

$AllResourceGroup = Get-AzResourceGroup

foreach($Group in $AllResourceGroup)
{
    'Removing Resource Group' + $Group.ResourceGroupName
    Remove-AzResourceGroup -Name $Group.ResourceGroupName -Force
}