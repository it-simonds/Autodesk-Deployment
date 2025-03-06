function Get-MostFrequentUserByProfile {
    # Get the list of user profile directories, exclude profiles starting with "TEMP.DOMAIN" or "adm_"
    $profiles = Get-ChildItem "C:\Users" | Where-Object {
        $_.PSIsContainer -and
        $_.Name -notlike '*$' -and
        $_.Name -notlike 'TEMP.DOMAIN*' -and
        $_.Name -notlike 'adm_*'
    }

    # Sort the profiles by LastWriteTime and take the most recent one
    $mostRecentProfile = $profiles | Sort-Object LastWriteTime -Descending | Select-Object -First 1

    return $mostRecentProfile.Name
}

if (-not (Test-Path "C:\Temp")) {
    New-Item -ItemType Directory -Path "C:\Temp" | Out-Null
}


$currentUser = Get-MostFrequentUserByProfile

#$currentUser

$checkPath = "C:\Program Files\Autodesk\AutoCAD 2024"

$currentUser = Get-MostFrequentUserByProfile

$teamsWebhookURL = "https://simondshomes.webhook.office.com/webhookb2/af8d07d0-e8e6-44d8-8975-9cdbce5953a3@1379b3f8-7aa6-4b14-bf01-09b99c4f69a7/IncomingWebhook/86151ee8fef549849e843bdb0bb5bd62/902300e5-bfa8-48a3-aef5-c918d9be140d"

if (Test-Path $checkpath){
	$message = @{
    "@type" = "MessageCard"
    "@context" = "http://schema.org/extensions"
    summary = "Autocad Installation"
    themeColor = "0072C6"
    title = "Autocad Installation Completed"
    text = "Autocad FULL 2024 already exists on $currentUser."
	} | ConvertTo-Json

	Invoke-RestMethod -Uri $teamsWebhookURL -Method Post -ContentType "application/json" -Body $message
	
	return
}


# AWS S3 URL for the Autocad installation zip
$s3BucketURL = "https://autocad-sims.s3.ap-southeast-2.amazonaws.com/AutocadDeployment.zip"
$localZipPath = "C:\Temp\AutocadFullDeployment.zip"
$extractFolder = "C:\"
$installBatFile = "C:\AutocadDeployment\Install Autocad2024.bat"



# Download the installation zip from S3

Invoke-WebRequest -Uri $s3BucketURL -OutFile $localZipPath


# Extract the downloaded zip

Add-Type -AssemblyName 'System.IO.Compression.FileSystem'
[System.IO.Compression.ZipFile]::ExtractToDirectory($localZipPath, $extractFolder)


# Run the installation batch file

Start-Process -FilePath $installBatFile -Wait -WindowStyle Hidden


$checkPath = "C:\Program Files\Autodesk\AutoCAD 2024"

# Teams Webhook URL (Replace with your actual Teams webhook URL)
$teamsWebhookURL = "https://simondshomes.webhook.office.com/webhookb2/af8d07d0-e8e6-44d8-8975-9cdbce5953a3@1379b3f8-7aa6-4b14-bf01-09b99c4f69a7/IncomingWebhook/86151ee8fef549849e843bdb0bb5bd62/902300e5-bfa8-48a3-aef5-c918d9be140d"

if (Test-Path $checkpath){
	$message = @{
    "@type" = "MessageCard"
    "@context" = "http://schema.org/extensions"
    summary = "Autocad Installation"
    themeColor = "0072C6"
    title = "Autocad Installation Completed"
    text = "The installation of Autocad FULL VERSION has been successfully completed on computer $currentUser."
	} | ConvertTo-Json

	Invoke-RestMethod -Uri $teamsWebhookURL -Method Post -ContentType "application/json" -Body $message
	
	return
}
