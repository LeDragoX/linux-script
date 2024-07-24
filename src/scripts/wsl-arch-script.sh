#!/usr/bin/env bash

source ./src/lib/arch-base-script.sh
source ./src/lib/base-script.sh

function main_menu() {
  script_logo
  PS3="Select an option: "
  select option in "Go Back" "[REBOOT] Install Package Managers (Yay, Snap)" "[WSL] ArchWSL setup Root and User" "[WSL] ArchWSL Post Configurations (Workflow)"; do
    echo "You chose to $option"
    case $option in
    "Go Back")
      clear
      echo "Exiting..." && echo
      bash ./linux-script.sh
      break
      ;;
    "[REBOOT] Install Package Managers (Yay, Snap)")
      clear
      install_package_managers

      wait_prompt
      main_menu
      ;;

    "[WSL] ArchWSL setup Root and User")
      clear
      arch_wsl_setup_accounts

      wait_prompt
      main_menu
      ;;
    "[WSL] ArchWSL Post Configurations (Workflow)")
      clear
      pre_arch_setup
      install_packages_arch_wsl
      install_version_managers
      install_package_managers
      install_fonts
      install_zsh
      install_oh_my_zsh

      wait_prompt
      main_menu
      ;;
    *)
      clear
      echo_error "ERROR: Invalid Option"
      main_menu
      break
      ;;
    esac
    break
  done
}

function arch_wsl_setup_accounts() {
  CURRENT_USER=$(id -u)
  readonly CURRENT_USER

  if [[ "$CURRENT_USER" -ne 0 ]]; then
    echo_error "Please run as root user!"
    exit 1
  fi

  echo_section 'New ROOT Password'
  passwd 'root'
  echo "%wheel ALL=(ALL) ALL" >/etc/sudoers.d/wheel

  echo_section 'New USER account'

  read -r -p "Input your user name: " user_name
  useradd -m -G wheel -s /bin/bash "$user_name"
  echo "Now set a password for $user_name..."
  passwd "$user_name"

  echo_error "!!! IMPORTANT (ArchWSL) !!!"
  echo "To set the new Default user to $user_name..."
  echo "Copy the follow command on the Powershell:" && echo
  echo "Arch.exe config --default-user $user_name" && echo
  echo "At the end close the terminal"
}

function install_packages_arch_wsl() {
  # Required To compilation proccesses | The parameter to ignore fakeroot is avoid an install bug on WSL |
  local arch_pacman_apps="base-devel gcc man-db man-pages"

  echo_section "Installing via Pacman"
  echo "$arch_pacman_apps"
  install_package "$arch_pacman_apps" "sudo pacman -S --needed --noconfirm --ignore=fakeroot"
}

function main() {
  config_environment
  pre_arch_setup
  main_menu
}

main
