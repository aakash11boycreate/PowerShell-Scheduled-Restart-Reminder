# Define the path to the PowerShell script to run
$scriptPath = "C:\Path\To\Your\Script.ps1"  # Update this to your script path

# Task settings
$taskName = "MyScheduledPowerShellTask"
$taskDescription = "Runs a PowerShell script every day at 11:00 AM in various time zones."

# Define the time zones
$timeZones = @("Eastern Standard Time", "Pacific Standard Time", "India Standard Time", "Mountain Standard Time")

# Function to create scheduled tasks for each time zone
function Create-ScheduledTask {
    param (
        [string]$zoneName
    )

    # Create a trigger for 11:00 AM every day
    $trigger = New-ScheduledTaskTrigger -Daily -At "11:00AM"

    # Adjust the StartBoundary to match the time zone
    $localTime = (Get-Date).AddHours((Get-TimeZone -Id $zoneName).BaseUtcOffset.Hours)
    $trigger.StartBoundary = $localTime.ToString("yyyy-MM-ddTHH:mm:ss")

    $action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount

    # Check if the task already exists
    if (-not (Get-ScheduledTask -TaskName "$taskName-$zoneName" -ErrorAction SilentlyContinue)) {
        Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Description "$taskDescription ($zoneName)" -TaskName "$taskName-$zoneName"
        Write-Output "Scheduled task '$taskName-$zoneName' created successfully."
    } else {
        Write-Output "Scheduled task '$taskName-$zoneName' already exists."
    }
}

# Create scheduled tasks for each time zone
foreach ($zone in $timeZones) {
    Create-ScheduledTask -zoneName $zone
}

# Script Content (for the popup)
$scriptContent = @"
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Initialize the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Restart Reminder"
$form.Size = New-Object System.Drawing.Size(620, 600)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::None
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(240, 255, 255, 255) # Light translucent white
$form.Opacity = 0.92

# Add title label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "System Restart Reminder"
$titleLabel.Font = New-Object System.Drawing.Font("Arial", 18, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::Black
$titleLabel.AutoSize = $true
$titleLabel.Location = New-Object System.Drawing.Point(40, 140)
$form.Controls.Add($titleLabel)

# Calculate system uptime
$uptime = (Get-Date) - (gcim Win32_OperatingSystem).LastBootUpTime
$uptimeFormatted = [string]::Format("{0:D} days, {1:D2} hours, {2:D2} minutes", $uptime.Days, $uptime.Hours, $uptime.Minutes)

# Add uptime label
$uptimeLabel = New-Object System.Windows.Forms.Label
$uptimeLabel.Text = "Uptime since last restart: " + $uptimeFormatted
$uptimeLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$uptimeLabel.ForeColor = [System.Drawing.Color]::Black
$uptimeLabel.AutoSize = $true
$uptimeLabel.Location = New-Object System.Drawing.Point(40, 190)
$form.Controls.Add($uptimeLabel)

# Add computer information
$computerName = $env:COMPUTERNAME
$userName = $env:UserName

$computerNameLabel = New-Object System.Windows.Forms.Label
$computerNameLabel.Text = "Computer Name: " + $computerName
$computerNameLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
$computerNameLabel.ForeColor = [System.Drawing.Color]::Black
$computerNameLabel.AutoSize = $true
$computerNameLabel.Location = New-Object System.Drawing.Point(40, 230)
$form.Controls.Add($computerNameLabel)

$userNameLabel = New-Object System.Windows.Forms.Label
$userNameLabel.Text = "User Name: " + $userName
$userNameLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
$userNameLabel.ForeColor = [System.Drawing.Color]::Black
$userNameLabel.AutoSize = $true
$userNameLabel.Location = New-Object System.Drawing.Point(40, 260)
$form.Controls.Add($userNameLabel)

# Get list of recent updates (installed or pending)
$recentUpdates = Get-WmiObject -Class Win32_QuickFixEngineering | Select-Object -First 4 -Property Description, HotFixID, InstalledOn

$updatesLabel = New-Object System.Windows.Forms.Label
$updatesLabel.Text = "Recent Updates:"
$updatesLabel.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$updatesLabel.ForeColor = [System.Drawing.Color]::Black
$updatesLabel.AutoSize = $true
$updatesLabel.Location = New-Object System.Drawing.Point(40, 330)
$form.Controls.Add($updatesLabel)

$yPosition = 360
foreach ($update in $recentUpdates) {
    $updateLabel = New-Object System.Windows.Forms.Label
    $updateLabel.Text = "ID: $($update.HotFixID) - $($update.Description) - Installed On: $($update.InstalledOn)"
    $updateLabel.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Regular)
    $updateLabel.ForeColor = [System.Drawing.Color]::Black
    $updateLabel.AutoSize = $true
    $updateLabel.Location = New-Object System.Drawing.Point(40, $yPosition)
    $yPosition += 25
    $form.Controls.Add($updateLabel)
}

# Restart Now button
$restartNowButton = New-Object System.Windows.Forms.Button
$restartNowButton.Text = "Restart Now"
$restartNowButton.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$restartNowButton.Size = New-Object System.Drawing.Size(120, 40)
$restartNowButton.Location = New-Object System.Drawing.Point(60, 500)
$restartNowButton.BackColor = [System.Drawing.Color]::FromArgb(200, 255, 80, 80)
$restartNowButton.ForeColor = [System.Drawing.Color]::White
$restartNowButton.Add_Click({
    Stop-Computer -Force -Confirm:$false
})
$form.Controls.Add($restartNowButton)

# Postpone button
$postponeButton = New-Object System.Windows.Forms.Button
$postponeButton.Text = "Postpone (8 Hours)"
$postponeButton.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold)
$postponeButton.Size = New-Object System.Drawing.Size(150, 40)
$postponeButton.Location = New-Object System.Drawing.Point(250, 500)
$postponeButton.BackColor = [System.Drawing.Color]::FromArgb(200, 60, 140, 255)
$postponeButton.ForeColor = [System.Drawing.Color]::White
$postponeButton.Add_Click({
    $global:lastReminderTime = (Get-Date)
    $form.Close()
})
$form.Controls.Add($postponeButton)

# Close button
$closeButton = New-Object System.Windows.Forms.Button
$closeButton.Text = "X"
$closeButton.Font = New-Object System.Drawing.Font("Arial", 10, [System.Drawing.FontStyle]::Bold)
$closeButton.Size = New-Object System.Drawing.Size(30, 30)
$closeButton.Location = New-Object System.Drawing.Point(570, 10)
$closeButton.BackColor = [System.Drawing.Color]::FromArgb(200, 220, 20, 60)
$closeButton.ForeColor = [System.Drawing.Color]::White
$closeButton.Add_Click({ $form.Close() })
$form.Controls.Add($closeButton)

# Show the form
$form.ShowDialog()
"@

# Check if the Startup folder exists
$startupFolder = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup"
if (-not (Test-Path -Path $startupFolder)) {
    Write-Output "Startup folder does not exist."
    exit
}

# Create the PowerShell script file in the Startup folder
$scriptFilePath = Join-Path -Path $startupFolder -ChildPath "Update.ps1"

# Write the content to Update.ps1 in the Startup folder
try {
    Set-Content -Path $scriptFilePath -Value $scriptContent -ErrorAction Stop
    Write-Output "Script has been saved to the Startup folder and will run at each login."
} catch {
    Write-Output "Failed to create the script: $_"
}
