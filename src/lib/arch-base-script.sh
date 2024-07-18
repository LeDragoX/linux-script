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

  echoCaption "Runnning: $_installBlock"
  echoCaption "For each package: ${_apps[*]}"

  # Using IFS (Internal Field Separator) to manage arrays
  local _counter=0
  while IFS=" " read -ra _array; do
    for _app in "${_array[@]}"; do
      echoSection "($((_counter += 1))/${#_array[@]}) - ${_app}"
      eval "$_installBlock" "${_app}"
    done
  done <<<"${_apps[@]}"
}

function installPackageManagers() {
  echoTitle "Installing Package Managers (Yay, Snap)"

  echoCaption "Enabling Yay"
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  pushd /tmp/yay/ || exit
  makepkg --syncdeps --install --clean --noconfirm # Like dpkg
  popd || exit                                     # ~/.config/ledragox-linux-script

  configEnv
  echoCaption "Enabling Snap repository"
  git clone https://aur.archlinux.org/snapd.git ~/"$_configFolder"/snapd
  pushd ~/"$_configFolder"/snapd || exit
  makepkg --syncdeps --install --clean --noconfirm
  popd || exit
  sudo systemctl enable --now snapd.socket # Enable Snap Socket
  sudo ln -s /var/lib/snapd/snap /snap     # Link Snap directory to /snap
  echo "Snap will work only after loggin' out and in"

  echoCaption "Enabling Flatpak"
  installPackage "flatpak"

  echoError "To finish the installation, this PC will reboot after confirmation!!!"
  waitPrompt
  reboot
}

function preArchSetup() {
  echoTitle "Pre Arch Setup"

  echoSection "Add Multilib repository to Arch"
  # Code from: https://stackoverflow.com/a/34516165
  sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

  echoSection "Enabling Parallel Downloads"
  sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

  echoSection "Initializing and Updating Repositories (Core, Extra, Community and Multilib)"
  sudo pacman-key --init
  sudo pacman-key --populate
  installPackage "archlinux-keyring" "sudo pacman -Syy --needed --noconfirm"

  echoCaption "Installing required packages for every script"
  # 2 Terminal Download Manager | 1 Git (If doesn't have) | 2 Compress/Extract zip files | 1 Tool to change Shell | 1 Z-Shell (ZSH)
  installPackage "curl wget git unzip zip which zsh"

  fixTimeZone
}

# TODO: Fix Secure Boot with: bootctl and sbctl
# Credits: https://youtu.be/yU-SE7QX6WQ Walian - Install Secure Boot on Arch Linux (the easy way)
# Tested On EndeavourOS
#
# 1   sbctl status
# 2   sbctl create-keys
# 3   sbctl enroll-keys -m
# 4   sbctl -s
# 5   sbctl -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
# 6   sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
# 7   sbctl -s /efi/EFI/systemd/systemd-bootx64.efi
# 8   sbctl sign -s /efi/EFI/systemd/systemd-bootx64.efi
# 9   bootctl install
# 13  sbctl sign -s /efi/1f0883d502ec49c5a55e9acdd375bc4a/6.9.6-arch1-1/linux # GENERATED KERNEL DIR
# 14  sbctl verify
# 15  reboot
# 16  sbctl status
# 17  bootctl status
