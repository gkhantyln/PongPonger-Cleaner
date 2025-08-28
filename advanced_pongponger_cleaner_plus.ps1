# === ADVANCED PLUS PONGPONGER CLEANER WITH MENU OPTIONS ===
# Comprehensive detection and cleanup tool with user interaction
# Enhanced version with browser extension checking and specific PongPonger entry removal

# Clear the console
Clear-Host

# Display banner
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "    ADVANCED PLUS PONGPONGER CLEANER TOOL       " -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Function to display the main menu
function Show-MainMenu {
    Write-Host "MAIN MENU" -ForegroundColor Yellow
    Write-Host "---------" -ForegroundColor Yellow
    Write-Host "1. Automatic Full Scan and Cleanup (All Components)" -ForegroundColor Green
    Write-Host "2. Manual Step-by-Step Process" -ForegroundColor Green
    Write-Host "3. Registry Scan Only" -ForegroundColor Green
    Write-Host "4. Scheduled Tasks Scan Only" -ForegroundColor Green
    Write-Host "5. File/Folder Scan Only" -ForegroundColor Green
    Write-Host "6. Browser Shortcuts Scan Only" -ForegroundColor Green
    Write-Host "7. Hosts File Scan Only" -ForegroundColor Green
    Write-Host "8. Services Scan Only" -ForegroundColor Green
    Write-Host "9. Browser Extensions Check (Information Only)" -ForegroundColor Green
    Write-Host "10. Exit" -ForegroundColor Red
    Write-Host ""
}

# Function to pause and wait for user input
function Pause-Script {
    Write-Host ""
    Write-Host "Press any key to continue..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    Write-Host ""
}

# Function to log actions
function Write-Log {
    param([string]$Message, [string]$Type = "INFO")
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Type] $Message"
    
    # Also display to console
    switch ($Type) {
        "INFO" { Write-Host $logMessage -ForegroundColor White }
        "SUCCESS" { Write-Host $logMessage -ForegroundColor Green }
        "WARNING" { Write-Host $logMessage -ForegroundColor Yellow }
        "ERROR" { Write-Host $logMessage -ForegroundColor Red }
        "DETECTION" { Write-Host $logMessage -ForegroundColor Magenta }
    }
    
    # Write to log file
    $logMessage | Out-File -FilePath "$env:TEMP\PongPongerCleanerAdvanced.log" -Append
}

# Function to scan registry entries
function Scan-Registry {
    Write-Log "Starting registry scan..." "INFO"
    
    $registryEntries = @()
    # Extended registry locations
    $runKeys = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunServices",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunServices",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce"
    )
    
    foreach ($key in $runKeys) {
        try {
            $props = Get-ItemProperty -Path $key -ErrorAction SilentlyContinue
            $propNames = $props.PSObject.Properties.Name | Where-Object { 
                $_ -ne "PSPath" -and $_ -ne "PSParentPath" -and 
                $_ -ne "PSChildName" -and $_ -ne "PSDrive" -and 
                $_ -ne "PSProvider" 
            }
            
            foreach ($name in $propNames) {
                $value = $props.$name
                # Check for suspicious entries
                if ($name -match "screenrec|user|explorer" -or 
                    $value -match "StreamingVideoProvider|screenrec|pongponger\.click") {
                    $registryEntries += [PSCustomObject]@{
                        Path = $key
                        Name = $name
                        Value = $value
                        Type = "Suspicious"
                    }
                    Write-Log "Detected suspicious registry entry: $key\$name = $value" "DETECTION"
                }
            }
        } catch {
            Write-Log "Error accessing registry key: $key" "ERROR"
        }
    }
    
    Write-Log "Registry scan completed. Found $($registryEntries.Count) suspicious entries." "INFO"
    return $registryEntries
}

# Function to clean registry entries
function Clean-Registry {
    param([array]$Entries)
    
    Write-Log "Starting registry cleanup..." "INFO"
    
    foreach ($entry in $Entries) {
        try {
            Remove-ItemProperty -Path $entry.Path -Name $entry.Name -ErrorAction SilentlyContinue
            Write-Log "Removed registry entry: $($entry.Path)\$($entry.Name)" "SUCCESS"
        } catch {
            Write-Log "Failed to remove registry entry: $($entry.Path)\$($entry.Name)" "ERROR"
        }
    }
    
    Write-Log "Registry cleanup completed." "INFO"
}

