#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/fedora-base-script.sh

function main() {
  configEnv
  scriptLogo
  preFedoraSetup
  addFedoraRepos
  installPackagesFedora
  installProgrammingLanguagesWithVersionManagers
  installFonts
  installZsh
  installOhMyZsh
  upgradeAllFedora
}

function addFedoraRepos() {
  echoTitle "Adding Required Repos"

  sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
  echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null

  sudo dnf update
}

function installPackagesFedora() {
  local _fedoraDnfApps=(
    "code"        # | VS Code (64-Bits)
    "gimp"        # | Gimp
    "obs-studio"  # | OBS Studio
    "qbittorrent" # | qBittorrent
  )

  local _flatpakApps=(
    "dev.vencord.Vesktop" # | Vesktop (better Discord alternative for linux)
  )

  echoSection "Installing via dnf"
  echo "$_fedoraDnfApps"
  installPackage "${_fedoraDnfApps[*]}"

  echoSection "Installing via flatpak"
  echo "$_flatpakApps"
  installPackage "${_flatpakApps[*]}" "flatpak install flathub --system -y"
}

main
