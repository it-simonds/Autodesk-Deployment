#domain controller IP 
$ipAddress = "10.153.1.10"

#Size of a complete installation folder
$expectedSize = 3509962297

#Function to calculate the current installation folder size if it doesn exist
function Get-FolderSize {
    param (
        [string]$folderPath
    )
    if (Test-Path $folderPath) {
        #Sum up all the file's sizes
        $folderSize = (Get-ChildItem -Path $folderPath -Recurse | Measure-Object -Property Length -Sum).Sum
        return $folderSize
    }
    return 0
}


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
        if ($currentSize -eq $expectedSize) {           
            return  #If the complete folder is already present, exit the script
        } else {
        
        }
    } else {
        
    }

    #If on the company network, and folder doesn't exist/not the expected size
    if ($pingResult) {       
        & $scriptToRun
    } else {
        
    }
}

Check-IPAddress
