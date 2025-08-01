#!/bin/bash

source ./src/lib/base-script.sh
source ./src/lib/install-package.sh
source ./src/lib/title-templates.sh

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
  sudo ln -s /var/lib/snapd/snap /snap     # Link Snap directory to /snap (enables classic support)
  echo "Snap will work only after loggin' out and in"

  echo_caption "Enabling Flatpak"
  install_package_arch "flatpak"

  echo_error "To finish the installation, this PC will reboot after confirming!!!"
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
  install_package_arch "archlinux-keyring" "sudo pacman -Syy --needed --noconfirm"

  echo_caption "Installing required packages for every script"
  # 2 Terminal Download Manager | 1 Git (If doesn't have) | 2 Compress/Extract zip files | 1 Tool to change Shell | 1 Z-Shell (ZSH)
  install_package_arch "curl wget git unzip zip which zsh"

  fix_time_zone
}

# TODO: Fix Secure Boot with: bootctl and sbctl
# Credits: https://youtu.be/yU-SE7QX6WQ Walian - Install Secure Boot on Arch Linux (the easy way)
# Tested On EndeavourOS
#
### GO TO YOUR BIOS AND RESET THE SECURE BOOT KEYS BEFORE
# 1   sudo pacman -S sbctl
# 2   sbctl status
# 3   sudo sbctl create-keys
# 4   sudo sbctl enroll-keys -m

### FOR SYSTEMD
# 5   sudo sbctl sign -s -o /usr/lib/systemd/boot/efi/systemd-bootx64.efi.signed /usr/lib/systemd/boot/efi/systemd-bootx64.efi
# 6   sudo sbctl sign -s /efi/EFI/systemd/systemd-bootx64.efi
### FOR GRUB
# 5   sudo sbctl sign -s -o /boot/efi/EFI/grub/bootx64.efi
# 6   sudo sbctl sign -s -o /boot/efi/EFI/endeavouros/bootx64.efi

# 7   sudo sbctl sign -s /efi/e99748dcb93c434b9aa3d85c13752e24/6.15.8-arch1-2/linux # Specific kernel version, the next ones will automatically sign
# 8   sudo bootctl install
# 9   sudo sbctl verify
### ENABLE SECURE BOOT AGAIN
# 10  reboot
# 11  sbctl status
# 12  bootctl status
