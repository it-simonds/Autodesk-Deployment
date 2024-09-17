#Ip of our DC
$ipAddress = "10.153.1.10"

#Main script that will install the Vault Client
$scriptToRun = {
    
	#Location of the installation file
	$networkPath = "\\10.153.1.10\DData\Brobs\AutocadDeployment"

	$extractFolder = "C:\AutocadDeployment"

	#Make sure everything is consistent
	if (-not (Test-Path "C:\Temp")) {
		New-Item -Path "C:\Temp" -ItemType Directory
	}
	Copy-Item -Path $networkPath -Destination $extractFolder -Recurse
	
	#Bat file to install the thing
	$installBat = Join-Path -Path $extractFolder -ChildPath "Install Autocad2024.bat"

	#Start process hidden so that it doesn't interfere with user activity
	Start-Process -FilePath $installBat -WindowStyle Hidden -Wait
}

# Check if the IP is online using ping
function Check-IPAddress {
    $pingResult = Test-Connection -ComputerName $ipAddress -Count 1 -Quiet
    
    #Path that determines if Vault is already instealled
    $vaultProDeploymentPath = "C:\Program Files\Autodesk\Vault Client 2024"
    
    if (Test-Path $vaultProDeploymentPath) {
        return  #Script doesn't run if it already exists
    }

    if ($pingResult) {
        & $scriptToRun #If computer is on the network, then run the script
    } else {
		#If its not on the network, then it checks back in an hour.
    }
}

Check-IPAddress