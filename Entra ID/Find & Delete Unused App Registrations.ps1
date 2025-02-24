# ===========================================================
# Script: Find & Delete Unused App Registrations
# Author: Junaid Ahmed
# GitHub: https://github.com/jahmed-cloud
# ===========================================================

# Ensure Microsoft Graph module is installed and imported
if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Applications)) {
    Install-Module Microsoft.Graph.Applications -Force -AllowClobber
}

Import-Module Microsoft.Graph.Applications

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Application.ReadWrite.All", "Directory.ReadWrite.All"


# Define paths for exporting and importing CSV files
$BasePath = "C:\Entra ID\App Registrations"
$ExportPath = "$BasePath\UnusedApps.csv"
$ImportPath = "$BasePath\AppsToDelete.csv"
$LogFile = "$BasePath\ScriptLog.log"

# Ensure the directory exists
if (!(Test-Path $BasePath)) {
    New-Item -ItemType Directory -Path $BasePath -Force
}

# Logging function
function Write-Log {
    param ([string]$Message)
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogFile -Value "$Timestamp - $Message"
}

# Function to get unused applications created by users
function Get-UnusedUserCreatedApps {
    try {
        Write-Log "Fetching user-created applications that have not been used in 90 days..."
        
        # Get all applications
        $apps = Get-MgApplication -All

        # Get the 90-day threshold date
        $thresholdDate = (Get-Date).AddDays(-90)

        # Filter apps created by users (not managed identities) and unused
        $unusedApps = $apps | Where-Object {
            $_.CreatedOnBehalfOf -ne $null -and # Created by a user
            ($_.'SignInActivity.LastSignInDateTime' -eq $null -or $_.'SignInActivity.LastSignInDateTime' -lt $thresholdDate)
        }

        if ($unusedApps.Count -eq 0) {
            Write-Log "No unused user-created applications found."
        } else {
            Write-Log "Found $($unusedApps.Count) unused applications."
            
            # Export results to CSV
            $unusedApps | Select-Object Id, DisplayName, CreatedDateTime, SignInActivity | Export-Csv -Path $ExportPath -NoTypeInformation
            Write-Log "Exported unused applications to $ExportPath"
        }

        return $unusedApps
    } catch {
        Write-Log "Error fetching unused applications: $($_.Exception.Message)"
    }
}

# Function to delete unused applications
function Delete-UnusedApps {
    $unusedApps = Get-UnusedUserCreatedApps

    if ($unusedApps.Count -eq 0) {
        Write-Host "No applications to delete."
        return
    }

    Write-Host "Found $($unusedApps.Count) unused applications. Do you want to delete them? (Y/N)"
    $confirmation = Read-Host

    if ($confirmation -eq 'Y' -or $confirmation -eq 'y') {
        foreach ($app in $unusedApps) {
            try {
                $appId = $app.Id
                Write-Log "Deleting application: $appId ($($app.DisplayName))"
                Remove-MgApplication -ApplicationId $appId -Confirm:$false
                Write-Log "Deleted application: $appId ($($app.DisplayName))"
            } catch {
                Write-Log "Error deleting application with ID ${appId}: $($_.Exception.Message)"
            }
        }
    } else {
        Write-Host "Deletion cancelled."
    }
}

# Function to delete applications from a CSV file
function Delete-AppsFromCSV {
    if (!(Test-Path $ImportPath)) {
        Write-Host "CSV file not found at $ImportPath. Export apps first."
        Write-Log "CSV file not found for deletion: $ImportPath"
        return
    }

    $appsToDelete = Import-Csv -Path $ImportPath

    if ($appsToDelete.Count -eq 0) {
        Write-Host "No applications found in CSV file for deletion."
        return
    }

    Write-Host "Found $($appsToDelete.Count) applications in CSV for deletion. Do you want to proceed? (Y/N)"
    $confirmation = Read-Host

    if ($confirmation -eq 'Y' -or $confirmation -eq 'y') {
        foreach ($app in $appsToDelete) {
            try {
                $appId = $app.Id
                Write-Log "Deleting application from CSV: $appId ($($app.DisplayName))"
                Remove-MgApplication -ApplicationId $appId -Confirm:$false
                Write-Log "Deleted application: $appId ($($app.DisplayName))"
            } catch {
                Write-Log "Error deleting application with ID ${appId}: $($_.Exception.Message)"
            }
        }
    } else {
        Write-Host "Deletion cancelled."
    }
}

# Menu function
function Show-Menu {
    Clear-Host
    Write-Host "1. Export unused user-created applications"
    Write-Host "2. Delete unused user-created applications"
    Write-Host "3. Delete applications from CSV ($ImportPath)"
    Write-Host "4. Exit"
    
    $choice = Read-Host "Enter your choice"

    switch ($choice) {
        "1" { Get-UnusedUserCreatedApps }
        "2" { Delete-UnusedApps }
        "3" { Delete-AppsFromCSV }
        "4" { Exit }
        default { Write-Host "Invalid choice, try again." }
    }
}

# Run the menu
Show-Menu
