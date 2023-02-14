# Instructions - Paste the following into IE: 
# http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/mckayc/McWindows/master/McChoco.ps1

# Install Boxstarter
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); Get-Boxstarter -Force

cinst chocolatey -y

Write-Host "This is just a banana test to see what works"

# User Specified Variables
$onlineScript = "https://raw.githubusercontent.com/mckayc/McWindows/master/McWindowsProvisioningScript.ps1"

# Set options
$option1 = "Install Chocolatey only"
$option2 = "Install Chocolatey and Chrome"
$option3 = "Install Chocolatey and Geekbench"
$option4 = "Install Chocolatey + Chrome + Geekbench"
$option5 = "Install Chrome first then show repository of software that can be installed"
$option6 = "Show repository of software that can be installed"
$optionQ = "Quit"

function Show-Menu
{
    param (
        $Title = 'Provisioning Options'
    )
    Clear-Host
    Write-Host "================ $Title ================"
    
    Write-Host "1: $option1"
    Write-Host "2: $option2"
    Write-Host "3: $option3"
    Write-Host "4: $option4"
    Write-Host "5: $option5"
    Write-Host "6: $option6"
    Write-Host "Q: $optionQ"
}

Show-Menu –Title 'Provisioning Options'
 $selection = Read-Host "Please make a selection"
 switch ($selection)
 {
       '1' {
         $option1
         cinst chocolatey -y
     } '2' {
         $option2
         cinst chocolatey -y
         cinst googlechrome -y
     } '3' {
         $option3
         cinst chocolatey -y
         cinst geekbench -y
     } '4' {
         $option4
         cinst chocolatey -y
         cinst googlechrome -y
         cinst geekbench -y
     } '5' {
         $option5
         cinst googlechrome -y
         Invoke-WebRequest $onlineScript | Invoke-Expression; install
     } '6' {
         $option6
         Invoke-WebRequest $onlineScript | Invoke-Expression; install
     } 'q' {
         return
     }
 }
