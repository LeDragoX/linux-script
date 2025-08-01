#!/bin/bash

source ./src/lib/arch-base-script.sh
source ./src/lib/install-package.sh
source ./src/lib/base-script.sh

function main_menu() {
  script_logo
  PS3="Select an option: "
  select option in "Go Back" "[REBOOT] Install Package Managers (Yay, Snap & Flatpak)" 'Auto-install from "Scratch" (DE, Packages, GRUB Bootloader, Drivers, Fonts + Oh My ZSH)' "[MENU] Install Desktop Environment" "Install all Arch Packages (Requires package managers)" "Setup Desktop Workflow (GPU Drivers, Pipewire Audio, Fonts + Oh My ZSH)" "Install SVP (Watch videos in 60+ FPS)"; do
    echo "You chose to $option"
    case $option in
    "Go Back")
      clear
      echo "Exiting..." && echo
      bash ./linux-script.sh
      break
      ;;
    "[REBOOT] Install Package Managers (Yay, Snap & Flatpak)")
      clear
      install_package_managers

      wait_prompt
      main_menu
      ;;
    'Auto-install from "Scratch" (DE, Packages, GRUB Bootloader, Drivers, Fonts + Oh My ZSH)')
      clear
      install_desktop_environment
      install_packages_arch
      install_kvm
      install_version_managers
      configure_grub_bootloader
      configure_graphics_driver
      configure_audio
      install_fonts
      install_zsh
      install_oh_my_zsh

      wait_prompt
      main_menu
      ;;
    "[MENU] Install Desktop Environment")
      clear
      install_desktop_environment

      wait_prompt
      main_menu
      ;;
    "Install all Arch Packages (Requires package managers)")
      clear
      install_packages_arch
      install_kvm
      install_version_managers

      wait_prompt
      main_menu
      ;;
    "Setup Desktop Workflow (GPU Drivers, Pipewire Audio, Fonts + Oh My ZSH)")
      clear
      configure_graphics_driver
      configure_audio
      install_fonts
      install_zsh
      install_oh_my_zsh

      wait_prompt
      main_menu
      ;;
    "Install SVP (Watch videos in 60+ FPS)")
      clear
      install_svp

      wait_prompt
      main_menu
      ;;
    *)
      clear
      echo_error "ERROR: Invalid Option"
      main_menu
      break
      ;;
    esac
    break
  done
}

function install_desktop_environment() {
  install_package_arch "xorg" # | XOrg & XOrg Server |

  PS3="Select the Desktop Environment (1 to skip): "
  select desktop_environment in "No Desktop (skip)" "Cinnamon" "Gnome" "KDE Plasma" "XFCE"; do
    echo "You chose the $desktop_environment"
    case $desktop_environment in
    "No Desktop (skip)")
      echo_caption "Skipping..."
      ;;
    "Cinnamon")
      echo_section "Installing $desktop_environment"
      # | GDM Login Manager | Cinnamon
      install_package_arch "gdm cinnamon"
      disableSessionManagers

      echo_caption "Setting sudo systemctl enable gdm..."
      sudo systemctl enable gdm
      ;;
    "Gnome")
      echo_section "Installing $desktop_environment"
      # | GDM Login Manager | Pure Gnome |
      install_package_arch "gdm gnome"
      disableSessionManagers

      echo "Setting sudo systemctl enable gdm"
      sudo systemctl enable gdm
      ;;
    "KDE Plasma")
      echo_section "Installing $desktop_environment"
      # | SDDM Login Manager | Pure KDE Plasma | Wayland Session for KDE | KDE file manager | KDE screenshot tool
      install_package_arch "sddm plasma plasma-wayland-session dolphin spectacle"
      disableSessionManagers

      echo_caption "Setting sudo systemctl enable sddm..."
      sudo systemctl enable sddm
      ;;
    "XFCE")
      echo_section "Installing $desktop_environment"
      # | LightDM Login Manager | Login Screen Greeter (LightDM) | Pure XFCE |
      install_package_arch "lightdm lightdm-gtk-greeter xfce4 xfce4-goodies"
      disableSessionManagers

      echo "Setting sudo systemctl enable lightdm"
      sudo systemctl enable lightdm
      ;;
    *)
      echo_error "ERROR: Invalid Option"
      install_desktop_environment
      break
      ;;
    esac
    break
  done
}

