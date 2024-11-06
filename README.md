# PowerShell-Scheduled-Restart-Reminder
 PowerShell script to schedule daily restart reminders with a GUI
# Scheduled PowerShell Task Reminder

## Description

This PowerShell script creates scheduled tasks that run a reminder popup every day at 11:00 AM in various time zones. The reminder will provide information such as system uptime, computer name, user name, and a list of recent updates installed on the system. It enhances user awareness about system maintenance and encourages regular restarts.

### Key Features:
- **Multi-Time Zone Support:** Runs at 11:00 AM in various time zones (EST, PST, IST, MST).
- **Informative Popup:** Displays important system information when executed.
- **Automatic Execution:** Can be set to run automatically at startup through a scheduled task.

## Installation Instructions

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/yourrepository.git
   cd yourrepository

   My repository : https://github.com/aakash11boycreate?tab=repositories

2. Modify the Script Path: Open the script file (YourScript.ps1) and update the $scriptPath variable to point to your script.
 $scriptPath = "C:\Path\To\Your\Script.ps1"  # Update this to your script path

Run the Script: Execute the script in PowerShell to create scheduled tasks.

powershell -ExecutionPolicy Bypass -File "C:\Path\To\Your\Script.ps1"


Usage
Scheduled Task Creation: The script will create a scheduled task that runs the reminder script every day at 11:00 AM in the specified time zones.
Popup Information: The popup will show system uptime, computer name, user name, and recent updates when triggered.
License
This repository is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License. This license allows others to download and share your work with credit to you, but they can’t change it in any way or use it commercially.

License Summary:
Attribution: You must give appropriate credit, provide a link to the license, and indicate if changes were made.
NonCommercial: You may not use the material for commercial purposes.
NoDerivatives: If you remix, transform, or build upon the material, you may not distribute the modified material.
Contributions
Contributions are welcome! Please submit a pull request or create an issue for any improvements or suggestions.

Contact
For any inquiries or feedback, please reach out to sky1formulate@outlook.com

Thank you for using the Scheduled PowerShell Task Reminder! Your feedback is appreciated.


### Instructions for Updating Your Repository
1. **Create or Edit the README File:**
   - If you don’t have a `README.md` file, create a new file named `README.md` in the root of your repository.
   - If you have an existing `README.md`, open it for editing.

2. **Copy and Paste the Content:**
   - Replace the existing content with the above markdown content, making sure to update any placeholders (like the repository URL and your contact information).

3. **Commit Your Changes:**
   - Once you’ve made the changes, commit the updated README to your repository.
   ```bash
   git add README.md
   git commit -m "Updated README with description, installation, usage, and license information"
   git push origin main
