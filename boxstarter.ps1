$RepoDir="C:\dev\.setup"
## This command disables User Account Control to run the script without user interaction, it is enabled at the end of the script.
## To avoid security concerns you can comment it if you prefer, otherwhise please check the software you install is safe and use this command at your own risk.
Disable-UAC
$Boxstarter.AutoLogin=$false
# Install git and clone repository containing scripts and config files
# TODO: see how to improve install that by using chezmoi (choco install -y chezmoi)
choco install -y git --params "/GitOnlyOnPath /NoShellIntegration /WindowsTerminal"
RefreshEnv
git clone https://github.com/erikblessman/dev-setup.git $RepoDir
# Git configuration
Remove-Item -Path "$env:USERPROFILE\.gitconfig" -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\.gitconfig" -Target "$RepoDir\config\git\.gitconfig"
# TODO: configure git signature

# Winget configuration
Remove-Item -Path "$env:USERPROFILE\AppData\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Force
New-Item -ItemType SymbolicLink -Path "$env:USERPROFILE\AppData\Local\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe\LocalState\settings.json" -Target "$RepoDir\config\winget\settings.json"

#--- Enable developer mode on the system ---
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\AppModelUnlock -Name AllowDevelopmentWithoutDevLicense -Value 1

#--- Setting up Windows ---
. "$RepoDir\scripts\FileExplorerSettings.ps1"
. "$RepoDir\scripts\RemoveDefaultApps.ps1"
. "$RepoDir\scripts\Tools.ps1"
. "$RepoDir\scripts\IDEs.ps1"

# TODO: install WSL2 / Ubuntu
# choco install -y Microsoft-Windows-Subsystem-Linux -source windowsfeatures
# choco install -y VirtualMachinePlatform -source windowsfeatures
# wsl --set-default-version 2
# choco install wsl2 --params "/Version:2 /Retry:true"

# TODO: Docker
# winget install -e -h --id suse.RancherDesktop

# // windowsfeatures (Windows Sandbox, .NET Framework)
# // Taskbar (Set-BoxstarterTaskbarOptions)

#--- reenabling critial items ---
Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
