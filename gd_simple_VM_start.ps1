<#
    .DESCRIPTION
        An example runbook which gets all the ARM resources using the Run As Account (Service Principal)

    .NOTES
        AUTHOR: Azure Automation Team
        LASTEDIT: Mar 14, 2016
#>

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}
Write-Output "TenantId: " $servicePrincipalConnection.TenantId
Write-Output "Application Id: " $servicePrincipalConnection.ApplicationId

Select-AzureSubscription -Default "e44a16f2-bbb5-46b8-83a5-c8151022e318"

#Get all ARM resources from all resource groups
$ResourceGroups = Get-AzureRmResourceGroup 

#Write-Output "Available resource groups: " $ResourceGroups

Write-Output "First resource group : " $ResourceGroups[0]
$MyResGroup = $ResourceGroups[0]
$MyVM_1 = Get-AzureVM -Name "gdtc" -ServiceName "gdtc"

Write-Output "My VM is : " $MyVM_1
<#
foreach ($ResourceGroup in $ResourceGroups)
{    
    Write-Output ("Showing resources in resource group " + $ResourceGroup.ResourceGroupName)
    $Resources = Find-AzureRmResource -ResourceGroupNameContains $ResourceGroup.ResourceGroupName | Select ResourceName, ResourceType
    ForEach ($Resource in $Resources)
    {
        Write-Output ($Resource.ResourceName + " of type " +  $Resource.ResourceType)
    }
    Write-Output ("")
} 
#>