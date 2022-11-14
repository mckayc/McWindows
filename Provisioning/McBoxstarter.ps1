#Instructions - Paste the following into IE: 
#http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/mckayc/McWindows/master/Provisioning/McBoxstarter.ps1

# Boxstarter commands
Set-WindowsExplorerOptions -EnableShowProtectedOSFiles -EnableShowFileExtensions -EnableShowFullPathInTitleBar
Enable-RemoteDesktop #Allows Remote Desktop access to machine and enables Remote Desktop firewall rule.
Install-WindowsUpdate # Finds, downloads and installs all Windows Updates. By default, only critical updates will be searched. However the command takes a -Criteria argument allowing one to pass a custom Windows Update query.
Set-BoxstarterTaskbarOptions -AlwaysShowIconsOff 

# Install Core
cinst chocolatey -y
cinst chocolateygui -y

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