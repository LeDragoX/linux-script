#!/bin/bash

source ./src/lib/base-script.sh

function installPackagesArch() {

  title1 "Add Multilib repository to Arch"
  # Code from: https://stackoverflow.com/a/34516165
  sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

  title1 "Updating Repositories (Core, Extra, Community and Multilib)"
  sudo pacman -Sy --noconfirm
  echo

  PS3="Select the Desktop Environment (1 to skip): "
  select DesktopEnv in None KDE-Plasma-Minimal Gnome-Minimal XFCE-Minimal; do
    echo "You chose the $DesktopEnv"
    case $DesktopEnv in
    None)
      caption1 "Skipping..."
      ;;
    KDE-Plasma-Minimal)
      section1 "Installing $DesktopEnv"
      # SDDM Login Manager | Pure KDE Plasma | Wayland Session for KDE | XOrg & XOrg Server | KDE file manager | KDE screenshot tool
      sudo pacman -S --needed --noconfirm sddm plasma plasma-wayland-session xorg dolphin spectacle
      caption1 "Removing $DesktopEnv bloat (For me)"
      sudo pacman -Rns --noconfirm konsole

      disableLoginManagers

      caption1 "Setting sudo systemctl enable sddm"
      sudo systemctl enable sddm
      ;;
    Gnome-Minimal)
      section1 "Installing $DesktopEnv"
      # GDM Login Manager | Pure Gnome | XOrg & XOrg Server
      sudo pacman -S --needed --noconfirm gdm gnome xorg
      caption1 "Removing $DesktopEnv bloat (For me)"
      sudo pacman -Rns --noconfirm gnome-terminal

      disableLoginManagers

      echo "Setting sudo systemctl enable gdm"
      sudo systemctl enable gdm
      ;;
    XFCE-Minimal)
      section1 "Installing $DesktopEnv"
      # LightDM Login Manager | Login Screen Greeter (LightDM) | Pure XFCE | XOrg & XOrg Server
      sudo pacman -S --needed --noconfirm lightdm lightdm-gtk-greeter xfce4 xorg
      # Plugins: Create/Extract files inside Thunar | Battery Monitor to panel | DateTime to panel | Mount/Unmount devices to panel | Control media player to panel | Notifications to panel | PulseAudio to panel | Screenshot tool | Task Manager | Command line to panel | Wi-fi monitor to panel | Menu to panel
      sudo pacman -S --needed --noconfirm thunar-archive-plugin xfce4-battery-plugin xfce4-datetime-plugin xfce4-mount-plugin xfce4-mpc-plugin xfce4-notifyd xfce4-pulseaudio-plugin xfce4-screenshooter xfce4-taskmanager xfce4-verve-plugin xfce4-wavelan-plugin xfce4-whiskermenu-plugin
      caption1 "Removing $DesktopEnv bloat (For me)"
      sudo pacman -Rns --noconfirm xfce4-terminal

      disableLoginManagers

      echo "Setting sudo systemctl enable lightdm"
      sudo systemctl enable lightdm
      ;;
    *)
      echo "ERROR: Invalid Option"
      ;;
    esac
    break
  done

  # https://linuxhint.com/bash_loop_list_strings/
  # Declare an array of string with type

  declare -a pacman_apps=(
    "adb"              # Android Debugging
    "base-devel"       # yay Dependency
    "discord"          # Discord
    "flatpak"          # Flatpak Package Manager
    "gimp"             # Gimp
    "git"              # Git
    "gnome-keyring"    # Fixes keyring bug on VSCode (https://github.com/microsoft/vscode/issues/92972#issuecomment-625751232)
    "gparted"          # Gparted
    "grub-customizer"  # GRUB utils (Conflict ERROR on Manjaro)
    "htop"             # Terminal System Monitor
    "nano"             # Console text editor
    "neofetch"         # Neofetch command
    "noto-fonts-emoji" # Emoji Support
    "ntfs-3g"          # NTFS support (Windows Dualboot)
    "numlockx"         # Turn Num Lock On, at least this time
    "obs-studio"       # OBS Studio
    "os-prober"        # Detect Windows install
    "pavucontrol"      # Audio Controller
    "python-pip"       # Python Module manager
    "qbittorrent"      # qBittorrent
    "smplayer"         # SMPlayer
    "snapd"            # Snap
    "terminator"       # Terminator
    "vim"              # Console text editor
    "vlc"              # VLC
    "yay"              # Yay AUR Package Manager
    "zsh"              # Z-Shell
  )

  section1 "Installing via Pacman"
  # Iterate the string array using for loop
  for App in ${pacman_apps[@]}; do
    section1 "Installing: $App"
    sudo pacman -S --needed --noconfirm $App
  done

  title1 "Enabling Snap repository"

  git clone https://aur.archlinux.org/snapd.git ~/$config_folder/snapd
  pushd snapd/
  makepkg -si --needed --noconfirm # Like dpkg
  popd

  sudo systemctl enable --now snapd.socket # Enable Snap Socket
  sudo ln -s /var/lib/snapd/snap /snap     # Link Snap directory to /snap
  echo "Snap will work only after loggin' out and in"

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

  title1 "Enabling Yay"
  pushd /opt/
  sudo git clone https://aur.archlinux.org/yay-git.git
  sudo chown -R $USER ./yay-git
  pushd yay-git/
  makepkg -si --needed --noconfirm
  popd
  # /opt/
  popd
  # ~/.config/ledragox-linux-script

  declare -a aur_apps=(
    #"google-chrome"      # Google Chrome (Will make itself default when installed)
    "microsoft-edge-dev" # Microsoft Edge
    "svp"                # SVP 4 Linux (AUR)
  )

  section1 "Installing via Yay (AUR)"
  for App in ${aur_apps[@]}; do
    caption1 "Installing: $App"
    yay -S --needed --noconfirm $App
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

