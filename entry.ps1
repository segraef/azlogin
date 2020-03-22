Param( 
  [string]$clientId,
  [string]$clientSecret,
  [string]$tenantId,
  [string]$subscriptionId
)

if ($clientId -and $clientSecret -and $tenantId) {
  $secureClientSecret = ConvertTo-SecureString -String "$clientSecret" -AsPlainText -Force
  $credentials = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $clientId, $secureClientSecret
  Connect-AzAccount -ServicePrincipal -Credential $credentials -Tenant $tenantId
}
else {
  Write-Output "One of the required parameters for Azure Login is not set: clientId, clientSecret or tenantId"
  exit
}

if ($subscriptionId) {
  Set-AzContext $subscriptionId
}
else {
  $subscriptions = Get-AzSubscription
  if (-not $subscriptions) {
    Write-Output "subscriptionId is not set."
    exit
  }
}