# Load Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to check if Chocolatey is installed
function Check-Chocolatey {
    try {
        # Check if Chocolatey is installed
        $chocoVersion = choco --version 2>$null
        if ($chocoVersion) {
            return $true
        }
    } catch {
        # Chocolatey is not installed
        return $false
    }
    return $false
}

# Function to install Chocolatey
function Install-Chocolatey {
    $chocoInstallScriptUrl = "https://community.chocolatey.org/install.ps1"
    try {
        # Download and install Chocolatey
        Invoke-WebRequest -Uri $chocoInstallScriptUrl -UseBasicParsing -OutFile "$env:TEMP\choco-install.ps1"
        & "$env:TEMP\choco-install.ps1"
        Write-Output "Chocolatey installed successfully."
    } catch {
        Write-Output "Failed to install Chocolatey."
        [System.Windows.Forms.MessageBox]::Show("Failed to install Chocolatey. Exiting.")
        exit
    }
}

# Function to get installed Chocolatey packages
function Get-InstalledPackages {
    $installedPackages = choco list --no-color | ForEach-Object {
        $packageName = $_.Split("|")[0].Trim().ToLower()
        $packageName -replace '[\.\s\d].*$', '' # Remove all text after a period, space, or number
    }
    return $installedPackages
}

# Check if Chocolatey is installed, and install if not
if (-Not (Check-Chocolatey)) {
    Install-Chocolatey
}

# Get the list of installed packages
$installedPackages = Get-InstalledPackages

# Define the URL for the software list
$url = "https://raw.githubusercontent.com/mckayc/McWindows/master/McChocolateyList.txt"

# Download the software list file
$response = Invoke-WebRequest -Uri $url
$softwareListContent = $response.Content

# Check if the software list content was retrieved successfully
if (-Not $softwareListContent) {
    [System.Windows.Forms.MessageBox]::Show("Software list could not be retrieved!")
    exit
}

# Read and parse the software list content
$softwareList = $softwareListContent -split "`n" | ForEach-Object {
    $parts = $_.Trim().Split("=")
    if ($parts.Length -eq 2) {
        [PSCustomObject]@{ Software = $parts[0].Trim(); Category = $parts[1].Trim() }
    }
}

# Group software by category
$groupedSoftware = $softwareList | Group-Object Category

# Separate "Install First" category and the rest
$installFirstGroup = $groupedSoftware | Where-Object { $_.Name -eq "Install First" }
$otherGroups = $groupedSoftware | Where-Object { $_.Name -ne "Install First" } | Sort-Object Name

# Create and configure the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Software Provisioning"
$form.Size = New-Object System.Drawing.Size(600, 800)
$form.StartPosition = "CenterScreen"
$form.MinimumSize = New-Object System.Drawing.Size(600, 800)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Sizable
$form.MaximizeBox = $true
$form.MinimizeBox = $true
$form.ControlBox = $true

# Create a container for categories
$categoryPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$categoryPanel.Dock = [System.Windows.Forms.DockStyle]::Fill
$categoryPanel.AutoScroll = $true
$categoryPanel.FlowDirection = [System.Windows.Forms.FlowDirection]::TopDown
$categoryPanel.WrapContents = $false
$form.Controls.Add($categoryPanel)

# Create a container for buttons
$buttonPanel = New-Object System.Windows.Forms.Panel
$buttonPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
$buttonPanel.Height = 60
$form.Controls.Add($buttonPanel)

# Create a container for progress bar
$progressPanel = New-Object System.Windows.Forms.Panel
$progressPanel.Dock = [System.Windows.Forms.DockStyle]::Bottom
$progressPanel.Height = 40
$form.Controls.Add($progressPanel)

# Create a text box for output
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Multiline = $true
$outputBox.Dock = [System.Windows.Forms.DockStyle]::Bottom
$outputBox.Height = 100
$outputBox.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
$outputBox.ReadOnly = $true
$outputBox.BackColor = [System.Drawing.Color]::LightGray
$form.Controls.Add($outputBox)

# Create and configure the Submit button
$submitButton = New-Object System.Windows.Forms.Button
$submitButton.Text = "Submit"
$submitButton.Width = 100
$submitButton.Height = 40
$submitButton.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$submitButton.BackColor = [System.Drawing.Color]::RoyalBlue
$submitButton.ForeColor = [System.Drawing.Color]::White
$submitButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$submitButton.Top = 10
$submitButton.Left = 10
$buttonPanel.Controls.Add($submitButton)

