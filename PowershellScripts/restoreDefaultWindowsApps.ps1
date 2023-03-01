# This script is a generic script for logging information on your desktop to help troubleshoot errors
# Put this code at the beginning of your Powershell script

# Variables that require input
$logName = "PowershellScriptLog" # Change this to something of your choosing
$logFolder = "Log" # Change this folder name to something of your choosing
$logPath = "$Env:Programfiles\$logFolder" 

Start-Transcript -Path "$logPath\$logName.log" -Force
# ----------------------------------------Place Script Below This Line------------------------------------------------------------ 

Get-AppxPackage -allusers | foreach {Add-AppxPackage -register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode}

# ----------------------------------------Place Script Above This Line------------------------------------------------------------ 
Stop-Transcript