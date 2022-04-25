#!/usr/bin/env bash

source ./src/lib/base-script.sh

function echoArchScriptLogo() {
  echo '<===================================================================================>'
  echo '       d8888                 888       .d8888b.                   d8b          888   '
  echo '      d88888                 888      d88P  Y88b                  Y8P          888   '
  echo '     d88P888                 888      Y88b.                                    888   '
  echo '    d88P 888 888d888 .d8888b 88888b.   "Y888b.    .d8888b 888d888 888 88888b.  888888'
  echo '   d88P  888 888P"  d88P"    888 "88b     "Y88b. d88P"    888P"   888 888 "88b 888   '
  echo '  d88P   888 888    888      888  888       "888 888      888     888 888  888 888   '
  echo ' d8888888888 888    Y88b.    888  888 Y88b  d88P Y88b.    888     888 888 d88P Y88b. '
  echo 'd88P     888 888     "Y8888P 888  888  "Y8888P"   "Y8888P 888     888 88888P"   "Y888'
  echo '                                                                      888            '
  echo '                                                                      888            '
  echo '                                                                      888            '
  echo '<===================================================================================>'
}

function echoWSLArchScriptLogo() {
  echo '<=====================================================================================>'
  echo '                        888       888  .d8888b.  888       .d8888b.                    '
  echo '                        888   o   888 d88P  Y88b 888      d88P  Y88b                   '
  echo '                        888  d8b  888 Y88b.      888             888                   '
  echo '                        888 d888b 888  "Y888b.   888           .d88P                   '
  echo '                        888d88888b888     "Y88b. 888       .od888P"                    '
  echo '                        88888P Y88888       "888 888      d88P"                        '
  echo '                        8888P   Y8888 Y88b  d88P 888      888"                         '
  echo '                        888P     Y888  "Y8888P"  88888888 888888888                    '
  echo '                                                                                       '
  echo '       d8888                  888       .d8888b.                   d8b          888    '
  echo '      d88888                  888      d88P  Y88b                  Y8P          888    '
  echo '     d88P888                  888      Y88b.                                    888    '
  echo '    d88P 888 888d888  .d8888b 88888b.   "Y888b.    .d8888b 888d888 888 88888b.  888888 '
  echo '   d88P  888 888P"   d88P"    888 "88b     "Y88b. d88P"    888P"   888 888 "88b 888    '
  echo '  d88P   888 888     888      888  888       "888 888      888     888 888  888 888    '
  echo ' d8888888888 888     Y88b.    888  888 Y88b  d88P Y88b.    888     888 888 d88P Y88b.  '
  echo 'd88P     888 888      "Y8888P 888  888  "Y8888P"   "Y8888P 888     888 88888P"   "Y888 '
  echo '                                                                       888             '
  echo '                                                                       888             '
  echo '                                                                       888             '
  echo "<=====================================================================================>"
}

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
    echoSection "( ${#_apps[@]} ) - { $_app }"
    eval $_installBlock $_app
  done
}

function preArchSetup() {
  echoTitle "Finishing Arch Setup"
  sudo pacman-key --init
  sudo pacman-key --populate
  sudo pacman -Syy --noconfirm archlinux-keyring

  echoSection "Add Multilib repository to Arch"
  # Code from: https://stackoverflow.com/a/34516165
  sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

  echoSection "Enabling Parallel Downloads"
  sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

  echoSection "Updating Repositories and Packages (Core, Extra, Community and Multilib)"
  sudo pacman -Syu --noconfirm

  echo "- Installing required packages for every script"
  installPackage "curl git unzip wget zip which zsh" # 1 Installing Git (If doesn't have) | 3 Needed to download/install files and unzip it | 1 Tool to change Shell | 1 Z-Shell (ZSH)
}

function enablePackageManagers() {
  echoTitle "Enabling Package Managers"

  echoCaption "Enabling Yay"
  pushd /tmp
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  pushd yay/
  makepkg -si --noconfirm
  popd # /tmp
  popd # ~/.config/ledragox-linux-script

  configEnv
  echoCaption "Enabling Snap repository"
  git clone https://aur.archlinux.org/snapd.git ~/$configFolder/snapd
  pushd ~/$configFolder/snapd
  makepkg -si --noconfirm # Like dpkg
  popd
  sudo systemctl enable --now snapd.socket # Enable Snap Socket
  sudo ln -s /var/lib/snapd/snap /snap     # Link Snap directory to /snap
  echo "Snap will work only after loggin' out and in"

  installPackage "flatpak"
  echoCaption "Enabling Flatpak repository"
  flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}