# Create and configure the progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
$progressBar.Dock = [System.Windows.Forms.DockStyle]::Fill
$progressBar.Height = 20
$progressPanel.Controls.Add($progressBar)

# Add "Install First" category at the top
if ($installFirstGroup) {
    $categoryGroupBox = New-Object System.Windows.Forms.GroupBox
    $categoryGroupBox.Text = "Install First"
    $categoryGroupBox.Width = 580
    $categoryGroupBox.AutoSize = $true
    $categoryGroupBox.Padding = "10,10,10,10"
    $categoryGroupBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)

    $topPosition = 20
    foreach ($item in $installFirstGroup.Group) {
        $checkbox = New-Object System.Windows.Forms.CheckBox
        $checkbox.Text = $item.Software
        if ($installedPackages -contains ($item.Software.ToLower() -replace '[\.\s\d]+.*$', '')) {
            $checkbox.Checked = $true
            $checkbox.BackColor = [System.Drawing.Color]::LightGreen
        }
        $checkbox.Top = $topPosition
        $checkbox.Left = 10
        $checkbox.Width = 550
        $topPosition += 30
        $categoryGroupBox.Controls.Add($checkbox)
    }
    
    $categoryPanel.Controls.Add($categoryGroupBox)
}

# Add other categories, alphabetized
foreach ($group in $otherGroups) {
    $categoryGroupBox = New-Object System.Windows.Forms.GroupBox
    $categoryGroupBox.Text = $group.Name
    $categoryGroupBox.Width = 580
    $categoryGroupBox.AutoSize = $true
    $categoryGroupBox.Padding = "10,10,10,10"
    $categoryGroupBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)

    # Add checkboxes for each software in the category
    $topPosition = 20
    foreach ($item in $group.Group | Sort-Object Software) {
        $checkbox = New-Object System.Windows.Forms.CheckBox
        $checkbox.Text = $item.Software
        if ($installedPackages -contains ($item.Software.ToLower() -replace '[\.\s\d]+.*$', '')) {
            $checkbox.Checked = $true
            $checkbox.BackColor = [System.Drawing.Color]::LightGreen
        }
        $checkbox.Top = $topPosition
        $checkbox.Left = 10
        $checkbox.Width = 550
        $topPosition += 30
        $categoryGroupBox.Controls.Add($checkbox)
    }
    
    $categoryPanel.Controls.Add($categoryGroupBox)
}

# Add event handler for Submit button
$submitButton.Add_Click({
    # Collect selected software
    $selectedSoftware = @()
    foreach ($groupBox in $categoryPanel.Controls) {
        foreach ($checkbox in $groupBox.Controls) {
            if ($checkbox.Checked -and $checkbox.BackColor -ne [System.Drawing.Color]::LightGreen) {
                $selectedSoftware += $checkbox.Text
            }
        }
    }

    # Function to install selected software asynchronously
    function Install-SelectedSoftware {
        param ([string[]]$softwareList)
        $progressBar.Maximum = $softwareList.Count
        $progressBar.Value = 0

        foreach ($software in $softwareList) {
            $outputBox.AppendText("Installing $software..." + "`r`n")
            $outputBox.AppendText("Starting installation..." + "`r`n")
            $form.Refresh()

            # Execute the install command asynchronously
            Start-Job -ScriptBlock {
                param ($software)
                $process = Start-Process -FilePath "choco" -ArgumentList "install $software -y" -NoNewWindow -PassThru -RedirectStandardOutput "$env:TEMP\choco-install-output.log"
                $process.WaitForExit()

                # Read output and update progress
                $output = Get-Content "$env:TEMP\choco-install-output.log"
                [System.Windows.Forms.MessageBox]::Show($output -join "`r`n", "Installation Output")
            } -ArgumentList $software | Out-Null

            # Update progress bar
            $progressBar.Value++
            $form.Refresh()
        }
    }

    # Start installation
    Install-SelectedSoftware -softwareList $selectedSoftware
})

# Show the form
[System.Windows.Forms.Application]::Run($form)
