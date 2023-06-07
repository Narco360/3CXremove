Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -force
Write-Host "Script execution started."

Set-variable -Name "PCname"  -Value  "$([Environment]::MachineName)"  <#read pc name#> 
Get-variable -Name "PCname"    <#show pc name#>    

if (Get-Process -Name "3CXDesktopApp" -ErrorAction SilentlyContinue) {
    write-host "The app is running, killing it !"
    Stop-Process -Name "3CXDesktopApp" -Force
}

$AppName = "3CXDesktopApp"  # Replace with the name of the application you want to uninstall

$UninstallString = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
    Where-Object { $_.DisplayName -eq $AppName } |
    Select-Object -ExpandProperty UninstallString

if ($UninstallString) {
    Write-Host "Uninstalling $AppName..."
    Start-Process -FilePath $UninstallString -Wait
    Write-Host "Uninstallation of $AppName completed."
} else {
    Write-Host "The application $AppName is not installed."
}

$Programs = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "3CXDesktopApp" }
if ($Programs) {
    Write-Host "Found the '3CXDesktopApp' application. Uninstalling..."
    foreach ($Program in $Programs) {
        $Program.Uninstall()
    }
    Write-Host "Uninstallation completed."
} else {
    Write-Host "The '3CXDesktopApp' application is not installed."
}

$Prog = Get-Process -Name "3CXDesktopApp" -ErrorAction SilentlyContinue
if ($Prog) {
    Write-Host "Found the '3CXDesktopApp' application. Uninstalling..."
    $Prog.Uninstall
    Write-Host "Uninstallation completed."
} else {
    Write-Host "The '3CXDesktopApp' application is not installed."
}

$ListOfLocations = @(
    "C:\Program Files\3CXDesktopApp",
    "C:\Programmes\3CXDesktopApp",
    "C:\Programmes (x86)\3CXDesktopApp",
    "C:\Program Files (x86)\3CXDesktopApp",
    "C:\Program Files\3CX Desktop App",
    "C:\Programmes\3CX Desktop App",
    "C:\Programmes (x86)\3CX Desktop App",
    "C:\Program Files (x86)\3CX Desktop App",
    "C:\Users\*\AppData\Local\Programs\3CXDesktopApp",
    "C:\Users\*\AppData\Roaming\3CXDesktopApp" 
    )
 
foreach ($Location in $ListOfLocations) {
    if (Test-Path $Location) {
        Write-Host "Found 3CX Desktop App at '$Location', deleting folder..."
        Remove-Item -Path $Location -Recurse -Force
        Write-Host "Successfully removed 3CX Desktop App at '$Location'"
    } else {
        Write-Host "3CX Desktop App not found at '$Location'"
    }
}

$desktopPath = [Environment]::GetFolderPath("Desktop")

# remove "3CXDesktopApp"
$filesToRemove1 = Get-ChildItem -Path $desktopPath -Filter "3CXDesktopApp" -File
foreach ($file1 in $filesToRemove1) {
    Remove-Item -Path $file1.FullName -Force
    Write-Host "Le fichier $($file1.Name) a été supprimé du bureau."
}

# remove "3CX Desktop App"
$filesToRemove2 = Get-ChildItem -Path $desktopPath -Filter "3CX Desktop App" -File
foreach ($file2 in $filesToRemove2) {
    Remove-Item -Path $file2.FullName -Force
    Write-Host "Le fichier $($file2.Name) a été supprimé du bureau."
}

#pause
