#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/ubuntu-base-script.sh

function installPackagesUbuntuWsl() {
  echoTitle "Install Apt Packages"

  sudo dpkg --add-architecture i386                                           # Enable 32-bits Architecture
  sudo DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-restricted-extras # Remove interactivity | Useful proprietary stuff

  declare -a apt_pkgs=(
    # Initial Libs that i use
    "gdebi"      # CLI/GUI .deb Installer
    "gdebi-core" # CLI/GUI .deb Installer
    "htop"       # Terminal System Monitor
    "nano"       # Terminal Text Editor
    "neofetch"   # Neofetch Command
    "vim"        # Terminal Text Editor
  )

  echoSection "Installing via Advanced Package Tool (apt)..."

  for App in ${apt_pkgs[@]}; do
    echoCaption "Installing: $App "
    sudo apt install -y $App
  done

}

function main() {
  configEnv
  scriptLogo
  preUbuntuSetup
  installPackagesUbuntuWsl
  upgradeAllUbuntu
  installFonts
  installZsh
  installOhMyZsh
}

main
