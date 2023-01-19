#!/usr/bin/env bash

source ./src/lib/arch-base-script.sh
source ./src/lib/base-script.sh

function mainMenu() {
  scriptLogo
  PS3="Select an option: "
  select option in "Go Back" "[REBOOT] Install Package Managers (Yay, Snap)" '"Automatic install" (DE, Packages, Workflow)' "[MANUAL] Install Desktop Environment" "Install all Arch Packages (Requires package managers)" "Setup Desktop Workflow" "Install SVP (Watch videos in 60+ FPS)"; do
    echo "You chose to $option"
    case $option in
    "Go Back")
      clear
      echo "Exiting..." && echo
      bash ./LinuxScript.sh
      break
      ;;
    "[REBOOT] Install Package Managers (Yay, Snap)")
      clear
      installPackageManagers

      waitPrompt
      mainMenu
      ;;
    '"Automatic install" (DE, Packages, Workflow)')
      clear
      installDE
      installPackagesArch
      installProgrammingLanguagesWithVersionManagers
      configureBoot
      configureGraphicsDriver
      configureAudio
      installFonts
      installZsh
      installOhMyZsh

      waitPrompt
      mainMenu
      ;;
    "[MANUAL] Install Desktop Environment")
      clear
      installDE

      waitPrompt
      mainMenu
      ;;
    "Install all Arch Packages (Requires package managers)")
      clear
      installPackagesArch
      installProgrammingLanguagesWithVersionManagers

      waitPrompt
      mainMenu
      ;;
    "Setup Desktop Workflow")
      clear
      configureBoot
      configureGraphicsDriver
      configureAudio
      installFonts
      installZsh
      installOhMyZsh

      waitPrompt
      mainMenu
      ;;
    "Install SVP (Watch videos in 60+ FPS)")
      clear
      installSVP

      waitPrompt
      mainMenu
      ;;
    *)
      clear
      echoError "ERROR: Invalid Option"
      mainMenu
      break
      ;;
    esac
    break
  done
}

function configureAudio() {
  echoTitle "Configuring Audio w/ PipeWire"

  installPackage "lib32-pipewire pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber"
}

function configureBoot() {
  echoTitle "Configuring GRUB for multiple Systems"

  echoCaption "Help GRUB detect Windows installs..."
  sudo os-prober

  echoCaption "Enabling os-prober execution on grub-mkconfig..."
  sudo sh -c "echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub"

  echoCaption "Re-Configuring GRUB"
  sudo grub-mkconfig -o /boot/grub/grub.cfg

  echoCaption "Reloading all fonts in cache..."
  fc-cache -v -f
}

