# This scripts looks at the software currently installed and compares it with software previously installed
# to determine recently installed software. It reports the installed software to a spreadsheet made from a 
# custom Google form that you will need to create. This should be deployed in Intune as a Remediation so that
# it can be run daily or hourly. 

# Function to clean software name by removing all numbers, parentheses, dashes, and periods
function Clean-SoftwareName {
    param (
        [string]$name
    )

    # Remove all numbers, parentheses, dashes, and periods
    $cleanedName = $name -replace '[\d\(\)\-\.\,]', ''
    # Remove extra spaces
    $cleanedName = $cleanedName -replace '\s+', ' ' -replace '^\s+|\s+$', ''
    # Only keep the first two words
    $cleanedName = ($cleanedName -split '\s+')[0..1] -join ' '

    return $cleanedName
}

# Function to submit data to Google Form
function Submit-ToGoogleForm {
    param (
        [string]$computerName,
        [string]$userName,
        [string]$publisher,
        [string]$cleanName,
        [string]$version,
        [string]$installDate
    )

    # You will need to create your own form and make it public so that anyone can add a form submission
    # The form Document ID is from the view form (not the create form)
    # Create a spreadsheet for the responses
    # To get the name entries, you will need to open https://docs.google.com/forms/d/-Document_EDIT_ID-HERE-/prefill
    # Right click in the text boxes and go to "Inspect" to find the name entry number
    $formUrl = "https://docs.google.com/forms/d/e/--add_Document_ID_Here--/formResponse"
    $formData = @{
        "entry.addEntryNumberHere" = $computerName
        "entry.addEntryNumberHere"  = $userName
        "entry.addEntryNumberHere" = $publisher
        "entry.addEntryNumberHere"  = $cleanName
        "entry.addEntryNumberHere" = $version
        "entry.addEntryNumberHere"   = $installDate
    }
    
    Invoke-WebRequest -Uri $formUrl -Method POST -Body $formData -UseBasicP

    Write-Output "Submitted $cleanName to Google Form."
}

# Check if "C:\Windows\SoftwareInstallation\Log" exists, if not, create the directories
$logPath = "C:\Windows\SoftwareInstallation\Log"
if (-Not (Test-Path -Path $logPath)) {
    New-Item -ItemType Directory -Path $logPath -Force
}

# Define file paths
$installedSoftwareFile = "$logPath\installedSoftware.csv"
$previouslyInstalledSoftwareFile = "$logPath\previouslyInstalledSoftware.csv"
$recentlyInstalledSoftwareFile = "$logPath\recentlyInstalledSoftware.csv"
$logFile = "$logPath\log.txt"

# Create or clear log file
if (-Not (Test-Path -Path $logFile)) {
    New-Item -ItemType File -Path $logFile -Force
}

# Get computer and user name
$computerName = $env:COMPUTERNAME
$userName = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name

# Check if "previouslyInstalledSoftware.csv" exists, if so, delete it
if (Test-Path -Path $previouslyInstalledSoftwareFile) {
    Remove-Item -Path $previouslyInstalledSoftwareFile -Force
}

# Check if "installedSoftware.csv" exists, if so, rename it to "previouslyInstalledSoftware.csv"
if (Test-Path -Path $installedSoftwareFile) {
    Rename-Item -Path $installedSoftwareFile -NewName "previouslyInstalledSoftware.csv" -Force
}

# Define registry paths to search for installed software
$registryPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
)

# Initialize an array to hold installed software information
$installedSoftware = @()

# Loop through each registry path and get the installed software
foreach ($path in $registryPaths) {
    if (Test-Path $path) {
        Get-ItemProperty -Path "$path\*" | ForEach-Object {
            if ($_.DisplayName) {
                $software = New-Object PSObject -Property @{
                    Publisher = $_.Publisher
                    CleanName = Clean-SoftwareName -name $_.DisplayName
                    Name = $_.DisplayName
                    Version = $_.DisplayVersion
                    InstallDate = $_.InstallDate
                }
                $installedSoftware += $software
            }
        }
    }
}

# Remove duplicates based on cleaned Name
$uniqueSoftware = $installedSoftware | Group-Object -Property CleanName | ForEach-Object { $_.Group[0] }
$uniqueSoftware | Select-Object Publisher, CleanName, Version, InstallDate | Export-Csv -Path $installedSoftwareFile -NoTypeInformation

# Compare "installedSoftware.csv" and "previouslyInstalledSoftware.csv" if both exist
if ((Test-Path -Path $installedSoftwareFile) -and (Test-Path -Path $previouslyInstalledSoftwareFile)) {
    $newSoftware = Import-Csv -Path $installedSoftwareFile
    $oldSoftware = Import-Csv -Path $previouslyInstalledSoftwareFile

    # Handle cases where CleanName might not be present
    $newSoftwareNames = $newSoftware | Where-Object { $_.CleanName } | Select-Object -ExpandProperty CleanName
    $oldSoftwareNames = $oldSoftware | Where-Object { $_.CleanName } | Select-Object -ExpandProperty CleanName

    $recentlyInstalledSoftware = $newSoftwareNames | Where-Object { $_ -notin $oldSoftwareNames }

    # Create or overwrite "recentlyInstalledSoftware.csv" with the recently installed software
    if ($recentlyInstalledSoftware.Count -gt 0) {
        $recentlyInstalledSoftwareInfo = $newSoftware | Where-Object { $recentlyInstalledSoftware -contains $_.CleanName }
        $recentlyInstalledSoftwareInfo | Select-Object Publisher, CleanName, Version, InstallDate | Export-Csv -Path $recentlyInstalledSoftwareFile -NoTypeInformation

        # Log each new software entry and submit to Google Form
        foreach ($entry in $recentlyInstalledSoftwareInfo) {
            $logEntry = "{0} - {1} - {2} - {3} - {4} - {5}" -f $computerName, $userName, $entry.Publisher, $entry.CleanName, $entry.Version, $entry.InstallDate
            Add-Content -Path $logFile -Value $logEntry
            Submit-ToGoogleForm -computerName $computerName -userName $userName -publisher $entry.Publisher -cleanName $entry.CleanName -version $entry.Version -installDate $entry.InstallDate
        }
    } else {
        # Delete the file if there are no recently installed software
        if (Test-Path -Path $recentlyInstalledSoftwareFile) {
            Remove-Item -Path $recentlyInstalledSoftwareFile -Force
        }
    }
}
