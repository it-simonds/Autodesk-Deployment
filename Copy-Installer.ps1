# IP of the Domain Controller
$ipAddress = "10.153.1.10"

# Expected size of the folder in bytes (3,509,962,297 bytes)
$expectedSize = 3509962297

# Function to calculate the folder size
function Get-FolderSize {
    param (
        [string]$folderPath
    )
    
    if (Test-Path $folderPath) {
        # Calculate folder size by summing the size of all files
        $folderSize = (Get-ChildItem -Path $folderPath -Recurse | Measure-Object -Property Length -Sum).Sum
        return $folderSize
    }
    return 0  # Return 0 if folder doesn't exist
}

# Main script that will install the Vault Client
$scriptToRun = {
    # Location of the installation files
    $networkPath = "\\10.153.1.10\DData\Brobs\AutocadDeployment"
    $extractFolder = "C:\"

    # Copy the installation files from the network path to the local machine
    
    Copy-Item -Path $networkPath -Destination $extractFolder -Recurse -Force
    
}

# Check if the IP is online using ping
function Check-IPAddress {
    $pingResult = Test-Connection -ComputerName $ipAddress -Count 1 -Quiet
    $folderPath = "C:\AutocadDeployment"

    # Check if the folder exists and if its size matches the expected size
    if (Test-Path $folderPath) {
        $currentSize = Get-FolderSize -folderPath $folderPath
        if ($currentSize -eq $expectedSize) {            
            return  # Exit if the folder exists and its size matches the expected size
        } else {            
        }
    } else {
        
    }

    # If the server is reachable and the folder size is incorrect or folder doesn't exist, run the main script
    if ($pingResult) {
        
        & $scriptToRun
    } else {
        
    }
}

# Run the function to check IP and run the script if necessary
Check-IPAddress
