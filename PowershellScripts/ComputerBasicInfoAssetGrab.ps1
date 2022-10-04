# Set File Information
$fileLocation = [Environment]::GetFolderPath("Desktop")
$fileName = "ComputerInfo.txt"

# Set items you want inventory for
$model = Get-CimInstance -ClassName Win32_ComputerSystem
$processor = Get-WMIObject win32_Processor | select name
$serial = Get-WmiObject win32_bios | select Serialnumber
$portInfo = Get-PnpDevice -PresentOnly | Where-Object { $_.InstanceId -match '^USB' }


# Write to file
Add-Content -Path $fileLocation/$fileName -Value "Computer Info `r"

Add-Content -Path $fileLocation/$fileName -Value "Manufacturer: $($model.Manufacturer)"
Add-Content -Path $fileLocation/$fileName -Value "Model: $($model.Model)"
Add-Content -Path $fileLocation/$fileName -Value "Serial Number: $($serial.Serialnumber)"

Add-Content -Path $fileLocation/$fileName -Value "`r `r"
Add-Content -Path $fileLocation/$fileName -Value "Specs `r"

Add-Content -Path $fileLocation/$fileName -Value "Processor: $($processor.name)"

$n = 1
foreach($gpu in Get-WmiObject Win32_VideoController) 
{
    Add-Content -Path $fileLocation/$fileName -Value "GPU$($n): $($gpu.Description)"
    $n++
}

$n = 1
foreach($driveInfo in Get-PhysicalDisk)
{
    Add-Content -Path $fileLocation/$fileName -Value "Hard Drive$($n) Type: $($driveInfo.MediaType)"
    Add-Content -Path $fileLocation/$fileName -Value "Hard Drive$($n) Size: $([math]::Round($driveInfo.Size/1GB,2))"
    $n++
}

$n = 1
foreach($ram in Get-CimInstance -ClassName Win32_PhysicalMemory)
{
    Add-Content -Path $fileLocation/$fileName -Value "RAM$($n) Size: $([math]::Round($ram.Capacity/1GB,2))"
    Add-Content -Path $fileLocation/$fileName -Value "RAM$($n) Speed $($ram.Speed)"
    Add-Content -Path $fileLocation/$fileName -Value "RAM$($n) Slot $($ram.DeviceLocator)"
    $n++
}

Add-Content -Path $fileLocation/$fileName -Value "`r `r"
Add-Content -Path $fileLocation/$fileName -Value "Port Info `r"

Add-Content -Path $fileLocation/$fileName -Value $portInfo

# Expand partition to full capacity
Resize-Partition -DriveLetter C -Size $(Get-PartitionSupportedSize -DriveLetter C).SizeMax

Remove-Item $fileLocation/ComputerBasicInfoAssetGrab.bat
Remove-Item $fileLocation/ComputerBasicInfoAssetGrab.ps1