function configureGraphicsDriver() {
  echoTitle "Configuring Graphics Driver (NVIDIA only at the moment)"

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

function disableSessionManagers() {
  echoCaption "Disabling all Session Managers before enabling another..."

  sudo systemctl disable gdm
  sudo systemctl disable lightdm
  sudo systemctl disable sddm
}

function installDE() {
  installPackage "xorg" # | XOrg & XOrg Server |

  PS3="Select the Desktop Environment (1 to skip): "
  select _desktopEnv in "None (Skip)" "Cinnamon" "Gnome" "KDE Plasma (Minimal)" "XFCE (Minimal)"; do
    echo "You chose the $_desktopEnv"
    case $_desktopEnv in
    "None (Skip)")
      echoCaption "Skipping..."
      ;;
    "Cinnamon")
      echoSection "Installing $_desktopEnv"
      # | GDM Login Manager | Cinnamon
      installPackage "gdm cinnamon"
      disableSessionManagers

      echoCaption "Setting sudo systemctl enable gdm..."
      sudo systemctl enable gdm
      ;;
    "Gnome")
      echoSection "Installing $_desktopEnv"
      # | GDM Login Manager | Pure Gnome |
      installPackage "gdm gnome"
      disableSessionManagers

      echo "Setting sudo systemctl enable gdm"
      sudo systemctl enable gdm
      ;;
    "KDE Plasma (Minimal)")
      echoSection "Installing $_desktopEnv"
      # | SDDM Login Manager | Pure KDE Plasma | Wayland Session for KDE | KDE file manager | KDE screenshot tool
      installPackage "sddm plasma plasma-wayland-session dolphin spectacle"
      disableSessionManagers

      echoCaption "Setting sudo systemctl enable sddm..."
      sudo systemctl enable sddm
      ;;
    "XFCE (Minimal)")
      echoSection "Installing $_desktopEnv"
      # | LightDM Login Manager | Login Screen Greeter (LightDM) | Pure XFCE |
      installPackage "lightdm lightdm-gtk-greeter xfce4"
      # Plugins: Create/Extract files inside Thunar | Battery Monitor to panel | DateTime to panel | Mount/Unmount devices to panel | Control media player to panel | Notifications to panel | PulseAudio to panel | Screenshot tool | Task Manager | Command line to panel | Wi-fi monitor to panel | Menu to panel
      installPackage "thunar-archive-plugin xfce4-battery-plugin xfce4-datetime-plugin xfce4-mount-plugin xfce4-mpc-plugin xfce4-notifyd xfce4-pulseaudio-plugin xfce4-screenshooter xfce4-taskmanager xfce4-verve-plugin xfce4-wavelan-plugin xfce4-whiskermenu-plugin"
      disableSessionManagers

      echo "Setting sudo systemctl enable lightdm"
      sudo systemctl enable lightdm
      ;;
    *)
      echoError "ERROR: Invalid Option"
      installDE
      break
      ;;
    esac
    break
  done
}

function installPackagesArch() {
  # | Adobe Asian Fonts (CN, JP, KR, TW) | AMD CPU Microcode | Development Tools | Discord | Gimp | Git | Fix VS Code secrets
  # | Gparted | GRUB Customizer | Terminal System Monitor | Intel CPU Microcode | Manual utility | System commands manual (English) | Console text editor | System Specs | Emoji Support | NTFS driver
  # | OBS Studio | Detect Windows install | Audio Controller | Python Module manager | qBittorrent
  # | Android ScrCpy | Steam | Fix Steam | Terminator | Console text editor | VLC
  local _archPacmanApps="adobe-source-han-sans-otc-fonts amd-ucode base-devel discord gimp git gnome-keyring
  gparted grub-customizer htop intel-ucode man-db man-pages nano neofetch noto-fonts-emoji ntfs-3g
  obs-studio os-prober pavucontrol python-pip qbittorrent
  scrcpy steam steam-native-runtime terminator vim vlc "

  echoSection "Installing via Pacman"
  echo "$_archPacmanApps"
  installPackage "$_archPacmanApps"

  # | Microsoft Edge  | Parsec | RAR/ZIP Manager GUI
  # | Spotify adblock | Google Chrome (Optional)
  local _archAurApps="microsoft-edge-stable-bin parsec-bin peazip-qt5 spotify-adblock-git" #google-chrome"

  echoTitle "Installing via Yay (AUR)"
  installPackage "$_archAurApps" "yay -S --needed --noconfirm"

  # ONLY Office
  _archSnapApps="onlyoffice-desktopeditors"

  echoTitle "Installing via Snap"
  installPackage "$_archSnapApps" "sudo snap install"

  echoSection "Snap Manual installations"
  sudo snap install code --classic  # VS Code (or code-insiders)
  sudo snap install slack --classic # Slack
}

function installSVP() {
  # SVP Dependencies
  local _svpPacmanApps = "libmediainfo lsof qt5-base qt5-declarative qt5-svg vapoursynth"
  installPackage "$_svpPacmanApps"
  # SVP Dependency # SVP 4 Linux (AUR) # Full MPV working with SVP # HEAVY SVP Dependency
  local _svpAurApps = "rsound svp mpv-full spirv-cross"
  installPackage "$_svpAurApps" "yay -S --needed --noconfirm"
}

function main() {
  configEnv
  preArchSetup
  mainMenu
}

main
