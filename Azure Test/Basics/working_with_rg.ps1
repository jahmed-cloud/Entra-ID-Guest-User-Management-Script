# create Azure Resource Group

$RGroupName = "Powershell-rg"
$RGroupLocation = "Central India"

New-AzResourceGroup -Name $RGroupName -Location $RGroupLocation

# Remove Azure Resource Group

Remove-AzResourceGroup -Name $RGroupName -Force