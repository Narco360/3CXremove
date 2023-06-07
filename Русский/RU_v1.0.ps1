# Пропустить политику выполнения для разрешения выполнения сценария
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force

# Отобразить сообщение о начале выполнения сценария
Write-Host "Выполнение сценария началось."

# Прочитать имя ПК
Set-Variable -Name "PCname" -Value "$([Environment]::MachineName)"
# Отобразить имя ПК
Get-Variable -Name "PCname"

# Проверить, выполняется ли приложение "3CXDesktopApp" и закрыть его, если да
if (Get-Process -Name "3CXDesktopApp" -ErrorAction SilentlyContinue) {
    Write-Host "Приложение запущено, закрывается!"
    Stop-Process -Name "3CXDesktopApp" -Force
}

$AppName = "3CXDesktopApp"  # Замените на имя приложения, которое нужно удалить

# Получить строку деинсталляции приложения из реестра
$UninstallString = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*" |
    Where-Object { $_.DisplayName -eq $AppName } |
    Select-Object -ExpandProperty UninstallString

# Если строка деинсталляции доступна, запустить деинсталляцию приложения
if ($UninstallString) {
    Write-Host "Деинсталляция $AppName..."
    Start-Process -FilePath $UninstallString -Wait
    Write-Host "Деинсталляция $AppName завершена."
} else {
    Write-Host "Приложение $AppName не установлено."
}

# Поиск приложения "3CXDesktopApp" с помощью WMI и деинсталляция, если найдено
$Programs = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -eq "3CXDesktopApp" }
if ($Programs) {
    Write-Host "Приложение '3CXDesktopApp' найдено. Выполняется деинсталляция..."
    foreach ($Program in $Programs) {
        $Program.Uninstall()
    }
    Write-Host "Деинсталляция завершена."
} else {
    Write-Host "Приложение '3CXDesktopApp' не установлено."
}

# Проверить, выполняется ли приложение "3CXDesktopApp" и деинсталлировать его, если да
$Prog = Get-Process -Name "3CXDesktopApp" -ErrorAction SilentlyContinue
if ($Prog) {
    Write-Host "Приложение '3CXDesktopApp' найдено. Выполняется деинсталляция..."
    $Prog.Uninstall
    Write-Host "Деинсталляция завершена."
} else {
    Write-Host "Приложение '3CXDesktopApp' не установлено."
}

# Список расположений, где может быть установлено приложение
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

# Перебор расположений и удаление соответствующих папок, если они существуют
foreach ($Location in $ListOfLocations) {
    if (Test-Path $Location) {
        Write-Host "Папка 3CX Desktop App найдена в расположении '$Location', выполняется удаление..."
        Remove-Item -Path $Location -Recurse -Force
        Write-Host "3CX Desktop App успешно удалена из расположения '$Location'"
    } else {
        Write-Host "Папка 3CX Desktop App не найдена в расположении '$Location'"
    }
}

$desktopPath = [Environment]::GetFolderPath("Desktop")

# Удаление файлов "3CXDesktopApp" с рабочего стола пользователя
$filesToRemove1 = Get-ChildItem -Path $desktopPath -Filter "3CXDesktopApp" -File
foreach ($file1 in $filesToRemove1) {
    Remove-Item -Path $file1.FullName -Force
    Write-Host "Файл $($file1.Name) удален с рабочего стола."
}

# Удаление файлов "3CX Desktop App" с рабочего стола пользователя
$filesToRemove2 = Get-ChildItem -Path $desktopPath -Filter "3CX Desktop App" -File
foreach ($file2 in $filesToRemove2) {
    Remove-Item -Path $file2.FullName -Force
    Write-Host "Файл $($file2.Name) удален с рабочего стола."
}

# Пауза