# Function to remove specific PongPonger registry entry
function Remove-PongPongerSpecificEntry {
    Write-Log "Checking for specific PongPonger registry entry..." "INFO"
    
    # Registry locations to check for the specific "user" entry
    $registryLocations = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
    )
    
    $removedEntries = 0
    
    foreach ($location in $registryLocations) {
        try {
            # Check if the "user" entry exists
            $entryExists = Get-ItemProperty -Path $location -Name "user" -ErrorAction SilentlyContinue
            if ($entryExists) {
                # Check if it contains the malicious pattern
                if ($entryExists.user -match "explorer\.exe.*pongponger\.click") {
                    Write-Log "Found specific PongPonger entry in: $location" "DETECTION"
                    Write-Log "Value: $($entryExists.user)" "DETECTION"
                    
                    # Remove the entry
                    Remove-ItemProperty -Path $location -Name "user" -ErrorAction Stop
                    Write-Log "Successfully removed PongPonger entry from $location" "SUCCESS"
                    $removedEntries++
                } elseif ($entryExists.user -match "explorer\.exe") {
                    # Additional check for explorer.exe entries that might be suspicious
                    Write-Log "Found explorer.exe entry in: $location - checking for potential threat" "WARNING"
                    Write-Log "Value: $($entryExists.user)" "WARNING"
                }
            }
        } catch [System.Management.Automation.ItemNotFoundException] {
            # Entry doesn't exist, continue
            continue
        } catch {
            Write-Log "Error accessing $location : $($_.Exception.Message)" "ERROR"
        }
    }
    
    if ($removedEntries -eq 0) {
        Write-Log "No specific PongPonger registry entries found." "INFO"
    } else {
        Write-Log "Successfully removed $removedEntries specific PongPonger registry entries." "SUCCESS"
    }
    
    return $removedEntries
}

# Function to scan scheduled tasks
function Scan-ScheduledTasks {
    Write-Log "Starting scheduled tasks scan..." "INFO"
    
    $suspiciousTasks = @()
    try {
        $tasks = Get-ScheduledTask | Where-Object {
            $_.Actions.Execute -match "explorer.exe|screenrec|StreamingVideoProvider" -or
            $_.TaskName -match "screenrec|explorer"
        }
        
        foreach ($task in $tasks) {
            $suspiciousTasks += $task
            Write-Log "Detected suspicious scheduled task: $($task.TaskName)" "DETECTION"
        }
    } catch {
        Write-Log "Error scanning scheduled tasks: $($_.Exception.Message)" "ERROR"
    }
    
    Write-Log "Scheduled tasks scan completed. Found $($suspiciousTasks.Count) suspicious tasks." "INFO"
    return $suspiciousTasks
}

# Function to clean scheduled tasks
function Clean-ScheduledTasks {
    param([array]$Tasks)
    
    Write-Log "Starting scheduled tasks cleanup..." "INFO"
    
    foreach ($task in $Tasks) {
        try {
            Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false -ErrorAction SilentlyContinue
            Write-Log "Removed scheduled task: $($task.TaskName)" "SUCCESS"
        } catch {
            Write-Log "Failed to remove scheduled task: $($task.TaskName)" "ERROR"
        }
    }
    
    Write-Log "Scheduled tasks cleanup completed." "INFO"
}

