# Create Log folder if it does not exist
$logPath = "C:\Log"

if(!(Test-Path $logPath -PathType Container)) { 
    Write-Output "$logPath does not exist."
    New-Item $logPath -ItemType "directory"
    Write-Output "$logPath has been created"
} else {
    Write-Output "$logPath already exists."
}

# Setup Logging
function Get-TimeStamp {    
    return "[{0:yyyy/MM/dd} {0:HH:mm:ss}]" -f (Get-Date)    
}

function log([String] $text) {
  Write-Output "$(Get-TimeStamp) - $text" | Out-file $logPath\log.log -append
  Write-host ($text)
}

# Upgrade all software
log "Upgrading all Chocolatey software."
choco upgrade all -y
log "Software has been updated."