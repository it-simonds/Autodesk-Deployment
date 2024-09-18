#Ip of our DC
$ipAddress = "10.153.1.10"

#Main script that will install the Vault Client
$scriptToRun = {
    
	#Location of the installation file
	$networkPath = "\\10.153.1.10\DData\Brobs\AutocadDeployment"

	$extractFolder = "C:\"

	Copy-Item -Path $networkPath -Destination $extractFolder -Recurse -Force
	
}

# Check if the IP is online using ping
function Check-IPAddress {
    $pingResult = Test-Connection -ComputerName $ipAddress -Count 1 -Quiet
	
	#Path that determines if Install files are already present
    $file1 = "C:\AutocadDeployment\image\Installer.exe"
	$file2 = "C:\AutocadDeployment\image\RemoveODIS.exe"
	$file3 = "C:\AutocadDeployment\Install Autocad2024.bat"
    
    if (Test-Path $file1 -and Test-Path $file2 -and Test-Path $file3) {
        return  #Script doesn't run if it already exists
    }

    if ($pingResult) {
        & $scriptToRun #If computer is on the network, then run the script
    } else {
		#If its not on the network, then it checks back in an hour.
    }
}

Check-IPAddress