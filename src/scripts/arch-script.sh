#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/arch-base-script.sh

function installPackagesArch() {
  installDE # Let you choose if you want to install a DE or NOT

  # https://linuxhint.com/bash_loop_list_strings/
  # Declare an array of string with type

  # Asian Fonts (CN, JP, KR, TW) # AMD CPU Microcode # yay Dependency # Discord Canary
  # Gimp # Git # Fixes keyring bug on VSCode (https://github.com/microsoft/vscode/issues/92972#issuecomment-625751232) # Gparted
  # GRUB Customizer (Conflict ERROR on Manjaro) # Sound for Wine # SVP Dependency # SVP Dependency
  # Terminal System Monitor # Console text editor # Neofetch command # Emoji Support
  # NTFS support (Windows Dualboot) # OBS Studio # Detect Windows install
  # Audio Controller # Python Module manager # qBittorrent # SVP Dependency
  # SVP Dependency # SVP Dependency # Android ScrCpy # SMPlayer
  # Steam # Fix Steam GUI # Terminator # SVP Dependency
  # Console text editor # VLC
  local _pacmanApps="
  adobe-source-han-sans-otc-fonts
  amd-ucode
  discord
  gimp
  git
  gparted
  grub-customizer
  lib32-libpulse
  libmediainfo
  lsof
  htop
  nano
  neofetch
  noto-fonts-emoji
  ntfs-3g
  obs-studio
  os-prober
  pavucontrol
  python-pip
  qbittorrent
  qt5-base
  qt5-declarative
  qt5-svg
  scrcpy
  smplayer
  steam
  steam-native-runtime
  terminator
  vapoursynth
  vim
  vlc"

  echoSection "Installing via Pacman"
  echo "$_pacmanApps"
  installPackage "$_pacmanApps"

  # Microsoft Edge # Parsec # RAR/ZIP Manager GUI # SVP Dependency
  # Spotify adblock # SVP 4 Linux (AUR)
  # Google Chrome (Will make itself default when installed) # Full MPV working with SVP # HEAVY SVP Dependency
  local _aurApps="microsoft-edge-stable-bin parsec-bin peazip-qt5-bin rsound spotify-adblock-git svp" #google-chrome" #mpv-full #spirv-cross"

  echoTitle "Installing via Yay (AUR)"
  installPackage "$_aurApps" "yay -S --needed --noconfirm"

  # ONLY Office
  _snapApps="onlyoffice-desktopeditors"

  echoTitle "Installing via Snap"
  installPackage "$_snapApps" "sudo snap install"

  echoSection "Snap Manual installations"
  sudo snap install code --classic  # VS Code (or code-insiders)
  sudo snap install slack --classic # Slack

  # N/A
  declare -a _flatpakApps=""

  echoSection "Installing via Flatpak"
  installPackage "$_flatpakApps" "flatpak --noninteractive --user install flathub"
}

function installDE() {
  installPackage "xorg" # | XOrg & XOrg Server |

  PS3="Select the Desktop Environment (1 to skip): "
  select _desktopEnv in None KDE-Plasma-Minimal Gnome-Minimal XFCE-Minimal; do
    echo "You chose the $_desktopEnv"
    case $_desktopEnv in
    None)
      echoCaption "Skipping..."
      ;;
    KDE-Plasma-Minimal)
      echoSection "Installing $_desktopEnv"
      # SDDM Login Manager | Pure KDE Plasma | Wayland Session for KDE | KDE file manager | KDE screenshot tool
      installPackage "sddm plasma plasma-wayland-session dolphin spectacle"
      disableLoginManagers

      echoCaption "Setting sudo systemctl enable sddm..."
      sudo systemctl enable sddm
      ;;
    Gnome-Minimal)
      echoSection "Installing $_desktopEnv"
      # | GDM Login Manager | Pure Gnome |
      installPackage "gdm gnome"
      disableLoginManagers

      echo "Setting sudo systemctl enable gdm"
      sudo systemctl enable gdm
      ;;
    XFCE-Minimal)
      echoSection "Installing $_desktopEnv"
      # | LightDM Login Manager | Login Screen Greeter (LightDM) | Pure XFCE |
      installPackage "lightdm lightdm-gtk-greeter xfce4"
      # Plugins: Create/Extract files inside Thunar | Battery Monitor to panel | DateTime to panel | Mount/Unmount devices to panel | Control media player to panel | Notifications to panel | PulseAudio to panel | Screenshot tool | Task Manager | Command line to panel | Wi-fi monitor to panel | Menu to panel
      installPackage "thunar-archive-plugin xfce4-battery-plugin xfce4-datetime-plugin xfce4-mount-plugin xfce4-mpc-plugin xfce4-notifyd xfce4-pulseaudio-plugin xfce4-screenshooter xfce4-taskmanager xfce4-verve-plugin xfce4-wavelan-plugin xfce4-whiskermenu-plugin"
      disableLoginManagers

      echo "Setting sudo systemctl enable lightdm"
      sudo systemctl enable lightdm
      ;;
    *)
      echoError "ERROR: Invalid Option"
      ;;
    esac
    break
  done
}

function disableLoginManagers() {
  echoCaption "Disabling all Login Managers before enabling another..."

  sudo systemctl disable gdm
  sudo systemctl disable lightdm
  sudo systemctl disable sddm
}

function postSetupForDesktop() {
  echoTitle "Post Script Setup For Desktop"

  echoCaption "Detecting Windows installs..."
  sudo os-prober

  echoCaption "Enabling os-prober execution on grub-mkconfig..."
  sudo sh -c "echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub"

  echoCaption "Re-Configuring GRUB"
  sudo grub-mkconfig -o /boot/grub/grub.cfg

  echoCaption "Reloading all fonts in cache..."
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

    echoCaption "Making /etc/X11/xorg.conf ..."
    echoCaption "DIY: Remember to comment lines like 'LOAD: \"dri\"' ..."
    sudo nvidia-xconfig

    echoCaption "Loading nvidia settings from /etc/X11/xorg.conf ..."
    nvidia-settings --load-config-only

  else
    echo "Skipping graphics driver install..."
  fi
}

function main() {
  configEnv
  echoArchScriptLogo
  preArchSetup
  enablePackageManagers
  installPackagesArch
  postSetupForDesktop
  installFonts
  installZsh
  installOhMyZsh
}

main
