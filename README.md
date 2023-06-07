# 3CXremove
This is a powershell project to remove the 3CXDesktopApp related to the CVE-2023-29059
#
### CVE-2023-29059 :
("3CX DesktopApp through 18.12.416 has embedded malicious code, as exploited in the wild in March 2023. This affects versions 18.12.407 and 18.12.416 of the 3CX DesktopApp Electron Windows application shipped in Update 7, and versions 18.11.1213, 18.12.402, 18.12.407, and 18.12.416 of the 3CX DesktopApp Electron macOS application.")
#
So Im making a script to remove it and all its folders...

## UPDATES

* ** 06/06/2023 ** : the script is working under admin powershell still not with windows Intune /working on it/
* ** 07/06/2023 ** : The files have been deleted through Intune. The script is returning an error, but that's only because it's unable to uninstall the application. However, the file deletion functionality is working correctly. Additionally, a new path has been added.

## [Script](Uninstall&RemoveFiles3cx)
