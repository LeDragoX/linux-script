#!/bin/bash

source ./src/lib/base-script.sh

function installPackagesArch() {

  # https://linuxhint.com/bash_loop_list_strings/
  # Declare an array of string with type

  # 1 - Pacman
  declare -a pacman_apps=(
    "adb"             # Android Debugging
    "base-devel"      # yay Dependency
    "discord"         # Discord
    "flatpak"         # Flatpak Package Manager
    "gimp"            # Gimp
    "git"             # Git
    "gparted"         # Gparted
    "grub-customizer" # GRUB utils (Conflict ERROR)
    "htop"            # Terminal System Monitor
    "jdk-openjdk"     # Latest Java Dev Kit (OpenJDK)
    "jre-openjdk"     # Latest Java Runtime Environment (OpenJDK)
    "lutris"          # Lutris
    "neofetch"        # Neofetch command
    "obs-studio"      # OBS Studio
    "pavucontrol"     # Audio Controller
    "qbittorrent"     # qBittorrent
    "smplayer"        # SMPlayer
    "snapd"           # Snap
    "vlc"             # VLC
    "yay"             # Yay AUR Package Manager
  )

  echo "Installing via Pacman..."
  # Iterate the string array using for loop
  for App in ${pacman_apps[@]}; do
    echo "Installing: $App "
    sudo pacman -Sy --noconfirm $App
  done

  # 2 - Snap

  echo "Enabling Snap repository..."
  sudo systemctl enable --now snapd.socket
  declare -a snap_apps=(
    "--classic code"            # VS Code (or code-insiders)
    "gnome-terminator --beta"   # Terminator
    "onlyoffice-desktopeditors" # ONLY Office
    "spotify"                   # Spotify Music
  )

  echo "Installing via Snap..."
  for App in ${snap_apps[@]}; do
    echo "Installing: $App "
    sudo snap install $App
    # To Remove all Snap Packages
    #sudo snap remove $App
  done

  # 3 - Yay

  declare -a aur_apps=(
    "google-chrome"      # Google Chrome
    "microsoft-edge-dev" # Microsoft Edge
  )

  echo "Installing via Yay..."
  for App in ${aur_apps[@]}; do
    echo "Installing: $App "
    yay -Sy --noconfirm $App
  done

  # 4 - Flatpak

  echo "Enabling Flatpak repository..."
  flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  declare -a flatpak_apps=(
    "com.valvesoftware.Steam" # Steam
  )

  echo "Installing via Flatpak..."
  for App in ${flatpak_apps[@]}; do
    echo "Installing: $App "
    flatpak --noninteractive --user install flathub $App
  done

}

function main() {

  initVariables
  configEnv

  installPackagesArch
  configGit

  # Steam Fixes
  sudo flatpak override com.valvesoftware.Steam --filesystem=$HOME # Freeze Warning (But it comes back after a while)
  # Run with Workaround
  #flatpak run --filesystem=~/.local/share/fonts --filesystem=~/.config/fontconfig  com.valvesoftware.Steam

}

main
