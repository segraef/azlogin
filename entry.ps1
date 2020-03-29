Param( 
  [string]$clientId,
  [string]$clientSecret,
  [string]$tenantId,
  [string]$subscriptionId,
  [string]$identity,
  [string]$environmentName
)
Try {
  if ($clientId -and $clientSecret -and $tenantId) {
    Write-Output "##########`nConnecting to Azure with service principal ...`n##########"
    $secureClientSecret = ConvertTo-SecureString -String "$clientSecret" -AsPlainText -Force
    $credentials = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $clientId, $secureClientSecret
    Connect-AzAccount -ServicePrincipal -Credential $credentials -Tenant $tenantId
    Get-AzContext
  }

  if ($clientId -and $clientSecret -and $tenantId -and $environmentName) {
    Write-Output "##########`nAn Azure environment was given.`n"
    Write-Output "Connecting to Azure with service principal ...`n##########"
    $secureClientSecret = ConvertTo-SecureString -String "$clientSecret" -AsPlainText -Force
    $credentials = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $clientId, $secureClientSecret
    Connect-AzAccount -ServicePrincipal -Credential $credentials -Tenant $tenantId -EnvironmentName $environmentName
    Get-AzContext
  }

  if ($identity -like "yes") {
    Write-Output "##########`nConnecting to Azure with identity ...`n##########"
    Connect-AzAccount -Identity
    Get-AzContext
  }

  if (($identity -like "yes") -and $environmentName) {
    Write-Output "##########`nAzure environment $environmentName was given.`n"
    Write-Output "Connecting to Azure with identity ...`n##########"
    Connect-AzAccount -Identity -EnvironmentName $environmentName
    Get-AzContext
  }

  if ($subscriptionId) {
    Write-Output "##########`nAn Azure subscription was given."
    Write-Output "Selecting subscription $subscriptionId ...`n##########"
    Set-AzContext -Subscription $subscriptionId
  }
}
Catch {
  $_.Exception.Message
  $_.Exception.ItemName
  Throw
}