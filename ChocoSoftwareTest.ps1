# Add all packages below in single quotes. 
Write-Host "Multimedia Stuff"
Write-Host "-----------------------------------------------"
$acceptedPackages = @()
$packages =
@(
    'googlechrome'
    'VLC'
    'libre-office'
    'stuff'
    'cool beans'
)

$packages = $packages | Sort-Object

Write-Host "If you would like to install the listed package, please enter 'y'; otherwise leave blank."
foreach ($package in $packages) {

    $confimation = Read-Host "$package"
    if ($confimation -eq "y")
    {
        $acceptedPackages += $package
    }
}

foreach ($acceptedPackage in $acceptedPackages) {
    Write-Output "Installing the package $acceptedPackage"
    #choco install $acceptedPackage -y
}







