#!/usr/bin/env bash

source ./src/lib/arch-base-script.sh
source ./src/lib/base-script.sh

function mainMenu() {
  scriptLogo
  PS3="Select an option: "
  select option in "Go Back" "[REBOOT] Install Package Managers (Yay, Snap & Flatpak)" 'Auto-install from "Scratch" (DE, Packages, Boot, Drivers, Fonts + Oh My ZSH)' "[MENU] Install Desktop Environment" "Install all Arch Packages (Requires package managers)" "Setup Desktop Workflow (GPU Drivers, Pipewire Audio, Fonts + Oh My ZSH)" "Install SVP (Watch videos in 60+ FPS)"; do
    echo "You chose to $option"
    case $option in
    "Go Back")
      clear
      echo "Exiting..." && echo
      bash ./LinuxScript.sh
      break
      ;;
    "[REBOOT] Install Package Managers (Yay, Snap & Flatpak)")
      clear
      installPackageManagers

      waitPrompt
      mainMenu
      ;;
    'Auto-install from "Scratch" (DE, Packages, Boot, Drivers, Fonts + Oh My ZSH)')
      clear
      installDE
      installPackagesArch
      installKvm
      installProgrammingLanguagesWithVersionManagers
      configureGRUBBootloader
      configureGraphicsDriver
      configureAudio
      installFonts
      installZsh
      installOhMyZsh

      waitPrompt
      mainMenu
      ;;
    "[MENU] Install Desktop Environment")
      clear
      installDE

      waitPrompt
      mainMenu
      ;;
    "Install all Arch Packages (Requires package managers)")
      clear
      installPackagesArch
      installKvm
      installProgrammingLanguagesWithVersionManagers

      waitPrompt
      mainMenu
      ;;
    "Setup Desktop Workflow (GPU Drivers, Pipewire Audio, Fonts + Oh My ZSH)")
      clear
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

