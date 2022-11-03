# Set File Information
$fileLocation = [Environment]::GetFolderPath("Desktop")
$fileName = "ComputerInfo.txt"

# Current date and time
$now = Get-Date -Format "yyyy/MM/dd HH:mm:ss"

# Create Hash Table
$computerSpecs = @{}

# Set items you want inventory for
$model = Get-CimInstance -ClassName Win32_ComputerSystem
$processor = Get-WMIObject win32_Processor | select name
$serial = Get-WmiObject win32_bios | select Serialnumber
$portInfo = Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match '^USB' }
$licenseType = (Get-CimInstance -ClassName Win32_OperatingSystem).Name.Split("|")[0]


$computerSpecs = New-Object System.Collections.Specialized.OrderedDictionary

$computerSpecs.Add($now, "")
$computerSpecs.Add("Computer Info", "")
$computerSpecs.Add("License Type: ", $licenseType)
$computerSpecs.Add("Manufacturer: ", $model.Manufacturer)
$computerSpecs.Add("Model: ", $model.Model)
$computerSpecs.Add("Serial Number: ", $serial.Serialnumber)
$computerSpecs.Add("Specs: ", "")
$computerSpecs.Add("Processor: ", $processor.name)

$n = 1
foreach($gpu in Get-WmiObject Win32_VideoController) 
{
    $computerSpecs.Add("GPU$($n): ", $gpu.Description)
    $n++
}

$n = 1
foreach($driveInfo in Get-PhysicalDisk)
{
    $computerSpecs.Add("Hard Drive$($n) Type: ", $driveInfo.MediaType)
    $computerSpecs.Add("Hard Drive$($n) Size: ", $([math]::Round($driveInfo.Size/1GB,2)))
    $n++
}

$n = 1
foreach($ram in Get-CimInstance -ClassName Win32_PhysicalMemory)
{
    $computerSpecs.Add("RAM$($n) Size: ", $([math]::Round($ram.Capacity/1GB,2)))
    $computerSpecs.Add("RAM$($n) Speed: ", $ram.Speed)
    $computerSpecs.Add("RAM$($n) Slot: ", $ram.DeviceLocator)
    $n++
}

$computerSpecs.Add("Ports: ", "")
$computerSpecs.Add("Port Info: ", $portInfo)

# Write Specs to a file on the desktop
 foreach($key in $computerSpecs.keys)
{
    Add-Content -Path $fileLocation/$fileName -Value  $key
    Add-Content -Path $fileLocation/$fileName -Value  $computerSpecs[$key]
    Add-Content -Path $fileLocation/$fileName -Value  ""
}

# Send a message to Slack for easy copying and pasting and historical data
# Add the Slack URI below for this to work
foreach($key in $computerSpecs.keys)
{
    $uriSlack = "https://hooks.slack.com/services/AddSlackURIHere"
    $body = ConvertTo-Json @{
        pretext = "Computer Ready for Surplus"
        text = "$($key) `n$($computerSpecs[$key])`n"
        color = "#142954"
    }
    
    try {
        Invoke-RestMethod -uri $uriSlack -Method Post -body $body -ContentType 'application/json' | Out-Null
    } catch {
        Write-Error (Get-Date) ": Update to Slack went wrong..."
    }
}

# Remove desktop files as they are no longer needed
Remove-Item $fileLocation/ComputerBasicInfoAssetGrab.bat
Remove-Item $fileLocation/ComputerBasicInfoAssetGrab.ps1