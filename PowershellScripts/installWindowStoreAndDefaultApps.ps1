# This script is a generic script for logging information on your desktop to help troubleshoot errors
# Put this code at the beginning of your Powershell script

# Variables that require input
$logName = "PowershellScriptLog" # Change this to something of your choosing
$logFolder = "Log" # Change this folder name to something of your choosing
$logPath = "$Env:Programfiles\$logFolder" 

Start-Transcript -Path "$logPath\$logFolder\$logName.log" -Force
# ----------------------------------------Place Script Below This Line------------------------------------------------------------ 

# This script will download the URL you specify, extract the file, then run the files you request

# Variables that require input
$packageURL = "https://github.com/lixuy/LTSC-Add-MicrosoftStore/archive/2019.zip"

# Pre-set variables (optional to change)
$fileLocation = "C:\Windows\Temp"
$zipName = "scripts.zip"
$zipFolder = "scripts"
$outpath = "$fileLocation/$zipName"

# Create Hash Table - Edit the extensions to include any extensions you want to run
$scriptExtensions=
@(
    'cmd'
    'ps1'
)

# Download Zip folder to temp location
Invoke-WebRequest -Uri $packageURL -OutFile $outpath

# Extract Zip folder
Expand-Archive -Path "$fileLocation/$zipName" -DestinationPath "$fileLocation/$zipFolder"


# Search for all cmd files and run the script
$n = 1
foreach($scriptExtension in $scriptExtensions) 
{
    # Search for all cmd files and run the script
        foreach($script in Get-ChildItem -Path "$fileLocation/$zipFolder" -Recurse *.$scriptExtension) 
    {
        $script.FullName
        Write-Host "Installing script #$n"
        Invoke-Item $script.FullName
        $n++
    }
}




# Winget test - Show the info so the scripts below don't fail.
winget --info

# Install Microsoft Photos
winget install -e --silent --accept-source-agreements --accept-package-agreements --id 9WZDNCRFJBH4
# Install Windows Calculator
winget install -e --silent --accept-source-agreements --accept-package-agreements --id 9WZDNCRFHVN5
# Install Windows Camera
winget install -e --silent --accept-source-agreements --accept-package-agreements --id 9WZDNCRFJBBG
# Install Windows Notepad
winget install -e --silent --accept-source-agreements --accept-package-agreements --id 9MSMLRH6LZF3

# ----------------------------------------Place Script Above This Line------------------------------------------------------------ 
Stop-Transcript