function installDE() {
  install_package "xorg" # | XOrg & XOrg Server |

  PS3="Select the Desktop Environment (1 to skip): "
  select _desktopEnv in "No Desktop (skip)" "Cinnamon" "Gnome" "KDE Plasma" "XFCE"; do
    echo "You chose the $_desktopEnv"
    case $_desktopEnv in
    "No Desktop (skip)")
      echoCaption "Skipping..."
      ;;
    "Cinnamon")
      echoSection "Installing $_desktopEnv"
      # | GDM Login Manager | Cinnamon
      install_package "gdm cinnamon"
      disableSessionManagers

      echoCaption "Setting sudo systemctl enable gdm..."
      sudo systemctl enable gdm
      ;;
    "Gnome")
      echoSection "Installing $_desktopEnv"
      # | GDM Login Manager | Pure Gnome |
      install_package "gdm gnome"
      disableSessionManagers

      echo "Setting sudo systemctl enable gdm"
      sudo systemctl enable gdm
      ;;
    "KDE Plasma")
      echoSection "Installing $_desktopEnv"
      # | SDDM Login Manager | Pure KDE Plasma | Wayland Session for KDE | KDE file manager | KDE screenshot tool
      install_package "sddm plasma plasma-wayland-session dolphin spectacle"
      disableSessionManagers

      echoCaption "Setting sudo systemctl enable sddm..."
      sudo systemctl enable sddm
      ;;
    "XFCE")
      echoSection "Installing $_desktopEnv"
      # | LightDM Login Manager | Login Screen Greeter (LightDM) | Pure XFCE |
      install_package "lightdm lightdm-gtk-greeter xfce4 xfce4-goodies"
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
  local _archPacmanApps=(
    "adobe-source-han-sans-cn-fonts adobe-source-han-sans-hk-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-otc-fonts adobe-source-han-sans-tw-fonts noto-fonts-emoji ttf-dejavu" # | Fonts and Emoji support
    # Don't remove this comment to format properly
    "arc-gtk-theme"              # | Arc Desktop/App Theme
    "amd-ucode intel-ucode"      # | AMD/Intel CPU Microcode
    "base-devel"                 # | Development Tools
    "fastfetch"                  # | System Specs
    "file-roller"                # | Manage .7z files with ease
    "gimp"                       # | Gimp
    "gnome-keyring"              # | Fix VS Code secrets
    "gparted"                    # | Gparted
    "htop"                       # | Terminal System Monitor
    "man-db man-pages"           # | Manual utility (English)
    "nano vim"                   # | Console text editors
    "ntfs-3g"                    # | NTFS driver
    "obs-studio"                 # | OBS Studio
    "pavucontrol"                # | Audio Controller
    "python-pip"                 # | Python Module manager
    "qbittorrent"                # | qBittorrent
    "scrcpy"                     # | Android ScrCpy
    "steam steam-native-runtime" # | Steam + Fix
    "vlc"                        # | VLC
    #"discord"                   # | Discord
  )

  echoSection "Installing via Pacman"
  echo "${_archPacmanApps[*]}"
  install_package "${_archPacmanApps[*]}"

  # | Microsoft Edge  | Parsec | RAR/ZIP Manager GUI
  # | Spotify adblock | Google Chrome (Optional)
  local _archAurApps="microsoft-edge-stable-bin parsec-bin spotify-adblock-git" #google-chrome"

  echoTitle "Installing via Yay (AUR)"
  install_package "$_archAurApps" "yay -S --needed --noconfirm"

  # | Emote w/ shortcut
  local _archSnapApps=("emote")
  # | VS Code (or code-insiders)
  local _archSnapAppsClassic="code"

  echoTitle "Installing via Snap"
  install_package "${_archSnapApps[*]}" "sudo snap install"
  install_package "$_archSnapAppsClassic" "sudo snap install --classic"

  local _flatpakApps=(
    "dev.vencord.Vesktop"           # | Vesktop (better Discord alternative for linux)
    "org.onlyoffice.desktopeditors" # | ONLYOFFICE Desktop Editors
  )

  echoSection "Installing via flatpak"
  echo "${_flatpakApps[*]}"
  install_package "${_flatpakApps[*]}" "flatpak install flathub --system -y"

}

function installKvm() {
  installSection "Installing KVM properly :)"
  install_package "virt-manager qemu-desktop dnsmasq iptables-nft"
  sudo systemctl enable --now libvirtd.service
}

function installSVP() {
  # SVP Dependencies
  local _svpPacmanApps="libmediainfo lsof qt5-base qt5-declarative qt5-svg vapoursynth"
  install_package "$_svpPacmanApps"
  # SVP Dependency # SVP 4 Linux (AUR) # Full MPV working with SVP # HEAVY SVP Dependency
  local _svpAurApps="rsound svp mpv-full spirv-cross"
  install_package "$_svpAurApps" "yay -S --needed --noconfirm"
}

function configureAudio() {
  echoTitle "Configuring Audio w/ PipeWire"

  install_package "lib32-pipewire pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber"
  systemctl --user disable --now pulseaudio.service pulseaudio.socket
  systemctl --user mask --now pulseaudio.service pulseaudio.socket
  systemctl --user enable --now pipewire.socket pipewire-pulse.socket pipewire pipewire-session-manager
  pactl info
}

function configureGRUBBootloader() {
  echoTitle "Configuring GRUB for multiple Systems"

  install_package "grub-customizer os-prober"

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
      install_package nvidia-lts # NVIDIA proprietary driver for linux-lts kernel
    else
      install_package nvidia # NVIDIA proprietary driver for linux kernel
    fi
    # NVIDIA utils for 32 bits | NVIDIA Settings | NVIDIA CUDA SDK / OpenCL
    install_package "lib32-nvidia-utils nvidia-settings cuda"

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

function main() {
  configEnv
  preArchSetup
  mainMenu
}

main
