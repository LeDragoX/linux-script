#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/ubuntu-base-script.sh

function installPpaKeysUbuntu() {
  echoTitle "Add PPAs"

  # https://linuxhint.com/bash_loop_list_strings/
  # Declare an array of string with type

  declare -a _addPPAs=(
    # PPA/Repo Stuff
    "ppa:danielrichter2007/grub-customizer"   # GRUB Customizer
    "ppa:obsproject/obs-studio"               # OBS Studio
    "ppa:otto-kesselgulasch/gimp"             # GNU Image Manipulation Program (GIMP)
    "ppa:qbittorrent-team/qbittorrent-stable" # qBittorrent
    "ppa:rvm/smplayer"                        # SMPlayer
  )

  # Iterate the string array using for loop
  echoSection "Installing via Advanced Package Tool (apt)..."
  for _PPA in ${_addPPAs[@]}; do
    echoCaption "Installing: $_PPA"
    sudo add-apt-repository -y $_PPA
    sudo apt update -y
  done

  # Adding manually the rest

  # Google Chrome
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

  ## Microsoft Edge - Setup
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
  sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-beta.list'
  sudo rm microsoft.gpg

  # Spotify
  curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
  echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

  # VS Code (64-Bits)
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
  sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
  sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

}

function installPackagesUbuntu() {
  echoTitle "Install Apt Packages"

  sudo dpkg --add-architecture i386                                           # Enable 32-bits Architecture
  sudo DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-restricted-extras # Remove interactivity | Useful proprietary stuff

  declare -a _aptApps=(
    # Packages that i use CLI
    "adb"                 # | Android Debugging
    "apt-transport-https" # | Dependency - VS Code (64-Bits)
    "curl"                # | Terminal Download Manager
    "fastboot"            # | Android Debugging
    "gdebi gdebi-core"    # | CLI/GUI .deb Installer
    "git"                 # | Git
    "gparted"             # | Gparted
    "grub-customizer"     # | GRUB Customizer
    "grub-efi"            # | EFI GRUB Stuff
    "grub2-common"        # | EFI GRUB Stuff
    "htop"                # | Terminal System Monitor
    "nano"                # | Terminal Text Editor
    "neofetch"            # | Neofetch Command
    "ntfs-3g"             # | NTFS support
    "os-prober"           # | Detect Windows install
    "pavucontrol"         # | Audio Controller
    "pip"                 # | Python Module manager
    "terminator"          # | Better than Vanilla Terminal
    "ttf-dejavu"          # | Font required by ONLY Office
    "vim"                 # | Terminal Text Editor
    "wget"                # | Terminal Download Manager
    "unzip zip"           # | Compress/Extract zip files
    "zsh"                 # | Z-Shell
    # Personal GUI Packages
    "code"                 # | VS Code (64-Bits)
    "discord"              # | Discord
    "gimp"                 # | GNU Image Manipulation Program (GIMP)
    "google-chrome-stable" # | Google Chrome
    "microsoft-edge-beta"  # | Microsoft Edge (Beta)
    "obs-studio"           # | OBS Studio
    "qbittorrent"          # | qBittorrent
    "smplayer"             # | SMPlayer
    "spotify-client"       # | Spotify
    "vlc"                  # | VLC
  )

  echoSection "Installing via Advanced Package Tool (apt)..."
  for _app in ${_aptApps[@]}; do
    echoCaption "Installing: $_app"
    sudo apt install -y $_app
  done

  echo "Finishing setup of incomplete installs..."

  sudo gpasswd -a $USER plugdev

  declare -a _appsCheck=(
    "discord"                   # Discord
    "onlyoffice-desktopeditors" # ONLY Office
    "parsec"                    # Parsec
  )

  # If these packages are not found, this is the manual install
  echoSection "Installing via Advanced Package Tool (apt)..."
  for _app in ${_appsCheck[@]}; do
    if (apt list --installed | grep -i "$_app/"); then
      echo "$_app ALREADY INSTALLED, SKIPPING..."
    else
      echoCaption "Installing: $_app"
      _appName="$_app"

      # I know, SWITCH CASE THING
      echo "Installing properly $_appName..."
      if [[ "$_appName" = "discord" ]]; then
        echo "$_appName"
        # Discord
        wget -c -O ~/$_configFolder/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
        sudo gdebi -n ~/$_configFolder/discord.deb
      fi

      if [[ "$_appName" = "onlyoffice-desktopeditors" ]]; then
        echo "$_appName"
        # ONLY Office
        wget -c -O ~/$_configFolder/onlyoffice-desktopeditors_amd64.deb "http://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb"
        sudo gdebi -n ~/$_configFolder/onlyoffice-desktopeditors_amd64.deb
      fi

      if [[ "$_appName" = "parsec" ]]; then
        echo "$_appName"
        # Parsec
        wget -c -O ~/$_configFolder/parsec-linux.deb "https://builds.parsecgaming.com/package/parsec-linux.deb"
        sudo gdebi -n ~/$_configFolder/parsec-linux.deb
      fi
    fi
  done

  # NVIDIA Graphics Driver
  sudo cat /etc/X11/default-display-manager
  if (neofetch | grep -i Pop\!_OS); then # Verify if the Distro already include the NVIDIA driver, currently Pop!_OS.
    echo "OS already included Drivers on ISO, but installing if it isn't"
    sudo apt install -y system76-driver-nvidia
  else
    if [[ nvidia-smi ]]; then
      echo "NVIDIA Graphics Driver already installed...proceeding with Extras"
      sudo apt install -y ocl-icd-opencl-dev &&
        sudo apt install -y libvulkan1 libvulkan1:i386 &&
        sudo apt install -y nvidia-settings &&
        sudo apt install -y dkms build-essential linux-headers-generic
    else
      if (lspci -k | grep -i NVIDIA); then # Checking if your GPU is from NVIDIA.
        echo "Blacklisting NOUVEAU driver from NVIDIA em /etc/modprobe.d/blacklist.conf"
        sudo sh -c "echo '# Freaking NVIDIA driver that glitches every system \nblacklist nouveaublacklist lbm-nouveauoptions nouveau modeset=0alias nouveau offalias lbm-nouveau off' >> /etc/modprobe.d/blacklist.conf"

        echo "NVIDIA Graphics Driver and Extras"
        sudo add-apt-repository -y ppa:graphics-drivers/ppa &&
          sudo apt update -y &&
          sudo apt install -y nvidia-driver-470 && # 08/2021 v470 = Proprietary
          sudo apt install -y ocl-icd-opencl-dev &&
          sudo apt install -y libvulkan1 libvulkan1:i386 &&
          sudo apt install -y nvidia-settings &&
          sudo apt install -y dkms build-essential linux-headers-generic
      else
        echo "GPU different from NVIDIA"
      fi
    fi
  fi
}

