#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/fedora-base-script.sh

function main() {
  config_environment
  script_logo
  pre_fedora_setup
  add_fedora_repositories
  install_packages_fedora
  install_version_managers
  install_fonts
  install_zsh
  install_oh_my_zsh
  upgrade_all_fedora
}

function add_fedora_repositories() {
  echo_title "Adding Required Repos"

  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null

  sudo dnf update
}

function install_packages_fedora() {
  local fedora_dnf_apps=(
    "code"        # | VS Code (64-Bits)
    "gimp"        # | Gimp
    "obs-studio"  # | OBS Studio
    "qbittorrent" # | qBittorrent
  )

  local flatpak_apps=(
    "dev.vencord.Vesktop"           # | Vesktop (better Discord alternative for linux)
    "org.onlyoffice.desktopeditors" # | ONLYOFFICE Desktop Editors
  )

  echo_section "Installing via dnf"
  echo "${fedora_dnf_apps[*]}"
  install_package "${fedora_dnf_apps[*]}"

  echo_section "Installing via flatpak"
  echo "${flatpak_apps[*]}"
  install_package "${flatpak_apps[*]}" "flatpak install flathub --system -y"
}

main
