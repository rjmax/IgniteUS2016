param
(
    [Parameter(Mandatory=$true, HelpMessage="Provide a password to store in the KeyVault")]
    [securestring] $password
)

#create the resource group
New-AzureRmResourceGroup -Name KeyVaultDemo -Location westus -Force

#create the keyvault. note that this command is not idempotent.
#New-AzureRmKeyVault -VaultName Ignite2016 -ResourceGroupName KeyVaultDemo -EnabledForTemplateDeployment -Location westus
$vault = Get-AzureRmKeyvault -VaultName Ignite2016 -ResourceGroupName KeyVaultDemo

#create/set the secret
$secret = Set-AzureKeyVaultSecret -VaultName Ignite2016 -Name MySecret -SecretValue $password

#echo the vault id
Write-Host Vault Id: $vault.ResourceId

#echo the vault secret
Write-Host Secret Id: $secret.Name

$TemplateUri = "https://raw.githubusercontent.com/rjmax/IgniteUS2016/master/KeyVault/azuredeploy.json"
$TemplateParameterUri = "https://raw.githubusercontent.com/rjmax/IgniteUS2016/master/KeyVault/azuredeploy.parameters.json"

#Deploy using the secret
New-AzureRmResourceGroupDeployment -ResourceGroupName KeyVaultDemo -TemplateUri $TemplateUri -TemplateParameterUri $TemplateParameterUri

#cleanup non-idempotent resources
#Remove-AzureRmKeyVault -VaultName Ignite2016 -ResourceGroupName KeyVaultDemo -Force