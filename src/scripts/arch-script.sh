#!/bin/bash

source ./src/lib/base-script.sh

function installPackagesArch() {

  echoTitle "Add Multilib repository to Arch"
  # Code from: https://stackoverflow.com/a/34516165
  sudo sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

  echoTitle "Updating Repositories (Core, Extra, Community and Multilib)"
  sudo pacman -Sy --noconfirm
  echo

  installDE # Let you choose if you want to install a DE or NOT

  # https://linuxhint.com/bash_loop_list_strings/
  # Declare an array of string with type

  pacman_apps=(
    "amd-ucode"            # AMD CPU Microcode
    "base-devel"           # yay Dependency
    "discord-canary"       # Discord Canary
    "flatpak"              # Flatpak Package Manager
    "gimp"                 # Gimp
    "git"                  # Git
    "gnome-keyring"        # Fixes keyring bug on VSCode (https://github.com/microsoft/vscode/issues/92972#issuecomment-625751232)
    "gparted"              # Gparted
    "grub-customizer"      # GRUB utils (Conflict ERROR on Manjaro)
    "lib32-libpulse"       # Sound for Wine
    "libmediainfo"         # SVP Dependency
    "lsof"                 # SVP Dependency
    "htop"                 # Terminal System Monitor
    "nano"                 # Console text editor
    "neofetch"             # Neofetch command
    "noto-fonts-emoji"     # Emoji Support
    "ntfs-3g"              # NTFS support (Windows Dualboot)
    "numlockx"             # Turn Num Lock On, at least this time
    "obs-studio"           # OBS Studio
    "os-prober"            # Detect Windows install
    "pavucontrol"          # Audio Controller
    "python-pip"           # Python Module manager
    "qbittorrent"          # qBittorrent
    "qt5-base"             # SVP Dependency
    "qt5-declarative"      # SVP Dependency
    "qt5-svg"              # SVP Dependency
    "scrcpy"               # Android ScrCpy
    "smplayer"             # SMPlayer
    "steam"                # Steam
    "steam-native-runtime" # Fix Steam GUI
    "terminator"           # Terminator
    "vapoursynth"          # SVP Dependency
    "vim"                  # Console text editor
    "vlc"                  # VLC
    "zsh"                  # Z-Shell
  )

  echoSection "Installing via Pacman"
  installPackage "$pacman_apps"

  echoTitle "Enabling Yay"
  pushd /opt/
  sudo git clone https://aur.archlinux.org/yay-git.git
  sudo chown -R $USER ./yay-git
  pushd yay-git/
  makepkg -si --needed --noconfirm
  popd
  # /opt/
  popd
  # ~/.config/ledragox-linux-script

  aur_apps=(
    #"google-chrome"            # Google Chrome (Will make itself default when installed)
    "microsoft-edge-stable-bin" # Microsoft Edge
    "parsec-bin"                # Parsec
    "peazip-qt5-bin"            # RAR/ZIP Manager GUI
    "rsound"                    # SVP Dependency
    "spirv-cross"               # SVP Dependency
    "spotify-adblock-git"       # Spotify adblock
    "svp"                       # SVP 4 Linux (AUR)
    #"mpv-full"                 # Full MPV working with SVP
  )

  echoTitle "Installing via Yay (AUR)"
  installPackage "$aur_apps" "yay -S --needed --noconfirm"

  echoTitle "Enabling Snap repository"
  git clone https://aur.archlinux.org/snapd.git ~/$config_folder/snapd
  pushd snapd/
  makepkg -si --needed --noconfirm # Like dpkg
  popd

  sudo systemctl enable --now snapd.socket # Enable Snap Socket
  sudo ln -s /var/lib/snapd/snap /snap     # Link Snap directory to /snap
  echo "Snap will work only after loggin' out and in"

  snap_apps=(
    "onlyoffice-desktopeditors" # ONLY Office
  )

  echoTitle "Installing via Snap"
  installPackage "$snap_apps" "sudo snap install"

  echoSection "Snap Manual installations"
  sudo snap install code --classic  # VS Code (or code-insiders)
  sudo snap install slack --classic # Slack

  echoTitle "Enabling Flatpak repository"
  flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  flatpak_apps=(
    # Native Steam is better
  )

  echoSection "Installing via Flatpak"
  installPackage "$flatpak_apps" "flatpak --noninteractive --user install flathub"

}

