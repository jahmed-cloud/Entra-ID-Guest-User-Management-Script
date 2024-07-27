# Connecting to Jahmed Azure Subscription

$ClientID ="f655056d-880f-4550-a4b2-e576edc2c646"
$ClientSecret = "EOC8Q~CVbOLnhDFGr5RxGs_JvW4bkRbFo138Scrs"
$TenantID = "d565c00a-c6ad-417e-9c9e-2f9a34c58c39"
$SecureSecret = $ClientSecret | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential `
-ArgumentList $ClientID,$SecureSecret

Connect-AzAccount -ServicePrincipal -Credential $Credential -Tenant $TenantID

# create Azure Resource Group

$RGroupName = "Powershell-rg"
$RGroupLocation = "Central India"

New-AzResourceGroup -Name $RGroupName -Location $RGroupLocation

Get-AzResourceGroup
