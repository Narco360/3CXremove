# Bypass la politique d'exécution pour permettre l'exécution du script
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Affiche un message indiquant que l'exécution du script a commencé
Write-Host "L'exécution du script a commencé."

# Lecture du nom du PC
Set-Variable -Name "PCname" -Value "$([Environment]::MachineName)"
# Affichage du nom du PC
Get-Variable -Name "PCname"

# Vérifie si l'application "3CXDesktopApp" est en cours d'exécution et la ferme si c'est le cas
if (Get-Process -Name "3CXDesktopApp" -ErrorAction SilentlyContinue) {
    Write-Host "L'application est en cours d'exécution, fermeture en cours !"
    Stop-Process -Name "3CXDesktopApp" -Force
}

$AppName = "3CXDesktopApp"  # Remplacez par le nom de l'application que vous souhaitez désinstaller

# Récupère la chaîne de désinstallation de l'application à partir de la clé de registre
$UninstallString = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
    Where-Object { $_.DisplayName -eq $AppName } |
    Select-Object -ExpandProperty UninstallString

# Si la chaîne de désinstallation est disponible, lance la désinstallation de l'application
if ($UninstallString) {
    Write-Host "Désinstallation de $AppName..."
    Start-Process -FilePath $UninstallString -Wait
    Write-Host "Désinstallation de $AppName terminée."
} else {
    Write-Host "L'application $AppName n'est pas installée."
}

# Recherche l'application "3CXDesktopApp" à l'aide de WMI et désinstalle si trouvée
$Programs = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "3CXDesktopApp" }
if ($Programs) {
    Write-Host "L'application '3CXDesktopApp' a été trouvée. Désinstallation en cours..."
    foreach ($Program in $Programs) {
        $Program.Uninstall()
    }
    Write-Host "Désinstallation terminée."
} else {
    Write-Host "L'application '3CXDesktopApp' n'est pas installée."
}

# Vérifie si l'application "3CXDesktopApp" est en cours d'exécution et la désinstalle si c'est le cas
$Prog = Get-Process -Name "3CXDesktopApp" -ErrorAction SilentlyContinue
if ($Prog) {
    Write-Host "L'application '3CXDesktopApp' a été trouvée. Désinstallation en cours..."
    $Prog.Uninstall
    Write-Host "Désinstallation terminée."
} else {
    Write-Host "L'application '3CXDesktopApp' n'est pas installée."
}

# Liste des emplacements où l'application peut être installée
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

# Parcours des emplacements et suppression des dossiers correspondants s'ils existent
foreach ($Location in $ListOfLocations) {
    if (Test-Path $Location) {
        Write-Host "3CX Desktop App trouvée à l'emplacement '$Location', suppression du dossier en cours..."
        Remove-Item -Path $Location -Recurse -Force
        Write-Host "3CX Desktop App supprimée avec succès à l'emplacement '$Location'"
    } else {
        Write-Host "3CX Desktop App non trouvée à l'emplacement '$Location'"
    }
}

$desktopPath = [Environment]::GetFolderPath("Desktop")

# Supprime les fichiers "3CXDesktopApp" du bureau de l'utilisateur
$filesToRemove1 = Get-ChildItem -Path $desktopPath -Filter "3CXDesktopApp" -File
foreach ($file1 in $filesToRemove1) {
    Remove-Item -Path $file1.FullName -Force
    Write-Host "Le fichier $($file1.Name) a été supprimé du bureau."
}

# Supprime les fichiers "3CX Desktop App" du bureau de l'utilisateur
$filesToRemove2 = Get-ChildItem -Path $desktopPath -Filter "3CX Desktop App" -File
foreach ($file2 in $filesToRemove2) {
    Remove-Item -Path $file2.FullName -Force
    Write-Host "Le fichier $($file2.Name) a été supprimé du bureau."
}

# Pause
