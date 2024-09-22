#Main script that will install the Vault Client
$scriptToRun = {
 	
	$extractFolder = "C:\AutocadDeployment"
	
	#Bat file to install the thing
	$installBat = Join-Path -Path $extractFolder -ChildPath "Install Autocad2024.bat"

	#Start process hidden so that it doesn't interfere with user activity
	Start-Process -FilePath $installBat -WindowStyle Hidden -Wait
}

# Check if the IP is online using ping
function Check-IPAddress {
	
    #Path that determines if Vault is already instealled
    $vaultProDeploymentPath = "C:\Program Files\Autodesk\AutoCAD 2024"
    
    if (Test-Path $vaultProDeploymentPath) {
        return  #Script doesn't run if it already exists
    }

    if (-not (Test-Path $vaultProDeploymentPath)) {
        & $scriptToRun #If computer is on the network, then run the script
    } else {
		#If its not on the network, then it checks back in an hour.
    }
}

Check-IPAddress
