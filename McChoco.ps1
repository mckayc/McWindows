# Instructions - Paste the following into IE: 
# http://boxstarter.org/package/nr/url?https://raw.githubusercontent.com/mckayc/McWindows/master/McChoco.ps1

# Install Boxstarter
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://boxstarter.org/bootstrapper.ps1')); Get-Boxstarter -Force

cinst chocolatey -y
cinst geekbench -y
