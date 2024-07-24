#!/usr/bin/env bash

source ./src/lib/arch-base-script.sh
source ./src/lib/base-script.sh

function mainMenu() {
  scriptLogo
  PS3="Select an option: "
  select option in "Go Back" "[REBOOT] Install Package Managers (Yay, Snap)" "[WSL] ArchWSL setup Root and User" "[WSL] ArchWSL Post Configurations (Workflow)"; do
    echo "You chose to $option"
    case $option in
    "Go Back")
      clear
      echo "Exiting..." && echo
      bash ./LinuxScript.sh
      break
      ;;
    "[REBOOT] Install Package Managers (Yay, Snap)")
      clear
      installPackageManagers

      waitPrompt
      mainMenu
      ;;

    "[WSL] ArchWSL setup Root and User")
      clear
      archWslSetupAccounts

      waitPrompt
      mainMenu
      ;;
    "[WSL] ArchWSL Post Configurations (Workflow)")
      clear
      preArchSetup
      installPackagesArchWsl
      installProgrammingLanguagesWithVersionManagers
      installPackageManagers
      installFonts
      installZsh
      installOhMyZsh

      waitPrompt
      mainMenu
      ;;
    *)
      clear
      echoError "ERROR: Invalid Option"
      mainMenu
      break
      ;;
    esac
    break
  done
}

function archWslSetupAccounts() {
  _currentUser=$(id -u)
  if [[ "$_currentUser" -ne 0 ]]; then
    echoError "Please run as root user!"
    exit 1
  fi

  echoSection 'New ROOT Password'
  passwd 'root'
  echo "%wheel ALL=(ALL) ALL" >/etc/sudoers.d/wheel

  echoSection 'New USER account'

  read -r -p "Input your user name: " _userName
  useradd -m -G wheel -s /bin/bash "$_userName"
  echo "Now set a password for $_userName..."
  passwd "$_userName"

  echoError "!!! IMPORTANT (ArchWSL) !!!"
  echo "To set the new Default user to $_userName..."
  echo "Copy the follow command on the Powershell:" && echo
  echo "Arch.exe config --default-user $_userName" && echo
  echo "At the end close the terminal"
}

function installPackagesArchWsl() {
  # Required To compilation proccesses | The parameter to ignore fakeroot is avoid an install bug on WSL |
  local _archPacmanApps="base-devel gcc man-db man-pages"

  echoSection "Installing via Pacman"
  echo "$_archPacmanApps"
  install_package "$_archPacmanApps" "sudo pacman -S --needed --noconfirm --ignore=fakeroot"
}

function main() {
  configEnv
  preArchSetup
  mainMenu
}

main
