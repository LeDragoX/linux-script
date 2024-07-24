#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/title-templates.sh

function install_package() {
  local apps=("$1")
  if [[ $# -eq 1 ]]; then
    local install_block="sudo pacman -S --needed --noconfirm"
  else
    local install_block="$2"
  fi

  echo_caption "Runnning: $install_block"
  echo_caption "For each package: ${apps[*]}"

  # Using IFS (Internal Field Separator) to manage arrays
  local counter=0
  while IFS=" " read -ra array; do
    for app in "${array[@]}"; do
      echo_section "($((counter += 1))/${#array[@]}) - ${app}"
      eval "$install_block" "${app}"
    done
  done <<<"${apps[@]}"
}

function install_package_managers() {
  echo_title "Installing Package Managers (Yay, Snap)"

  echo_caption "Enabling Yay"
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  pushd /tmp/yay/ || exit
  makepkg --syncdeps --install --clean --noconfirm # Like dpkg
  popd || exit                                     # ~/.config/ledragox-linux-script

  config_environment
  echo_caption "Enabling Snap repository"
  git clone https://aur.archlinux.org/snapd.git ~/"$CONFIG_FOLDER"/snapd
  pushd ~/"$CONFIG_FOLDER"/snapd || exit
  makepkg --syncdeps --install --clean --noconfirm
  popd || exit
  sudo systemctl enable --now snapd.socket # Enable Snap Socket
  sudo ln -s /var/lib/snapd/snap /snap     # Link Snap directory to /snap
  echo "Snap will work only after loggin' out and in"

  echo_caption "Enabling Flatpak"
  install_package "flatpak"

  echo_error "To finish the installation, this PC will reboot after confirmation!!!"
  wait_prompt
  reboot
}

function pre_arch_setup() {
  echo_title "Pre Arch Setup"

  echo_section "Add Multilib repository to Arch"
  # Code from: https://stackoverflow.com/a/34516165
  sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

  echo_section "Enabling Parallel Downloads"
  sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

  echo_section "Initializing and Updating Repositories (Core, Extra, Community and Multilib)"
  sudo pacman-key --init
  sudo pacman-key --populate
  install_package "archlinux-keyring" "sudo pacman -Syy --needed --noconfirm"

  echo_caption "Installing required packages for every script"
  # 2 Terminal Download Manager | 1 Git (If doesn't have) | 2 Compress/Extract zip files | 1 Tool to change Shell | 1 Z-Shell (ZSH)
  install_package "curl wget git unzip zip which zsh"

  fix_time_zone
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
