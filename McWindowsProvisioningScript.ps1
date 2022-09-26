# User Specified Variables
$repository = "https://raw.githubusercontent.com/mckayc/McWindows/master/McChocolateyList.txt"

# Pre-set variables - do not change
$tempFolder = $env:TEMP
$txtFile = "$tempFolder\repository.txt"
$acceptedPackages = @()

# Download file and set as hashtable
Invoke-WebRequest -Uri $repository -OutFile $txtFile

$imported = Get-Content -raw $txtFile | ConvertFrom-StringData
$packageList = $imported

Write-Host "If you would like to install the listed package, please enter 'y'; otherwise leave blank."


# $packageList = @{
#     googlechrome = 'Internet'
#     sharex  = 'Tools'
#     neverball = 'Games'
#     wireguard = 'Internet'
#     supertuxkart = 'Games'
#     qbittorrent = 'Internet'
#     openvpn = 'Internet'
#     freecad = 'Graphics'
# }
$packageList = $packageList.GetEnumerator() | sort -Property Value 

foreach ($package in $packageList) {

    # $package
    # choco info $package | Select-String -Pattern 'Summary'
    
    $confimation = Read-Host $package.value "-" $package.name
    if ($confimation -eq "y")
    {
        $acceptedPackages += $package
    }
}
 
foreach ($acceptedPackage in $acceptedPackages) {
    Write-Output "Installing the package $acceptedPackage"
    choco install $acceptedPackage -y
}