function installPackage() {

  local apps=(${1})
  if [ $# -eq 1 ]; then
    local installBlock="sudo pacman -S --needed --noconfirm"
  else
    local installBlock="$2"
  fi

  echoCaption "COMMAND TO EXECUTE: $installBlock ${apps[@]}"
  # Iterate the string array using for loop
  for app in ${apps[@]}; do
    echoSection "Installing: ( ${#apps[@]} ) - [$app]"
    eval $installBlock $app
  done

}

function installDE() {

  PS3="Select the Desktop Environment (1 to skip): "
  select DesktopEnv in None KDE-Plasma-Minimal Gnome-Minimal XFCE-Minimal; do
    echo "You chose the $DesktopEnv"
    case $DesktopEnv in
    None)
      echoCaption "Skipping..."
      ;;
    KDE-Plasma-Minimal)
      echoSection "Installing $DesktopEnv"
      # SDDM Login Manager | Pure KDE Plasma | Wayland Session for KDE | XOrg & XOrg Server | KDE file manager | KDE screenshot tool
      installPackage "sddm plasma plasma-wayland-session xorg dolphin spectacle"
      echoCaption "Removing $DesktopEnv bloat (For me)"
      sudo pacman -Rns --noconfirm kate

      disableLoginManagers

      echoCaption "Setting sudo systemctl enable sddm"
      sudo systemctl enable sddm
      ;;
    Gnome-Minimal)
      echoSection "Installing $DesktopEnv"
      # GDM Login Manager | Pure Gnome | XOrg & XOrg Server
      installPackage "gdm gnome xorg"
      echoCaption "Removing $DesktopEnv bloat (For me)"
      sudo pacman -Rns --noconfirm gnome-terminal

      disableLoginManagers

      echo "Setting sudo systemctl enable gdm"
      sudo systemctl enable gdm
      ;;
    XFCE-Minimal)
      echoSection "Installing $DesktopEnv"
      # LightDM Login Manager | Login Screen Greeter (LightDM) | Pure XFCE | XOrg & XOrg Server
      installPackage "lightdm lightdm-gtk-greeter xfce4 xorg"
      # Plugins: Create/Extract files inside Thunar | Battery Monitor to panel | DateTime to panel | Mount/Unmount devices to panel | Control media player to panel | Notifications to panel | PulseAudio to panel | Screenshot tool | Task Manager | Command line to panel | Wi-fi monitor to panel | Menu to panel
      installPackage "thunar-archive-plugin xfce4-battery-plugin xfce4-datetime-plugin xfce4-mount-plugin xfce4-mpc-plugin xfce4-notifyd xfce4-pulseaudio-plugin xfce4-screenshooter xfce4-taskmanager xfce4-verve-plugin xfce4-wavelan-plugin xfce4-whiskermenu-plugin"
      echoCaption "Removing $DesktopEnv bloat (For me)"
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

}

function disableLoginManagers() {

  echoCaption "Disabling all Login Managers before enabling another"

  sudo systemctl disable gdm
  sudo systemctl disable lightdm
  sudo systemctl disable sddm

}

function postConfigs() {

  echoSection "Post Script Configs"
  echoCaption "Activating Num Lock"
  numlockx

  echoCaption "Detecting Windows installs"
  sudo os-prober

  echoCaption "Enabling os-prober execution on grub-mkconfig"
  sudo sh -c "echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub"

  echoCaption "Re-Configuring GRUB"
  sudo grub-mkconfig -o /boot/grub/grub.cfg

  echoCaption "Reloading all fonts in cache"
  fc-cache -v -f

  if (lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i "NVIDIA"); then

    echoSection "Installing NVIDIA drivers"
    if (uname -r | grep -i "\-lts"); then
      installPackage nvidia-lts # NVIDIA proprietary driver for linux-lts kernel
    else
      installPackage nvidia # NVIDIA proprietary driver for linux kernel
    fi
    # NVIDIA utils for 32 bits | NVIDIA Settings | NVIDIA CUDA SDK / OpenCL
    installPackage "lib32-nvidia-utils nvidia-settings cuda"

    echoCaption "Making /etc/X11/xorg.conf"
    echoCaption "DIY: Remember to comment lines like 'LOAD: \"dri\"'"
    sudo nvidia-xconfig

    echoCaption "Loading nvidia settings from /etc/X11/xorg.conf"
    nvidia-settings --load-config-only

  else
    echo "Skipping graphics driver install..."
  fi

}

function main() {

  initVariables
  echoTitle "Enabling Parallel Downloads"
  sudo sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf

  sudo pacman -Sy --needed --noconfirm wget curl zip unzip # Needed to download/install fonts and unzip it | Needed to get the best mirrors from region
  configEnv

  installPackagesArch
  postConfigs

  installZsh
  configGit

}

main
