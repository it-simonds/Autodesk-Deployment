#Mutex file path
$mutexFile = "C:\Temp\script.lock"

#To check if the script's already running
if (Test-Path $mutexFile) {
    exit
}

#Create the mutex file if script isnt already running
New-Item -Path $mutexFile -ItemType File -Force

#Trap block to ensure the mutex file is deleted
trap {
    Remove-Item -Path $mutexFile -Force
    exit
}

#DC IP
$ipAddress = "10.153.1.10"

#Size of a complete installation folder
$expectedSize = 3509962297

#Check if AutoCAD 2024 is already installed
$autocadFolderPath = "C:\Program Files\Autodesk\AutoCAD 2024"

if (Test-Path $autocadFolderPath) {
    Remove-Item -Path $mutexFile -Force
    exit
}

#Calculate folder size
function Get-FolderSize {
    param (
        [string]$folderPath
    )
    if (Test-Path $folderPath) {
        
        $folderSize = (Get-ChildItem -Path $folderPath -Recurse | Measure-Object -Property Length -Sum).Sum
        return $folderSize
    }
    return 0
}

#Main script to copy the files
$scriptToRun = {
    #Location of the installation files
    $networkPath = "\\10.153.1.10\DData\Brobs\AutocadDeployment"
    $extractFolder = "C:\"

    #Copy them over
    Copy-Item -Path $networkPath -Destination $extractFolder -Recurse -Force
}

#Check if on the company network
function Check-IPAddress {
    $pingResult = Test-Connection -ComputerName $ipAddress -Count 1 -Quiet
    $folderPath = "C:\AutocadDeployment"

    #Check if the folder exists and if its size matches the expected size
    if (Test-Path $folderPath) {
        $currentSize = Get-FolderSize -folderPath $folderPath
        if ($currentSize -ge $expectedSize) {
            # If the folder size is greater than or equal to the expected size, exit the script
            Remove-Item -Path $mutexFile -Force
            return
        } else {
            
        }
    } else {
        
    }

    #If on the company network, and folder doesn't exist or is not the expected size
    if ($pingResult) {
        
        & $scriptToRun
		Remove-Item -Path $mutexFile -Force
    } else {
        
    }
}

Check-IPAddress

#Remove the mutex file when the script finishes
Remove-Item -Path $mutexFile -Force
