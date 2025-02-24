# Entra ID Guest User Management Script

## Overview
This PowerShell script helps manage **Guest Users** in Microsoft Entra ID (formerly Azure AD). It provides the ability to:

- **Find guest users** who have not accepted their invite.
- **Find guest users** who have not signed in for 30+ days.
- **Export user data** to CSV files.
- **Delete users** listed in the exported CSV files.
- **Log actions** for troubleshooting.

## Features
✅ Export guest users with **pending acceptance** to `PendingGuests.csv`  
✅ Export guest users **inactive for 30+ days** to `InactiveGuests.csv`  
✅ **Option to delete** guest users listed in CSV files  
✅ **Logs all actions** for auditing and troubleshooting  
✅ **Automates guest user management** in Microsoft Entra ID  

## Prerequisites
Before running the script, ensure the following:

1. **PowerShell 7+** (Recommended)
2. **Microsoft Graph PowerShell Module**  
   Install it using:
   ```powershell
   Install-Module Microsoft.Graph -Scope CurrentUser
