# Set the URL variable
$URL = "ENTER URL HERE"

# Get the user's profile directory
$userProfile = [System.Environment]::GetFolderPath('UserProfile')

# Combine with the "Downloads" folder
$DownloadPath = [System.IO.Path]::Combine($userProfile, 'Downloads')

# Download the file
$FileName = [System.IO.Path]::GetFileName($URL)
$DownloadFilePath = [System.IO.Path]::Combine($DownloadPath, $FileName)

Write-Host "Downloading file from $URL to $DownloadFilePath"
Invoke-WebRequest -Uri $URL -OutFile $DownloadFilePath

# Check if the download was successful
if (Test-Path -Path $DownloadFilePath) {
    Write-Host "File downloaded successfully to $DownloadFilePath"

    # Uncomment the line below for installing an EXE file silently
    Start-Process -FilePath $DownloadFilePath -ArgumentList "/S" -Wait
}
else {
    Write-Host "Failed to download the file from $URL"
}
