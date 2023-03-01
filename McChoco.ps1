# Instructions - Paste the following into IE: 
# http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/mckayc/McWindows/master/McChoco.ps1

# Install Boxstarter
Set-ExplorerOptions -showHiddenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions
Enable-RemoteDesktop

# Install Core
choco install chocolatey
choco install googlechrome
choco install geekbench
