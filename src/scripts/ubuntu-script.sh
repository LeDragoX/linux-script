#!/bin/bash

source ./src/lib/base-script.sh
source ./src/lib/install-package.sh
source ./src/lib/ubuntu-base-script.sh

function add_ubuntu_repositories() {
  echo_title "Adding new PPAs repositories"

  # https://linuxhint.com/bash_loop_list_strings/
  # Declare an array of string with type

  declare -a ADD_PPAS=(
    # PPA/Repo Stuff
    "ppa:danielrichter2007/grub-customizer"   # | GRUB Customizer
    "ppa:obsproject/obs-studio"               # | OBS Studio
    "ppa:pipewire-debian/pipewire-upstream"   # | Pipewire
    "ppa:qbittorrent-team/qbittorrent-stable" # | qBittorrent
  )
  readonly ADD_PPAS

  # Iterate the string array using for loop
  echo_section "Installing via Advanced Package Tool (apt)..."
  for ppa in "${ADD_PPAS[@]}"; do
    echo_caption "Installing: $ppa"
    sudo add-apt-repository -y "$ppa"
  done

  # Adding manually the rest

  # Google Chrome
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

  ## Microsoft Edge - Setup
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge.list'
  sudo rm microsoft.gpg

  # Spotify
  curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
  echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

  # VS Code (64-Bits)
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
  sudo rm packages.microsoft.gpg

  sudo apt update -y
}

function install_packages_ubuntu() {
  echo_title "Install Apt Packages"

  sudo dpkg --add-architecture i386                                           # Enable 32-bits Architecture
  sudo DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-restricted-extras # Remove interactivity | Useful proprietary stuff

  declare -a ubuntu_apps=(
    # Packages that i use CLI
    "adb fastboot scrcpy"                   # | Android Debugging + Android Screen Copy
    "arc-theme"                             # | My current favorite Desktop / Icon theme
    "build-essential"                       # | Building and Compiling requirement
    "file-roller"                           # | Manage .7z files with ease
    "gdebi gdebi-core"                      # | CLI/GUI .deb Installer
    "gparted"                               # | Gparted
    "grub-customizer grub-efi grub2-common" # | GRUB Customizer + EFI GRUB Requirements
    "htop vim"                              # | Terminal System Monitor
    "nano"                                  # | Terminal Text Editor
    "neofetch"                              # | Neofetch Command
    "ntfs-3g"                               # | NTFS support
    "os-prober"                             # | Detect Windows install
    "pavucontrol"                           # | Audio Controller
    "pip"                                   # | Python Module manager
    # Personal GUI Packages
    #"google-chrome-stable" # | Google Chrome
    "apt-transport-https code" # | VS Code (64-Bits) w/ Dependency
    "discord"                  # | Discord
    "gimp"                     # | GNU Image Manipulation Program (GIMP)
    "microsoft-edge-stable"    # | Microsoft Edge
    "obs-studio"               # | OBS Studio
    "qbittorrent"              # | qBittorrent
    "spotify-client"           # | Spotify
    "vlc"                      # | VLC
  )

  echo_section "Installing via Advanced Package Tool (apt)..."
  install_package_ubuntu "${ubuntu_apps[*]}"

  echo "Finishing setup of incomplete installs..."

  sudo gpasswd -a "$USER" plugdev

  declare -a apps_check=(
    "discord"                   # Discord
    "onlyoffice-desktopeditors" # ONLY Office
    "parsec"                    # Parsec
  )

  # If these packages are not found, this is the manual install
  echo_section "Installing via Advanced Package Tool (apt)..."
  for app in "${apps_check[@]}"; do
    if (apt list --installed | grep -i "$app/"); then
      echo "$app ALREADY INSTALLED, SKIPPING..."
    else
      echo_caption "Installing: $app"

      # I know, SWITCH CASE THING
      echo "Installing properly $app..."
      if [[ "$app" = "discord" ]]; then
        echo "$app"
        # Discord
        wget -c -O ~/"$CONFIG_FOLDER"/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
        sudo gdebi -n ~/"$CONFIG_FOLDER"/discord.deb
      fi

      if [[ "$app" = "onlyoffice-desktopeditors" ]]; then
        echo "$app"
        # ONLY Office
        wget -c -O ~/"$CONFIG_FOLDER"/onlyoffice-desktopeditors_amd64.deb "http://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb"
        sudo gdebi -n ~/"$CONFIG_FOLDER"/onlyoffice-desktopeditors_amd64.deb
      fi

      if [[ "$app" = "parsec" ]]; then
        echo "$app"
        # Parsec
        wget -c -O ~/"$CONFIG_FOLDER"/parsec-linux.deb "https://builds.parsecgaming.com/package/parsec-linux.deb"
        sudo gdebi -n ~/"$CONFIG_FOLDER"/parsec-linux.deb
      fi
    fi
  done
}

