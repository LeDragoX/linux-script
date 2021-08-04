#!/bin/bash

source ./src/lib/base-script.sh

function installPackagesArch() {

  title1 "Updating Repositories (Core, Extra, Community, Multilib)"
  sudo pacman -Sy --noconfirm

  # https://linuxhint.com/bash_loop_list_strings/
  # Declare an array of string with type

  declare -a pacman_apps=(
    "adb"             # Android Debugging
    "base-devel"      # yay Dependency
    "discord"         # Discord
    "flatpak"         # Flatpak Package Manager
    "gimp"            # Gimp
    "git"             # Git
    "gparted"         # Gparted
    "grub-customizer" # GRUB utils (Conflict ERROR on Manjaro)
    "htop"            # Terminal System Monitor
    "jdk-openjdk"     # Latest Java Dev Kit (OpenJDK)
    "jre-openjdk"     # Latest Java Runtime Environment (OpenJDK)
    "neofetch"        # Neofetch command
    "obs-studio"      # OBS Studio
    "pavucontrol"     # Audio Controller
    "qbittorrent"     # qBittorrent
    "smplayer"        # SMPlayer
    "snapd"           # Snap
    "terminator"      # Terminator
    "vlc"             # VLC
    "yay"             # Yay AUR Package Manager
  )

  section1 "Installing via Pacman"
  # Iterate the string array using for loop
  for App in ${pacman_apps[@]}; do
    section1 "Installing: $App"
    sudo pacman -S --noconfirm $App
  done

  title1 "Enabling Snap repository"
  sudo systemctl enable --now snapd.socket # Enable Snap Socket
  sudo ln -s /var/lib/snapd/snap /snap     # Link Snap directory to /snap

  declare -a snap_apps=(
    "onlyoffice-desktopeditors" # ONLY Office
    "spotify"                   # Spotify Music
  )

  section1 "Installing via Snap"
  for App in ${snap_apps[@]}; do
    caption1 "Installing: $App"
    sudo snap install $App
  done

  section1 "Manual installations"

  sudo snap install code --classic # VS Code (or code-insiders)

  declare -a aur_apps=(
    "google-chrome"      # Google Chrome
    "microsoft-edge-dev" # Microsoft Edge
  )

  section1 "Installing via Yay"
  for App in ${aur_apps[@]}; do
    caption1 "Installing: $App"
    yay -S --noconfirm $App
  done

  title1 "Enabling Flatpak repository"
  flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
  declare -a flatpak_apps=(
    "com.valvesoftware.Steam" # Steam
  )

  section1 "Installing via Flatpak"
  for App in ${flatpak_apps[@]}; do
    caption1 "Installing: $App"
    flatpak --noninteractive --user install flathub $App
  done

}

function main() {

  initVariables
  configEnv

  installPackagesArch
  installZsh
  configGit

  # Steam Fixes
  sudo flatpak override com.valvesoftware.Steam --filesystem=$HOME # Freeze Warning (But it comes back after a while)
  # Run with Workaround
  #flatpak run --filesystem=~/.local/share/fonts --filesystem=~/.config/fontconfig  com.valvesoftware.Steam

}

main