function install_packages_arch() {
  local arch_pacman_apps=(
    "adobe-source-han-sans-cn-fonts adobe-source-han-sans-hk-fonts adobe-source-han-sans-jp-fonts adobe-source-han-sans-kr-fonts adobe-source-han-sans-otc-fonts adobe-source-han-sans-tw-fonts noto-fonts-emoji ttf-dejavu" # | Fonts and Emoji support
    # Don't remove this comment to format properly
    "amd-ucode intel-ucode"    # | AMD/Intel CPU Microcode
    "arc-gtk-theme"            # | Arc Desktop/App Theme
    "base-devel"               # | Development Tools
    "exfatprogs"               # | exFAT driver
    "fastfetch"                # | System Specs
    "file-roller"              # | Manage .7z files with ease
    "gimp"                     # | Gimp
    "gnome-keyring"            # | Fix VS Code secrets
    "gparted partitionmanager" # | Partition Managers
    "htop"                     # | Terminal System Monitor
    "lutris"                   # | Lutris
    "man-db man-pages"         # | Manual utility (English)
    "nano vim"                 # | Console text editors
    "ntfs-3g"                  # | NTFS driver
    "obs-studio"               # | OBS Studio
    "pavucontrol"              # | Audio Controller
    "python-pip"               # | Python Module manager
    "qbittorrent"              # | qBittorrent
    "scrcpy"                   # | Android ScrCpy
    "vlc"                      # | VLC
  )

  echo_section "Installing via Pacman"
  echo "${arch_pacman_apps[*]}"
  install_package_arch "${arch_pacman_apps[*]}"

  # | Parsec | Spotify adblock | Vesktop | Google Chrome (Optional)
  local arch_aur_apps="parsec-bin spotify-adblock-git vesktop" #google-chrome"

  echo_title "Installing via Yay (AUR)"
  install_package_arch "$arch_aur_apps" "yay -S --needed --noconfirm"

  # | Emote w/ shortcut
  local arch_snap_apps=("emote")
  # | VS Code (or code-insiders)
  local arch_snap_apps_classic="code"

  echo_title "Installing via Snap"
  install_package_arch "${arch_snap_apps[*]}" "sudo snap install"
  install_package_arch "$arch_snap_apps_classic" "sudo snap install --classic"

  install_my_flatpak_packages
}

function install_kvm() {
  install_section "Installing KVM properly :)"
  install_package_arch "virt-manager qemu-desktop dnsmasq iptables-nft"
  sudo systemctl enable --now libvirtd.service
}

function install_svp() {
  # SVP Dependencies
  local svp_pacman_apps="libmediainfo lsof qt5-base qt5-declarative qt5-svg vapoursynth"
  install_package_arch "$svp_pacman_apps"
  # SVP Dependency # SVP 4 Linux (AUR) # Full MPV working with SVP # HEAVY SVP Dependency
  local svp_aur_apps="rsound svp mpv-full spirv-cross"
  install_package_arch "$svp_aur_apps" "yay -S --needed --noconfirm"
}

function configure_audio() {
  echo_title "Configuring Audio w/ PipeWire"

  install_package_arch "lib32-pipewire pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber"
  systemctl --user disable --now pulseaudio.service pulseaudio.socket
  systemctl --user mask --now pulseaudio.service pulseaudio.socket
  systemctl --user enable --now pipewire.socket pipewire-pulse.socket pipewire pipewire-session-manager
  pactl info
}

function configure_grub_bootloader() {
  echo_title "Configuring GRUB for multiple Systems"

  install_package_arch "grub-customizer os-prober"

  echo_caption "Help GRUB detect Windows installs..."
  sudo os-prober

  echo_caption "Enabling os-prober execution on grub-mkconfig..."
  sudo sh -c "echo 'GRUB_DISABLE_OS_PROBER=false' >> /etc/default/grub"

  echo_caption "Re-Configuring GRUB"
  sudo grub-mkconfig -o /boot/grub/grub.cfg

  echo_caption "Reloading all fonts in cache..."
  fc-cache -v -f
}

function configure_graphics_driver() {
  echo_title "Configuring Graphics Driver (NVIDIA only at the moment)"

  if (lspci -k | grep -A 2 -E "(VGA|3D)" | grep -i "NVIDIA"); then
    echo_section "Installing NVIDIA drivers"
    if (uname -r | grep -i "\-lts"); then
      install_package_arch nvidia-lts # NVIDIA proprietary driver for linux-lts kernel
    else
      install_package_arch nvidia # NVIDIA proprietary driver for linux kernel
    fi
    # NVIDIA utils for 32 bits | NVIDIA Settings | NVIDIA CUDA SDK / OpenCL
    install_package_arch "lib32-nvidia-utils nvidia-settings cuda"

    echo_caption "Making /etc/X11/xorg.conf ..."
    echo_caption "DIY: Remember to comment lines like 'LOAD: \"dri\"' ..."
    sudo nvidia-xconfig

    echo_caption "Loading nvidia settings from /etc/X11/xorg.conf ..."
    nvidia-settings --load-config-only
  else
    echo "Skipping graphics driver install..."
  fi
}

function disableSessionManagers() {
  echo_caption "Disabling all Session Managers before enabling another..."

  sudo systemctl disable gdm
  sudo systemctl disable lightdm
  sudo systemctl disable sddm
}

function main() {
  config_environment
  pre_arch_setup
  main_menu
}

main
