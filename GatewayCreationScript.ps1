cls
#Environment Variables
$SubscriptionName = "Visual Studio Professional with MSDN"
$GatewayconfigurationFilePath= "E:\Projects\ApplicationGateway\GatewayConfiguration.xml"
#Environment Variables End

# The script has been tested on Powershell 3.0 
Set-StrictMode -Version 3 

# Check if Windows Azure Powershell is avaiable 
if ((Get-Module -ListAvailable Azure) -eq $null) 
{ 
    throw "Windows Azure Powershell not found! Please install from http://www.windowsazure.com/en-us/downloads/#cmd-line-tools" 
} 

#Popup to get azure account
Add-AzureAccount

#Get-AzureSubscription  
if($SubscriptionName -ne "")
{
	$subscription = Get-AzureSubscription -SubscriptionName $SubscriptionName
}
else
{
    $subscription = Get-AzureSubscription -Current
}

if($subscription -eq $null)
{
	Write-Host "Windows Azure Subscription is not configured or the specified subscription name is invalid."
    return
}

Set-AzureSubscription -SubscriptionName  $SubscriptionName

#Start creating Application Gateway
$checkGateway = Get-AzureApplicationGateway noscaleapplicationgateway
if($checkGateway -eq $null)
{
    New-AzureApplicationGateway -Name noscaleapplicationgateway -VnetName applicationgatewaynetwork -Subnets("Subnet-1")
}

Get-AzureApplicationGateway noscaleapplicationgateway

#Set Application Gateway Configuration
Set-AzureApplicationGatewayConfig -Name noscaleapplicationgateway -ConfigFile $GatewayconfigurationFilePath

#Start Gateway
Start-AzureApplicationGateway noscaleapplicationgateway

#Verify that gateway is running
Get-AzureApplicationGateway noscaleapplicationgateway

#Once you are done with running the sample, execute the following statement
#Remove-AzureApplicationGateway noscaleapplicationgateway