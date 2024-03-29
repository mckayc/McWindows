#Instructions - Paste the following into a browser: bit.ly/mcwin11 - Copy the script and paste it into Powershell with Admin access the run

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Box Starter
choco install Boxstarter
Set-ExecutionPolicy Unrestricted -Force
Import-Module Boxstarter.Chocolatey
Enable-RemoteDesktop
Set-WindowsExplorerOptions -EnableShowHiddenFilesFoldersDrives -EnableShowFileExtensions -EnableShowFullPathInTitleBar -EnableOpenFileExplorerToQuickAccess -EnableShowRecentFilesInQuickAccess -EnableShowFrequentFoldersInQuickAccess -EnableExpandToOpenFolder -EnableShowRibbon -EnableItemCheckBox


# User Specified Variables
$repository = "https://raw.githubusercontent.com/mckayc/McWindows/master/McChocolateyList.txt"

# Questions for user setup
$displaySummary = Read-Host "Would you like to display the Summary of each package? (this takes longer to load package names) y / (blank)"

# Pre-set variables - do not change
$tempFolder = $env:TEMP
$txtFile = "$tempFolder\repository.txt"
$acceptedPackages = @()

# Download file and set as hashtable
Invoke-WebRequest -Uri $repository -OutFile $txtFile

$imported = Get-Content -raw $txtFile | ConvertFrom-StringData
$packageList = $imported

# Messaging for basic instructions
Write-Host "If you would like to install the listed package, please enter 'y'; otherwise leave blank."
Write-Output " "
Write-Output " "

# Sort by package then by category
$packageList = $packageList.GetEnumerator() | sort -Property Value, Name  

foreach ($package in $packageList) {

    $packageName = $package.name
    $packageCategory = $package.value

    if ($displaySummary -eq "y")
    {
        Write-Output "`r"
        choco info $package.name | Select-String -Pattern 'Title'
        choco info $package.name | Select-String -Pattern 'Summary'
    }
    
    $confimation = Read-Host "$packageCategory - $packageName"
    if ($confimation -eq "y")
    {
        $acceptedPackages += $package
    }
}
 
foreach ($acceptedPackage in $acceptedPackages) {
    Write-Output "Installing the package " $acceptedPackage.name
    choco install $acceptedPackage.name -y
}

# git stuff

# Create folder
mkdir ~\Documents\Git
cd ~\Documents\Git

# Checkout the McKayC Repository
git clone https://github.com/mckayc/McWindows
git clone https://github.com/mckayc/docker

# Create Links for Scripts to start on startup
New-Item -ItemType SymbolicLink -Path "~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Name "MediaKeys.ahk" -Value "~\Documents\Git\McWindows\AutoHotKeys\MediaKeys.ahk"

# End