function disableLoginManagers() {

  caption1 "Disabling all Login Managers before enabling another"

  sudo systemctl disable gdm
  sudo systemctl disable lightdm
  sudo systemctl disable sddm

}

function postConfigs() {

  caption1 "Detecting Windows installs"
  sudo os-prober
  caption1 "Activating Num Lock"
  numlockx
  caption1 "Enabling os-prober execution on grub-mkconfig"
  sudo sh -c "echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub"
  caption1 "Re-Configuring GRUB"
  sudo grub-mkconfig -o /boot/grub/grub.cfg
  caption1 "Reloading all fonts in cache"
  fc-cache -v -f
  caption1 "Steam Fixes"
  sudo flatpak override com.valvesoftware.Steam --filesystem=$HOME # Freeze Warning (But it comes back after a while)
  # Run with Workaround
  #flatpak run --filesystem=~/.local/share/fonts --filesystem=~/.config/fontconfig  com.valvesoftware.Steam

  if (lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i "NVIDIA"); then
    section1 "Installing NVIDIA drivers"
    # NVIDIA proprietary driver for linux-lts | NVIDIA utils for 32 bits | NVIDIA Settings | NVIDIA Cuda technology
    sudo pacman -S --needed --noconfirm nvidia-lts lib32-nvidia-utils nvidia-settings cuda

    caption1 "Making /etc/X11/xorg.conf"
    caption1 "DIY: Remember to comment lines like 'LOAD: \"dri\"'"
    sudo nvidia-xconfig
    caption1 "Loading nvidia settings from /etc/X11/xorg.conf"
    nvidia-settings --load-config-only

  else
    echo "Skipping..."
  fi

}

function main() {

  initVariables
  echo "Getting the fastest mirrors for package downloading"
  sudo pacman -Sy --needed --noconfirm wget zip unzip rsync reflector    # Needed to download/install fonts | needed to get the best mirrors from region
  sudo reflector -c 'Brazil' --sort rate --save /etc/pacman.d/mirrorlist # Instead of 'Brazil' put your country
  configEnv

  installPackagesArch
  postConfigs

  installZsh
  configGit

}

main