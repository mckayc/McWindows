#Instructions - Paste the following into IE: 
#http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/mckayc/McWindows/master/McWindowsProvisioningScript.ps1


Set-WindowsExplorerOptions -EnableShowProtectedOSFiles -EnableShowFileExtensions
Enable-RemoteDesktop
Set-StartScreenOptions -EnableBootToDesktop

# Install Core
cinst chocolatey -y
cinst chocolateygui -y
