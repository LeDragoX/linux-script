#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/ubuntu-base-script.sh

function install_packages_ubuntu_wsl() {
  echo_title "Install Apt Packages"

  sudo dpkg --add-architecture i386                                           # Enable 32-bits Architecture
  sudo DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-restricted-extras # Remove interactivity | Useful proprietary stuff

  declare -a ubuntu_apps=(
    # Initial Libs that i use
    "build-essential" # | Building and Compiling requirement
    "gdebi"           # | CLI/GUI .deb Installer
    "gdebi-core"      # | CLI/GUI .deb Installer
    "htop"            # | Terminal System Monitor
    "nano"            # | Terminal Text Editor
    "neofetch"        # | Neofetch Command
    "vim"             # | Terminal Text Editor
  )

  echo_section "Installing via Advanced Package Tool (apt)..."

  for app in "${ubuntu_apps[@]}"; do
    echo_caption "Installing: $app "
    sudo apt install -y "$app"
  done

}

function main() {
  config_environment
  script_logo
  pre_ubuntu_setup
  install_packages_ubuntu_wsl
  install_version_managers
  install_fonts
  install_zsh
  install_oh_my_zsh
  upgrade_all_ubuntu
}

main
