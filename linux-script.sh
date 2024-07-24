#!/usr/bin/env bash

source ./src/lib/base-script.sh

function initial_main_menu() {
  script_logo
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
      echo_caption "Arch"
      ./"src/scripts/arch-script.sh"
      ;;
    "[MENU] Arch (WSL)")
      clear
      echo_caption "Arch"
      ./"src/scripts/wsl-arch-script.sh"
      ;;
    "Fedora (Desktop)")
      clear
      echo_caption "Fedora"
      ./"src/scripts/fedora-script.sh"
      ;;
    "Ubuntu (Desktop)")
      clear
      echo_caption "Ubuntu"
      ./"src/scripts/ubuntu-script.sh"
      ;;
    "Ubuntu (WSL)")
      clear
      echo_caption "Ubuntu"
      ./"src/scripts/wsl-ubuntu-script.sh"
      ;;
    "Utilities Scripts")
      clear
      echo_caption "Utilities"
      utilities_menu
      ;;
    *)
      clear
      echo_error "ERROR: Invalid Option"
      initial_main_menu
      break
      ;;
    esac
    break
  done
}

function utilities_menu() {
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
      echo_caption "Git, GPG and SSH setup (UTILS)"
      ./src/utils/git-gpg-ssh-setup.sh
      ;;
    "Install ZSH + Oh My ZSH")
      clear
      echo_caption "Setting Up ZSH + Oh My ZSH"
      install_zsh
      install_oh_my_zsh
      ;;
    *)
      clear
      echo_error "ERROR: Invalid Option"
      utilities_menu
      ;;
    esac
    break
  done
}

function main() {
  clear
  initial_main_menu
  echo "EXIT CODE: $?"
}

main
