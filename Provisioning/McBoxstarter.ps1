#Instructions - Paste the following into IE: 
#http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/mckayc/McWindows/master/Provisioning/McBoxstarter.ps1

# User Specified Variables - Link to a repo of the packages that are on Chocolatey that you would like to have the option to install
$repository = "https://raw.githubusercontent.com/mckayc/McWindows/master/McChocolateyList.txt"
$gitDir = "~\Documents\Git"
$gitRepos=
@(
    'https://github.com/mckayc/McWindows'
    'https://github.com/mckayc/docker'
)

# Boxstarter commands
Set-WindowsExplorerOptions -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Enable-RemoteDesktop #Allows Remote Desktop access to machine and enables Remote Desktop firewall rule.
Install-WindowsUpdate # Finds, downloads and installs all Windows Updates. By default, only critical updates will be searched. However the command takes a -Criteria argument allowing one to pass a custom Windows Update query.
Set-BoxstarterTaskbarOptions -AlwaysShowIconsOff 

# Install Core
cinst chocolatey -y
cinst chocolateygui -y

# Questions for user setup
$displaySummary = Read-Host "Would you like to display the Summary of each package? (this takes longer to load package names) y / (blank)"
$gitInstall = Read-Host "Would you like to install git and copy repos? y / (blank)"
$dailyUpdates = Read-Host "Would you like to have Chocolatey update packages automatically? y / (blank)"
$copyShortcuts = Read-Host "Would you like to copy shortcuts from your Github repo? y / (blank)"

# Pre-set variables - do not change
$tempFolder = $env:TEMP
$txtFile = "$tempFolder\repository.txt"
$acceptedPackages = @()

# Download file and set as hashtable
Invoke-WebRequest -Uri $repository -OutFile $txtFile

$imported = Get-Content -raw $txtFile | ConvertFrom-StringData
$packageList = $imported

# Package Installation - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
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
# End Package Installation - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

# Github Repository Settings - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if ($gitInstall -eq "y")
    {
        # Install git
        choco install git -y
   
        # Create Git folder
        mkdir $gitDir

        # Checkout user specified git repos
        foreach ($gitRepo in $gitRepos) {
            git clone $gitRepo $gitDir
        }
}
# End Github Repository Settings - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Options for Chocolatey automated upgrades - - - - - - - - - - - - - - - - - - - - - - 
# Set Chocolatey to auto-update every day - Set Paramaters
if ($dailyUpdates -eq "y")
{
    choco install choco-upgrade-all-at --params "'/DAILY:yes /TIME:05:00 /ABORTTIME:06:00'" -y
}
# End Options for Chocolatey automated upgrades - - - - - - - - - - - - - - - - - - - - -

# Copy over shortcuts - - - - - - - - - - - - - - - - - - - - - - 
if ($copyShortcuts -eq "y")
{
    # Create Links for Scripts to start on startup
    New-Item -ItemType SymbolicLink -Path "~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup" -Name "MediaKeys.ahk" -Value "~\Documents\Git\McWindows\AutoHotKeys\MediaKeys.ahk"
}
# End Copy over shortcuts - - - - - - - - - - - - - - - - - - - - - - 

Write-Output "Script is done. Yay. I hope it worked."