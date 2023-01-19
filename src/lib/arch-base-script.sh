#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/title-templates.sh

function installPackage() {
  local _apps=("$1")
  if [[ $# -eq 1 ]]; then
    local _installBlock="sudo pacman -S --needed --noconfirm"
  else
    local _installBlock="$2"
  fi

  echoCaption "COMMAND TO EXECUTE: $_installBlock ${_apps[@]}"
  # Iterate the string array using for loop
  for _app in ${_apps[@]}; do
    echoSection "(${#_apps[@]}) - $_app"
    eval $_installBlock $_app
  done
}

function installPackageManagers() {
  echoTitle "Installing Package Managers (Yay, Snap)"

  echoCaption "Enabling Yay"
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  pushd /tmp/yay/
  makepkg --syncdeps --install --clean --noconfirm # Like dpkg
  popd                                             # ~/.config/ledragox-linux-script

  configEnv
  echoCaption "Enabling Snap repository"
  git clone https://aur.archlinux.org/snapd.git ~/$_configFolder/snapd
  pushd ~/$_configFolder/snapd
  makepkg --syncdeps --install --clean --noconfirm
  popd
  sudo systemctl enable --now snapd.socket # Enable Snap Socket
  sudo ln -s /var/lib/snapd/snap /snap     # Link Snap directory to /snap
  echo "Snap will work only after loggin' out and in"

  echoError "To finish the installation, this PC will reboot after confirmation!!!"
  waitPrompt
  reboot
}

function preArchSetup() {
  echoTitle "Pre Arch Setup"
  sudo pacman-key --init
  sudo pacman-key --populate
  sudo pacman -Syy --needed --noconfirm archlinux-keyring

  echoSection "Add Multilib repository to Arch"
  # Code from: https://stackoverflow.com/a/34516165
  sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

  echoSection "Enabling Parallel Downloads"
  sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

  echoSection "Updating Repositories (Core, Extra, Community and Multilib)"
  sudo pacman -Sy --noconfirm

  echoCaption "Installing required packages for every script"
  # 2 Terminal Download Manager | 1 Git (If doesn't have) | 2 Compress/Extract zip files | 1 Tool to change Shell | 1 Z-Shell (ZSH)
  installPackage "curl wget git unzip zip which zsh"
}
