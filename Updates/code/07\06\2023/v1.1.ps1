# Bypass the execution policy to allow script execution
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Display a message indicating that the script has started execution
Write-Host "Script execution has started."

# Read the PC name
Set-Variable -Name "PCname" -Value "$([Environment]::MachineName)"
# Display the PC name
Get-Variable -Name "PCname"

# Check if the "3CXDesktopApp" application is running and close it if it is
if (Get-Process -Name "3CXDesktopApp" -ErrorAction SilentlyContinue) {
    Write-Host "The application is running, closing it!"
    Stop-Process -Name "3CXDesktopApp" -Force
}

$AppName = "3CXDesktopApp"  # Replace with the name of the application you want to uninstall

# Retrieve the uninstall string of the application from the registry key
$UninstallString = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
    Where-Object { $_.DisplayName -eq $AppName } |
    Select-Object -ExpandProperty UninstallString

# If the uninstall string is available, start the uninstallation of the application
if ($UninstallString) {
    Write-Host "Uninstalling $AppName..."
    Start-Process -FilePath $UninstallString -Wait
    Write-Host "$AppName uninstallation completed."
} else {
    Write-Host "The application $AppName is not installed."
}

# Search for the "3CXDesktopApp" application using WMI and uninstall if found
$Programs = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "3CXDesktopApp" }
if ($Programs) {
    Write-Host "The '3CXDesktopApp' application has been found. Uninstalling..."
    foreach ($Program in $Programs) {
        $Program.Uninstall()
    }
    Write-Host "Uninstallation completed."
} else {
    Write-Host "The '3CXDesktopApp' application is not installed."
}

# Check if the "3CXDesktopApp" application is running and uninstall it if found
$Prog = Get-Process -Name "3CXDesktopApp" -ErrorAction SilentlyContinue
if ($Prog) {
    Write-Host "The '3CXDesktopApp' application has been found. Uninstalling..."
    $Prog.Uninstall
    Write-Host "Uninstallation completed."
} else {
    Write-Host "The '3CXDesktopApp' application is not installed."
}

# List of locations where the application can be installed
$ListOfLocations = @(
    "C:\Program Files\3CXDesktopApp",
    "C:\Program Files (x86)\3CXDesktopApp",
    "C:\Program Files\3CX Desktop App",
    "C:\Program Files (x86)\3CX Desktop App",
    "C:\Users\*\AppData\Local\Programs\3CXDesktopApp",
    "C:\Users\*\AppData\Roaming\3CXDesktopApp"
)

# Traverse the locations and remove the corresponding folders if they exist
foreach ($Location in $ListOfLocations) {
    if (Test-Path $Location) {
        Write-Host "3CX Desktop App found at location '$Location', removing the folder..."
        Remove-Item -Path $Location -Recurse -Force
        Write-Host "3CX Desktop App successfully removed at location '$Location'"
    } else {
        Write-Host "3CX Desktop App not found at location '$Location'"
    }
}

$desktopPath = [Environment]::GetFolderPath("Desktop")

# Remove "3CXDesktopApp" files from the user's desktop
$filesToRemove1 = Get-ChildItem -Path $desktopPath -Filter "3CXDesktopApp" -File
foreach ($file1 in $filesToRemove1) {
    Remove-Item -Path $file1.FullName -Force
    Write-Host "The file $($file1.Name) has been removed from the desktop."
}

# Remove "3CX Desktop App" files from the user's desktop
$filesToRemove2 = Get-ChildItem -Path $desktopPath -Filter "3CX Desktop App" -File
foreach ($file2 in $filesToRemove2) {
    Remove-Item -Path $file2.FullName -Force
    Write-Host "The file $($file2.Name) has been removed from the desktop."
}

# Pause
