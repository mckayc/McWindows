# This script is a generic script for logging information on your desktop to help troubleshoot errors
# Put this code at the beginning of your Powershell script

# Variables that require input
$logName = "Enter a name here"
$logPath = "$Env:Programfiles\ENTERFOLDERNAMEHERE"

Start-Transcript -Path "$logPath\Log\$logName.log" -Force
# ----------------------------------------Place Script Below This Line------------------------------------------------------------ 









# ----------------------------------------Place Script Above This Line------------------------------------------------------------ 
Stop-Transcript