function configure_audio() {
  echo_title "Configuring Audio w/ PipeWire"

  install_package_ubuntu "pipewire pipewire-pulse pipewire-audio-client-libraries wireplumber gstreamer1.0-pipewire libspa-0.2-bluetooth libspa-0.2-jack" # | Pipewire audio server
  systemctl --user disable --now pulseaudio.service pulseaudio.socket
  systemctl --user mask --now pulseaudio.service pulseaudio.socket
  systemctl --user enable --now pipewire.socket pipewire-pulse.socket pipewire pipewire-session-manager
  pactl info
}

function configure_grub_bootloader() {
  echo_title "Prepare GRUB"

  sudo grub-install
  if (neofetch | grep -i Pop\!_OS); then
    sudo cp /boot/grub/x86_64-efi/grub.efi /boot/efi/EFI/pop/grubx64.efi
    echo "1) Click on the File tab > Change Environment... " >~/"$CONFIG_FOLDER"/grub.txt
    {
      echo "2) Where is OUTPUT_FILE: '/boot/grub/grub.cfg' Switch to: "
      echo "/boot/efi/EFI/pop/grub.cfg"
      echo "3) Then check [X] Save this setting > Apply\!"
    } >>~/"$CONFIG_FOLDER"/grub.txt

    cat ~/"$CONFIG_FOLDER"/grub.txt
    sudo grub-customizer
  else
    echo_caption "Not Pop\!_OS"
  fi

  clear
  rm ~/"$CONFIG_FOLDER"/grub.txt
  echo "GRUB Ready!"
}

function configure_graphics_driver() {
  # NVIDIA Graphics Driver
  sudo cat /etc/X11/default-display-manager
  if (neofetch | grep -i Pop\!_OS); then # Verify if the Distro already include the NVIDIA driver, currently Pop!_OS.
    echo "OS already included Drivers on ISO, but installing if it isn't"
    install_package_ubuntu "system76-driver-nvidia"
  else
    if (command -v nvidia-smi); then
      echo "NVIDIA Graphics Driver already installed...proceeding with Extras"
      install_package_ubuntu "ocl-icd-opencl-dev" &&
        install_package_ubuntu "libvulkan1 libvulkan1:i386" &&
        install_package_ubuntu "nvidia-settings" &&
        install_package_ubuntu "dkms linux-headers-generic"
    else
      if (lspci -k | grep -i NVIDIA); then # Checking if your GPU is from NVIDIA.
        echo "Blacklisting NOUVEAU driver from NVIDIA in /etc/modprobe.d/blacklist.conf"
        sudo sh -c "echo '# Freaking open-source NVIDIA driver that glitches every system \nblacklist nouveaublacklist lbm-nouveauoptions nouveau modeset=0alias nouveau offalias lbm-nouveau off' >> /etc/modprobe.d/blacklist.conf"

        echo "NVIDIA Graphics Driver and Extras"
        sudo add-apt-repository -y ppa:graphics-drivers/ppa &&
          sudo apt update -y &&
          install_package_ubuntu "nvidia-driver-525" && # 01/2023 v525 = Proprietary
          install_package_ubuntu "ocl-icd-opencl-dev" &&
          install_package_ubuntu "libvulkan1 libvulkan1:i386" &&
          install_package_ubuntu "nvidia-settings" &&
          install_package_ubuntu "dkms linux-headers-generic"
      else
        echo "GPU different from NVIDIA"
      fi
    fi
  fi
}

function main() {
  config_environment
  script_logo
  pre_ubuntu_setup
  add_ubuntu_repositories
  install_packages_ubuntu
  install_version_managers
  configure_audio
  configure_grub_bootloader
  configure_graphics_driver
  install_fonts
  install_zsh
  install_oh_my_zsh
  upgrade_all_ubuntu
}

main
