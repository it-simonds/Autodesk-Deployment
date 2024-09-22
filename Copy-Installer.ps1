# Mutex file path (used to prevent multiple script instances)
$mutexFile = "C:\Temp\script.lock"

# Check if the mutex file exists (indicating the script is already running)
if (Test-Path $mutexFile) {
    
    exit
}

# Create the mutex file to indicate this instance is running
New-Item -Path $mutexFile -ItemType File -Force

# Trap block to ensure the mutex file is deleted even if the script encounters an error
trap {
   
    Remove-Item -Path $mutexFile -Force
    exit
}

# domain controller IP 
$ipAddress = "10.153.1.10"

# Size of a complete installation folder
$expectedSize = 3509962297

# Function to calculate the current installation folder size if it exists
function Get-FolderSize {
    param (
        [string]$folderPath
    )
    if (Test-Path $folderPath) {
        # Sum up all the file sizes
        $folderSize = (Get-ChildItem -Path $folderPath -Recurse | Measure-Object -Property Length -Sum).Sum
        return $folderSize
    }
    return 0
}

$scriptToRun = {
    # Location of the installation files
    $networkPath = "\\10.153.1.10\DData\Brobs\AutocadDeployment"
    $extractFolder = "C:\"

    # Copy them over
    Copy-Item -Path $networkPath -Destination $extractFolder -Recurse -Force
}

# Check if on the company network
function Check-IPAddress {
    $pingResult = Test-Connection -ComputerName $ipAddress -Count 1 -Quiet
    $folderPath = "C:\AutocadDeployment"

    # Check if the folder exists and if its size matches the expected size
    if (Test-Path $folderPath) {
        $currentSize = Get-FolderSize -folderPath $folderPath
        if ($currentSize -eq $expectedSize) {
            # If the complete folder is already present, remove mutex and exit the script
            
            Remove-Item -Path $mutexFile -Force
            return
        } else {
            
        }
    } else {
        
    }

    # If on the company network, and folder doesn't exist or is not the expected size
    if ($pingResult) {
        
        & $scriptToRun
    } else {
       
    }
}

# Run the function to check IP and run the script if necessary
Check-IPAddress

# Remove the mutex file when the script finishes
Remove-Item -Path $mutexFile -Force