# Function to scan files and folders
function Scan-FilesAndFolders {
    Write-Log "Starting files and folders scan..." "INFO"
    
    $suspiciousPaths = @()
    
    # Common paths where PongPonger might be installed
    $pathsToCheck = @(
        "$env:LOCALAPPDATA\StreamingVideoProvider",
        "$env:APPDATA\StreamingVideoProvider",
        "$env:PROGRAMDATA\StreamingVideoProvider",
        "$env:TEMP\StreamingVideoProvider",
        "$env:USERPROFILE\Desktop\ScreenRec.lnk",
        "$env:PUBLIC\Desktop\ScreenRec.lnk"
    )
    
    foreach ($path in $pathsToCheck) {
        if (Test-Path $path) {
            $suspiciousPaths += $path
            Write-Log "Detected suspicious path: $path" "DETECTION"
        }
    }
    
    # Extended startup folders
    $startupFolders = @(
        "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup",
        "$env:PROGRAMDATA\Microsoft\Windows\Start Menu\Programs\Startup",
        "$env:PUBLIC\Desktop",
        "$env:USERPROFILE\Desktop"
    )
    
    foreach ($folder in $startupFolders) {
        if (Test-Path $folder) {
            $items = Get-ChildItem $folder -ErrorAction SilentlyContinue | Where-Object {
                $_.Name -match "screenrec|StreamingVideoProvider|explorer.*\.exe" -or
                $_.Extension -match "\.exe|\.bat|\.cmd|\.scr|\.lnk"
            }
            
            foreach ($item in $items) {
                $fullPath = $item.FullName
                $suspiciousPaths += $fullPath
                Write-Log "Detected suspicious startup item: $fullPath" "DETECTION"
            }
        }
    }
    
    Write-Log "Files and folders scan completed. Found $($suspiciousPaths.Count) suspicious items." "INFO"
    return $suspiciousPaths
}

# Function to clean files and folders
function Clean-FilesAndFolders {
    param([array]$Paths)
    
    Write-Log "Starting files and folders cleanup..." "INFO"
    
    foreach ($path in $Paths) {
        try {
            if (Test-Path $path) {
                if (Get-Item $path -ErrorAction SilentlyContinue | Where-Object { $_.PSIsContainer }) {
                    Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
                    Write-Log "Removed folder: $path" "SUCCESS"
                } else {
                    Remove-Item -Path $path -Force -ErrorAction SilentlyContinue
                    Write-Log "Removed file: $path" "SUCCESS"
                }
            }
        } catch {
            Write-Log "Failed to remove path: $path" "ERROR"
        }
    }
    
    Write-Log "Files and folders cleanup completed." "INFO"
}

# Function to scan browser shortcuts
function Scan-BrowserShortcuts {
    Write-Host "Starting browser shortcuts scan..." -ForegroundColor Cyan
    
    $suspiciousShortcuts = @()
    
    # Browser profiles paths
    $browserPaths = @(
        # Chrome
        "$env:LOCALAPPDATA\Google\Chrome\User Data",
        # Firefox
        "$env:APPDATA\Mozilla\Firefox\Profiles",
        # Edge
        "$env:LOCALAPPDATA\Microsoft\Edge\User Data",
        # Opera
        "$env:APPDATA\Opera Software\Opera Stable",
        # Brave
        "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data"
    )
    
    foreach ($basePath in $browserPaths) {
        if (Test-Path $basePath) {
            try {
                $shortcuts = Get-ChildItem -Path $basePath -Recurse -Include "*.lnk" -ErrorAction SilentlyContinue |
                    Where-Object { $_.Name -match "screenrec|StreamingVideoProvider" }
                
                foreach ($shortcut in $shortcuts) {
                    $suspiciousShortcuts += $shortcut.FullName
                    Write-Host "Detected suspicious browser shortcut: $($shortcut.FullName)" -ForegroundColor Magenta
                }
            } catch {
                Write-Host "Error scanning browser path: $basePath" -ForegroundColor Red
            }
        }
    }
    
    Write-Host "Browser shortcuts scan completed. Found $($suspiciousShortcuts.Count) suspicious shortcuts." -ForegroundColor Cyan
    return $suspiciousShortcuts
}

# Function to clean browser shortcuts
function Clean-BrowserShortcuts {
    param([array]$Shortcuts)
    
    Write-Host "Starting browser shortcuts cleanup..." -ForegroundColor Cyan
    
    foreach ($shortcut in $Shortcuts) {
        try {
            if (Test-Path $shortcut) {
                Remove-Item -Path $shortcut -Force -ErrorAction SilentlyContinue
                Write-Host "Removed browser shortcut: $shortcut" -ForegroundColor Green
            }
        } catch {
            Write-Host "Failed to remove browser shortcut: $shortcut" -ForegroundColor Red
        }
    }
    
    Write-Host "Browser shortcuts cleanup completed." -ForegroundColor Cyan
}

