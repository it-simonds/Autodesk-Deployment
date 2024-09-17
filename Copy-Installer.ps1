#Ip of our DC
$ipAddress = "10.153.1.10"

#Main script that will install the Vault Client
$scriptToRun = {
    
	#Location of the installation file
	$networkPath = "\\10.153.1.10\DData\Brobs\AutocadDeployment"

	$extractFolder = "C:\AutocadDeployment"

	Copy-Item -Path $networkPath -Destination $extractFolder -Recurse -Force
	
}

# Check if the IP is online using ping
function Check-IPAddress {
    $pingResult = Test-Connection -ComputerName $ipAddress -Count 1 -Quiet
	
	#Path that determines if Install files are already present
    $extractFolder = "C:\AutocadDeployment"
    
    if (Test-Path $extractFolder) {
        return  #Script doesn't run if it already exists
    }

    if ($pingResult) {
        & $scriptToRun #If computer is on the network, then run the script
    } else {
		#If its not on the network, then it checks back in an hour.
    }
}

Check-IPAddress