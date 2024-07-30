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
        Invoke-WebRequest -Uri $chocoInstallScriptUrl -UseBasicP -OutFile "$env:TEMP\choco-install.ps1"
        & "$env:TEMP\choco-install.ps1"
        Write-Output "Chocolatey installed successfully."
    } catch {
        Write-Output "Failed to install Chocolatey."
        [System.Windows.Forms.MessageBox]::Show("Failed to install Chocolatey. Exiting.")
        exit
    }
}

# Check if Chocolatey is installed, and install if not
if (-Not (Check-Chocolatey)) {
    Install-Chocolatey
}

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
            if ($checkbox.Checked) {
                $selectedSoftware += $checkbox.Text
            }
        }
    }
    
    if ($selectedSoftware.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show("No software selected!")
        return
    }

    # Update progress bar and output box
    $progressBar.Maximum = $selectedSoftware.Count
    $progressBar.Value = 0
    $outputBox.Clear()

    # Install software
    foreach ($software in $selectedSoftware) {
        $outputBox.AppendText("Installing $software...\`r`n")
        $form.Refresh()
        $chocoProcess = Start-Process powershell -ArgumentList "choco install $software -y" -NoNewWindow -Wait -PassThru
        $chocoProcess.WaitForExit()
        $outputBox.AppendText("$software installation completed.`r`n")
        $progressBar.Value++
        [System.Windows.Forms.Application]::DoEvents() # Process GUI events
    }
    
    [System.Windows.Forms.MessageBox]::Show("Installation complete!")
})

# Hide the PowerShell window and show the form
$form.Add_Shown({ $form.Activate() })
$form.ShowDialog() | Out-Null