# Function to scan hosts file
function Scan-HostsFile {
    Write-Host "Starting hosts file scan..." -ForegroundColor Cyan
    
    $suspiciousHosts = @()
    $hostsPath = "$env:windir\System32\drivers\etc\hosts"
    
    if (Test-Path $hostsPath) {
        try {
            $hostsContent = Get-Content $hostsPath -ErrorAction SilentlyContinue
            $suspiciousLines = $hostsContent | Where-Object {
                $_ -match "StreamingVideoProvider|screenrec" -and 
                $_ -notmatch "^#" -and 
                $_ -notmatch "^\s*$"
            }
            
            foreach ($line in $suspiciousLines) {
                $suspiciousHosts += $line
                Write-Host "Detected suspicious hosts entry: $line" -ForegroundColor Magenta
            }
        } catch {
            Write-Host "Error reading hosts file: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Write-Host "Hosts file scan completed. Found $($suspiciousHosts.Count) suspicious entries." -ForegroundColor Cyan
    return $suspiciousHosts
}

# Function to clean hosts file
function Clean-HostsFile {
    param([array]$HostsEntries)
    
    Write-Host "Starting hosts file cleanup..." -ForegroundColor Cyan
    
    $hostsPath = "$env:windir\System32\drivers\etc\hosts"
    
    if (Test-Path $hostsPath) {
        try {
            $hostsContent = Get-Content $hostsPath -ErrorAction SilentlyContinue
            $newContent = $hostsContent | Where-Object {
                $line = $_
                -not ($HostsEntries | Where-Object { $line -match [regex]::Escape($_) })
            }
            
            # Backup original hosts file
            Copy-Item -Path $hostsPath -Destination "$hostsPath.backup.advanced" -Force -ErrorAction SilentlyContinue
            
            # Write cleaned content
            $newContent | Out-File -FilePath $hostsPath -Encoding ASCII -Force
            Write-Host "Hosts file cleaned and backed up to $hostsPath.backup.advanced" -ForegroundColor Green
        } catch {
            Write-Host "Error cleaning hosts file: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    
    Write-Host "Hosts file cleanup completed." -ForegroundColor Cyan
}

# Function to scan Windows services
function Scan-Services {
    Write-Log "Starting Windows services scan..." "INFO"
    
    $suspiciousServices = @()
    try {
        $services = Get-WmiObject -Class Win32_Service | Where-Object {
            $_.Name -like "*screenrec*" -or 
            $_.PathName -like "*StreamingVideoProvider*"
        }
        
        foreach ($service in $services) {
            $suspiciousServices += $service
            Write-Log "Detected suspicious service: $($service.Name)" "DETECTION"
        }
    } catch {
        Write-Log "Error scanning services: $($_.Exception.Message)" "ERROR"
    }
    
    Write-Log "Services scan completed. Found $($suspiciousServices.Count) suspicious services." "INFO"
    return $suspiciousServices
}

# Function to clean Windows services
function Clean-Services {
    param([array]$Services)
    
    Write-Log "Starting services cleanup..." "INFO"
    
    foreach ($service in $Services) {
        try {
            Stop-Process -Name $service.Name -Force -ErrorAction SilentlyContinue
            Write-Log "Stopped service: $($service.Name)" "SUCCESS"
            # Note: Complete service removal may require additional steps
        } catch {
            Write-Log "Failed to stop service: $($service.Name)" "ERROR"
        }
    }
    
    Write-Log "Services cleanup completed." "INFO"
}

# Function to check browser extensions (information only)
function Check-BrowserExtensions {
    Write-Host "Checking browser extensions for PongPonger components..." -ForegroundColor Cyan
    Write-Host "=====================================================" -ForegroundColor Cyan
    
    Write-Host "Please manually check your browser extensions for the following:" -ForegroundColor Yellow
    Write-Host ""
    
    Write-Host "CHROME:" -ForegroundColor Green
    Write-Host "  1. Open Chrome and go to: chrome://extensions/" -ForegroundColor White
    Write-Host "  2. Enable 'Developer mode' in the top right corner" -ForegroundColor White
    Write-Host "  3. Look for extensions named: ScreenRec, StreamingVideoProvider" -ForegroundColor White
    Write-Host "  4. Remove any suspicious extensions" -ForegroundColor White
    Write-Host ""
    
    Write-Host "FIREFOX:" -ForegroundColor Green
    Write-Host "  1. Open Firefox and go to: about:addons" -ForegroundColor White
    Write-Host "  2. Click on 'Extensions' in the left panel" -ForegroundColor White
    Write-Host "  3. Look for extensions named: ScreenRec, StreamingVideoProvider" -ForegroundColor White
    Write-Host "  4. Remove any suspicious extensions" -ForegroundColor White
    Write-Host ""
    
    Write-Host "EDGE:" -ForegroundColor Green
    Write-Host "  1. Open Edge and go to: edge://extensions/" -ForegroundColor White
    Write-Host "  2. Enable 'Developer mode' in the left panel" -ForegroundColor White
    Write-Host "  3. Look for extensions named: ScreenRec, StreamingVideoProvider" -ForegroundColor White
    Write-Host "  4. Remove any suspicious extensions" -ForegroundColor White
    Write-Host ""
    
    Write-Host "OPERA:" -ForegroundColor Green
    Write-Host "  1. Open Opera and go to: opera://extensions/" -ForegroundColor White
    Write-Host "  2. Enable 'Developer mode' in the top right corner" -ForegroundColor White
    Write-Host "  3. Look for extensions named: ScreenRec, StreamingVideoProvider" -ForegroundColor White
    Write-Host "  4. Remove any suspicious extensions" -ForegroundColor White
    Write-Host ""
    
    Write-Host "IMPORTANT NOTES:" -ForegroundColor Yellow
    Write-Host "  - Browser extensions cannot be automatically removed by this script" -ForegroundColor White
    Write-Host "  - You must manually review and remove suspicious extensions" -ForegroundColor White
    Write-Host "  - Restart your browser after removing extensions" -ForegroundColor White
}

# Function for automatic full scan and cleanup
function Start-AutomaticCleanup {
    Write-Host "Starting automatic full scan and cleanup..." -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    
    # 1. Remove specific PongPonger registry entry first
    Write-Host ""
    Write-Host "Removing specific PongPonger registry entries..." -ForegroundColor Yellow
    $specificEntriesRemoved = Remove-PongPongerSpecificEntry
    
    # 2. Registry scan and cleanup
    $registryEntries = Scan-Registry
    if ($registryEntries.Count -gt 0) {
        Write-Host ""
        Write-Host "Cleaning registry entries..." -ForegroundColor Yellow
        Clean-Registry -Entries $registryEntries
    }
    
    # 3. Scheduled tasks scan and cleanup
    $scheduledTasks = Scan-ScheduledTasks
    if ($scheduledTasks.Count -gt 0) {
        Write-Host ""
        Write-Host "Cleaning scheduled tasks..." -ForegroundColor Yellow
        Clean-ScheduledTasks -Tasks $scheduledTasks
    }
    
    # 4. Files and folders scan and cleanup
    $filePaths = Scan-FilesAndFolders
    if ($filePaths.Count -gt 0) {
        Write-Host ""
        Write-Host "Cleaning files and folders..." -ForegroundColor Yellow
        Clean-FilesAndFolders -Paths $filePaths
    }
    
    # 5. Browser shortcuts scan and cleanup
    $browserShortcuts = Scan-BrowserShortcuts
    if ($browserShortcuts.Count -gt 0) {
        Write-Host ""
        Write-Host "Cleaning browser shortcuts..." -ForegroundColor Yellow
        Clean-BrowserShortcuts -Shortcuts $browserShortcuts
    }
    
    # 6. Hosts file scan and cleanup
    $hostsEntries = Scan-HostsFile
    if ($hostsEntries.Count -gt 0) {
        Write-Host ""
        Write-Host "Cleaning hosts file..." -ForegroundColor Yellow
        Clean-HostsFile -HostsEntries $hostsEntries
    }
    
    # 7. Services scan and cleanup
    $services = Scan-Services
    if ($services.Count -gt 0) {
        Write-Host ""
        Write-Host "Cleaning services..." -ForegroundColor Yellow
        Clean-Services -Services $services
    }
    
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "AUTOMATIC CLEANUP COMPLETED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Please restart your computer for all changes to take effect." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "IMPORTANT: Please also check your browser extensions manually:" -ForegroundColor Yellow
    Write-Host "  - Chrome: chrome://extensions/" -ForegroundColor White
    Write-Host "  - Firefox: about:addons" -ForegroundColor White
    Write-Host "  - Edge: edge://extensions/" -ForegroundColor White
    Write-Host "  - Opera: opera://extensions/" -ForegroundColor White
    Write-Host "  - Look for: ScreenRec, StreamingVideoProvider" -ForegroundColor White
}

# Function for manual step-by-step process
function Start-ManualProcess {
    do {
        Write-Host ""
        Write-Host "MANUAL STEP-BY-STEP PROCESS" -ForegroundColor Yellow
        Write-Host "---------------------------" -ForegroundColor Yellow
        Write-Host "1. Remove specific PongPonger registry entry" -ForegroundColor Green
        Write-Host "2. Scan and clean registry" -ForegroundColor Green
        Write-Host "3. Scan and clean scheduled tasks" -ForegroundColor Green
        Write-Host "4. Scan and clean files/folders" -ForegroundColor Green
        Write-Host "5. Scan and clean browser shortcuts" -ForegroundColor Green
        Write-Host "6. Scan and clean hosts file" -ForegroundColor Green
        Write-Host "7. Scan and clean services" -ForegroundColor Green
        Write-Host "8. Check browser extensions (information only)" -ForegroundColor Green
        Write-Host "9. Back to main menu" -ForegroundColor Red
        Write-Host ""
        
        $choice = Read-Host "Select an option (1-9)"
        
        switch ($choice) {
            "1" {
                Write-Host ""
                Write-Host "Removing specific PongPonger registry entry..." -ForegroundColor Yellow
                $specificEntriesRemoved = Remove-PongPongerSpecificEntry
                Write-Host "Specific PongPonger registry entry removal completed." -ForegroundColor Green
                Pause-Script
            }
            "2" {
                Write-Host ""
                $registryEntries = Scan-Registry
                if ($registryEntries.Count -gt 0) {
                    $confirm = Read-Host "Do you want to clean these registry entries? (Y/N)"
                    if ($confirm -eq "Y" -or $confirm -eq "y") {
                        Clean-Registry -Entries $registryEntries
                    }
                }
                Pause-Script
            }
            "3" {
                Write-Host ""
                $scheduledTasks = Scan-ScheduledTasks
                if ($scheduledTasks.Count -gt 0) {
                    $confirm = Read-Host "Do you want to clean these scheduled tasks? (Y/N)"
                    if ($confirm -eq "Y" -or $confirm -eq "y") {
                        Clean-ScheduledTasks -Tasks $scheduledTasks
                    }
                }
                Pause-Script
            }
            "4" {
                Write-Host ""
                $filePaths = Scan-FilesAndFolders
                if ($filePaths.Count -gt 0) {
                    $confirm = Read-Host "Do you want to clean these files/folders? (Y/N)"
                    if ($confirm -eq "Y" -or $confirm -eq "y") {
                        Clean-FilesAndFolders -Paths $filePaths
                    }
                }
                Pause-Script
            }
            "5" {
                Write-Host ""
                $browserShortcuts = Scan-BrowserShortcuts
                if ($browserShortcuts.Count -gt 0) {
                    $confirm = Read-Host "Do you want to clean these browser shortcuts? (Y/N)"
                    if ($confirm -eq "Y" -or $confirm -eq "y") {
                        Clean-BrowserShortcuts -Shortcuts $browserShortcuts
                    }
                }
                Pause-Script
            }
            "6" {
                Write-Host ""
                $hostsEntries = Scan-HostsFile
                if ($hostsEntries.Count -gt 0) {
                    $confirm = Read-Host "Do you want to clean these hosts entries? (Y/N)"
                    if ($confirm -eq "Y" -or $confirm -eq "y") {
                        Clean-HostsFile -HostsEntries $hostsEntries
                    }
                }
                Pause-Script
            }
            "7" {
                Write-Host ""
                $services = Scan-Services
                if ($services.Count -gt 0) {
                    $confirm = Read-Host "Do you want to clean these services? (Y/N)"
                    if ($confirm -eq "Y" -or $confirm -eq "y") {
                        Clean-Services -Services $services
                    }
                }
                Pause-Script
            }
            "8" {
                Write-Host ""
                Check-BrowserExtensions
                Pause-Script
            }
            "9" {
                return
            }
            default {
                Write-Host "Invalid option. Please select 1-9." -ForegroundColor Red
                Pause-Script
            }
        }
    } while ($true)
}

# Main script execution
do {
    Show-MainMenu
    $userChoice = Read-Host "Select an option (1-10)"
    
    switch ($userChoice) {
        "1" {
            Write-Host ""
            Start-AutomaticCleanup
            Pause-Script
        }
        "2" {
            Write-Host ""
            Start-ManualProcess
        }
        "3" {
            Write-Host ""
            Write-Host "Registry Scan Only" -ForegroundColor Yellow
            Write-Host "==================" -ForegroundColor Yellow
            $registryEntries = Scan-Registry
            if ($registryEntries.Count -gt 0) {
                Write-Host ""
                $confirm = Read-Host "Do you want to clean these registry entries? (Y/N)"
                if ($confirm -eq "Y" -or $confirm -eq "y") {
                    Clean-Registry -Entries $registryEntries
                }
            }
            Pause-Script
        }
        "4" {
            Write-Host ""
            Write-Host "Scheduled Tasks Scan Only" -ForegroundColor Yellow
            Write-Host "=========================" -ForegroundColor Yellow
            $scheduledTasks = Scan-ScheduledTasks
            if ($scheduledTasks.Count -gt 0) {
                Write-Host ""
                $confirm = Read-Host "Do you want to clean these scheduled tasks? (Y/N)"
                if ($confirm -eq "Y" -or $confirm -eq "y") {
                    Clean-ScheduledTasks -Tasks $scheduledTasks
                }
            }
            Pause-Script
        }
        "5" {
            Write-Host ""
            Write-Host "Files/Folders Scan Only" -ForegroundColor Yellow
            Write-Host "=======================" -ForegroundColor Yellow
            $filePaths = Scan-FilesAndFolders
            if ($filePaths.Count -gt 0) {
                Write-Host ""
                $confirm = Read-Host "Do you want to clean these files/folders? (Y/N)"
                if ($confirm -eq "Y" -or $confirm -eq "y") {
                    Clean-FilesAndFolders -Paths $filePaths
                }
            }
            Pause-Script
        }
        "6" {
            Write-Host ""
            Write-Host "Browser Shortcuts Scan Only" -ForegroundColor Yellow
            Write-Host "===========================" -ForegroundColor Yellow
            $browserShortcuts = Scan-BrowserShortcuts
            if ($browserShortcuts.Count -gt 0) {
                Write-Host ""
                $confirm = Read-Host "Do you want to clean these browser shortcuts? (Y/N)"
                if ($confirm -eq "Y" -or $confirm -eq "y") {
                    Clean-BrowserShortcuts -Shortcuts $browserShortcuts
                }
            }
            Pause-Script
        }
        "7" {
            Write-Host ""
            Write-Host "Hosts File Scan Only" -ForegroundColor Yellow
            Write-Host "====================" -ForegroundColor Yellow
            $hostsEntries = Scan-HostsFile
            if ($hostsEntries.Count -gt 0) {
                Write-Host ""
                $confirm = Read-Host "Do you want to clean these hosts entries? (Y/N)"
                if ($confirm -eq "Y" -or $confirm -eq "y") {
                    Clean-HostsFile -HostsEntries $hostsEntries
                }
            }
            Pause-Script
        }
        "8" {
            Write-Host ""
            Write-Host "Services Scan Only" -ForegroundColor Yellow
            Write-Host "==================" -ForegroundColor Yellow
            $services = Scan-Services
            if ($services.Count -gt 0) {
                Write-Host ""
                $confirm = Read-Host "Do you want to clean these services? (Y/N)"
                if ($confirm -eq "Y" -or $confirm -eq "y") {
                    Clean-Services -Services $services
                }
            }
            Pause-Script
        }
        "9" {
            Write-Host ""
            Check-BrowserExtensions
            Pause-Script
        }
        "10" {
            Write-Host ""
            Write-Host "Thank you for using Advanced Plus PongPonger Cleaner!" -ForegroundColor Cyan
            Write-Host "Log file saved to: $env:TEMP\PongPongerCleanerAdvanced.log" -ForegroundColor White
            Write-Host ""
            exit
        }
        default {
            Write-Host "Invalid option. Please select 1-10." -ForegroundColor Red
            Pause-Script
        }
    }
} while ($true)