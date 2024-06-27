#!/usr/bin/env bash

source ./src/lib/base-script.sh

function initialMainMenu() {
  scriptLogo
  PS3="Select an option to see the scripts: "
  select option in "Exit" "[MENU] Arch (Desktop)" "[MENU] Arch (WSL)" "Fedora (Desktop)" "Ubuntu (Desktop)" "Ubuntu (WSL)" "Utilities Scripts"; do
    echo "You choose $option"
    case $option in
    "Exit")
      clear
      echo "Exiting..." && echo
      break
      ;;
    "[MENU] Arch (Desktop)")
      clear
      echoCaption "Arch"
      ./"src/scripts/arch-script.sh"
      ;;
    "[MENU] Arch (WSL)")
      clear
      echoCaption "Arch"
      ./"src/scripts/wsl-arch-script.sh"
      ;;
    "Fedora (Desktop)")
      clear
      echoCaption "Fedora"
      ./"src/scripts/fedora-script.sh"
      ;;
    "Ubuntu (Desktop)")
      clear
      echoCaption "Ubuntu"
      ./"src/scripts/ubuntu-script.sh"
      ;;
    "Ubuntu (WSL)")
      clear
      echoCaption "Ubuntu"
      ./"src/scripts/wsl-ubuntu-script.sh"
      ;;
    "Utilities Scripts")
      clear
      echoCaption "Utilities"
      utilitiesMenu
      ;;
    *)
      clear
      echoError "ERROR: Invalid Option"
      initialMainMenu
      break
      ;;
    esac
    break
  done
}

function utilitiesMenu() {
  PS3="Select the script: "
  select script in "Go Back" "Setup GPG and SSH for GitHub" "Install ZSH + Oh My ZSH"; do
    echo "You chose the $script"
    case $script in
    "Go Back")
      clear
      main
      ;;
    "Setup GPG and SSH for GitHub")
      clear
      echoCaption "Git, GPG and SSH setup (UTILS)"
      ./src/utils/git-gpg-ssh-setup.sh
      ;;
    "Install ZSH + Oh My ZSH")
      clear
      echoCaption "Setting Up ZSH + Oh My ZSH"
      installZsh
      installOhMyZsh
      ;;
    *)
      clear
      echoError "ERROR: Invalid Option"
      utilitiesMenu
      ;;
    esac
    break
  done
}

function main() {
  clear
  initialMainMenu
  echo "EXIT CODE: $?"
}

main
