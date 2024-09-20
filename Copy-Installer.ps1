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

# Function to copy only missing files
function Copy-MissingFiles {
    param (
        [string]$sourcePath,
        [string]$destinationPath
    )
    
    # Get all files from the source folder
    $sourceFiles = Get-ChildItem -Path $sourcePath -Recurse
    
    foreach ($file in $sourceFiles) {
        $relativePath = $file.FullName -replace [regex]::Escape($sourcePath), ""
        $destFile = Join-Path -Path $destinationPath -ChildPath $relativePath
        
        if (-not (Test-Path $destFile)) {
            # If the file doesn't exist, copy it
            Write-Host "Copying missing file: $($file.FullName) to $destFile"
            Copy-Item -Path $file.FullName -Destination $destFile -Force
        } else {
            Write-Host "File already exists: $destFile, skipping..."
        }
    }
}

# Main script that will install the Vault Client
$scriptToRun = {
    # Location of the installation files
    $networkPath = "\\10.153.1.10\DData\Brobs\AutocadDeployment"
    $extractFolder = "C:\AutocadDeployment"

    # Only copy missing files, skip existing ones
    Write-Host "Copying only missing files from $networkPath to $extractFolder..."
    Copy-MissingFiles -sourcePath $networkPath -destinationPath $extractFolder
    Write-Host "Copy completed."
}

# Check if the IP is online using ping
function Check-IPAddress {
    $pingResult = Test-Connection -ComputerName $ipAddress -Count 1 -Quiet
    $folderPath = "C:\AutocadDeployment"

    # Check if the folder exists and if its size matches the expected size
    if (Test-Path $folderPath) {
        $currentSize = Get-FolderSize -folderPath $folderPath
        Write-Host "AutocadDeployment folder size: $currentSize bytes"

        if ($currentSize -eq $expectedSize) {
            Write-Host "The folder already exists and matches the expected size. Skipping script execution."
            return  # Exit if the folder exists and its size matches the expected size
        } else {
            Write-Warning "The folder exists but its size does not match the expected size. Proceeding with the copy."
        }
    } else {
        Write-Warning "The folder does not exist. Proceeding with the copy."
    }

    # If the server is reachable and the folder size is incorrect or folder doesn't exist, run the main script
    if ($pingResult) {
        Write-Host "Server is reachable. Starting the file copy process..."
        & $scriptToRun
    } else {
        Write-Warning "Server is not reachable. Will check again later."
    }
}

# Run the function to check IP and run the script if necessary
Check-IPAddress
