#!/bin/bash

clear
# To allow comments using # on Zsh terminal
setopt interactivecomments  # Temporary Workaround

# https://linuxhint.com/bash_loop_list_strings/
# Declare an array of string with type

# 1 - Pacman
declare -a PacmanApps=(
    "base-devel"        # yay Dependency
    "discord"           # Discord
    "flatpak"           # Flatpak Package Manager
    "git"               # Git
    "gimp"              # Gimp
    "gparted"           # Gparted
    "grub-customizer"   # GRUB utils (Conflict ERROR)
    "lutris"            # Lutris
    "qbittorrent"       # qBittorrent
    "smplayer"          # SMPlayer
    "snapd"             # Snap
    "vlc"               # VLC
    "yay"               # Yay AUR Package Manager
)

printf "\nInstalling via Pacman...\n"
# Iterate the string array using for loop
for App in ${PacmanApps[@]}; do
    printf "\nInstalling: $App \n"
    sudo pacman -Sy --noconfirm $App
done

# 2 - Snap
declare -a SnapApps=(
    "--classic code"            # VS Code (or code-insiders)
    "gnome-terminator --beta"   # Terminator
)

printf "\nInstalling via Snap...\n"
for App in ${SnapApps[@]}; do
    printf "\nInstalling: $App \n"
    sudo snap install $App
    # To Remove all Snap Packages
    #sudo snap remove $App
done


# 3 - Yay
declare -a AUR-Apps=(
    "google-chrome"         # Google Chrome
    "microsoft-edge-dev"    # Microsoft Edge
)

printf "\nInstalling via Yay...\n"
for App in ${AUR-Apps[@]}; do
    printf "\nInstalling: $App \n"
    yay -Sy --noconfirm $App
done

# 4 - Flatpak

printf "\nEnabling Flatpak repository..."
flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
declare -a FlatpakApps=(
    "com.valvesoftware.Steam"     # Steam
)

printf "\nInstalling via Flatpak...\n"
for App in ${FlatpakApps[@]}; do
    printf "\nInstalling: $App \n"
    flatpak --noninteractive --user install flathub $App
done

# Steam Fixes

sudo flatpak override com.valvesoftware.Steam --filesystem=$HOME    # Freeze Warning
#flatpak run --filesystem=~/.local/share/fonts --filesystem=~/.config/fontconfig  com.valvesoftware.Steam    # Run with Workaround