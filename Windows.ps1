$vcenter="192.168.88.3"
$account="ACCOUNT@vsphere.local"
$password="PASSWORD"

Connect-VIServer -Server $vcenter -Username $account -Password $password

$vmhost="192.168.88.1"
$namestart="Test"
$template="TestTemp"
$datastore="datastore1"
$custsysprep=Get-OSCustomizationSpec TestSpec
$ipstart="192.168.88."
$endipscope=100..102

foreach ($endip in $endipscope) 
{
	$name=$namestart+$endip
	$ip=$ipstart+$endip
	$mask="255.255.255.0"
	$gate="192.168.88.254"
	$dns="192.168.88.3"
	$custsysprep | Set-OScustomizationSpec -NamingScheme fixed -NamingPrefix $name
	$custsysprep | Get-OSCustomizationNicMapping | Set-OSCustomizationNicMapping -IpMode UseStaticIP -IpAddress $ip -SubnetMask $mask -DefaultGateway $gate -Dns $dns
	New-VM -vmhost $vmhost -Name $name -Template $template -Datastore $datastore -OSCustomizationspec $custsysprep
	Start-VM -vm $name -RunAsync
}