function setUpGrub() {
  echoTitle "Prepare GRUB"

  sudo grub-install
  if (neofetch | grep -i Pop\!_OS); then
    # TODO translation
    sudo cp /boot/grub/x86_64-efi/grub.efi /boot/efi/EFI/pop/grubx64.efi
    echo "1) Click on the File tab > Change Environment... " >~/$_configFolder/grub.txt
    echo "2) Where is OUTPUT_FILE: '/boot/grub/grub.cfg' Switch to: " >>~/$_configFolder/grub.txt
    echo "/boot/efi/EFI/pop/grub.cfg" >>~/$_configFolder/grub.txt
    echo "3) Then check [X] Save this setting > Apply\!" >>~/$_configFolder/grub.txt
  else
    echo "Not Pop\!_OS"
  fi

  clear
  cat ~/$_configFolder/grub.txt
  sudo grub-customizer
  rm ~/$_configFolder/grub.txt
  echo "GRUB Ready!"
}

function main() {
  configEnv
  echoUbuntuScriptLogo
  sudo apt install -fy wget zip unzip # Needed to download/install fonts
  preUbuntuSetup
  installPpaKeysUbuntu
  installPackagesUbuntu
  setUpGrub
  upgradeAllUbuntu
  installFonts
  installZsh
  installOhMyZsh
}

main
