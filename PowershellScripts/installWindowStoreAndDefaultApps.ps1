# This script is a generic script for logging information on your desktop to help troubleshoot errors
# Put this code at the beginning of your Powershell script

# Variables that require input
$logName = "PowershellScriptLog" # Change this to something of your choosing
$logFolder = "Log" # Change this folder name to something of your choosing
$logPath = "$Env:Programfiles\$logFolder" 

Start-Transcript -Path "$logPath\$logFolder\$logName.log" -Force
# ----------------------------------------Place Script Below This Line------------------------------------------------------------ 

# Install the Microsoft Store
# Variables that require input - The link below is for installing the Microsoft Store
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
# END Install the Microsoft Store


# Winget Installation and update script found from https://call4cloud.nl/2021/05/cloudy-with-a-chance-of-winget/#part2

#WebClient
$dc = New-Object net.webclient
$dc.UseDefaultCredentials = $true
$dc.Headers.Add("user-agent", "Inter Explorer")
$dc.Headers.Add("X-FORMS_BASED_AUTH_ACCEPTED", "f")

#temp folder
$InstallerFolder = $(Join-Path $env:ProgramData CustomScripts)
if (!(Test-Path $InstallerFolder))
{
New-Item -Path $InstallerFolder -ItemType Directory -Force -Confirm:$false
}
	#Check Winget Install
	Write-Host "Checking if Winget is installed" -ForegroundColor Yellow
	$TestWinget = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq "Microsoft.DesktopAppInstaller"}
	If ([Version]$TestWinGet. Version -gt "2022.506.16.0") 
	{
		Write-Host "WinGet is Installed" -ForegroundColor Green
	}Else 
		{
		#Download WinGet MSIXBundle
		Write-Host "Not installed. Downloading WinGet..." 
		$WinGetURL = "https://aka.ms/getwinget"
		$dc.DownloadFile($WinGetURL, "$InstallerFolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle")
		
		#Install WinGet MSIXBundle 
		Try 	{
			Write-Host "Installing MSIXBundle for App Installer..." 
			Add-AppxProvisionedPackage -Online -PackagePath "$InstallerFolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -SkipLicense 
			Write-Host "Installed MSIXBundle for App Installer" -ForegroundColor Green
			}
		Catch {
			Write-Host "Failed to install MSIXBundle for App Installer..." -ForegroundColor Red
			} 
	
		#Remove WinGet MSIXBundle 
		#Remove-Item -Path "$InstallerFolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -Force -ErrorAction Continue
		}
# END Winget Installation

# Find Winget Path
$ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
    if ($ResolveWingetPath){
           $WingetPath = $ResolveWingetPath[-1].Path
    }

$config
cd $wingetpath
.\winget.exe install --exact --id Microsoft.EdgeWebView2Runtime --silent --accept-package-agreements --accept-source-agreements
# END find Winget Path


# Use Winget to install Microsoft store apps

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