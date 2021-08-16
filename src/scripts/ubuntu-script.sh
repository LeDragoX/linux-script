#!/bin/bash

source ./../lib/base-script.sh

function installKeysUbuntu() {

  echo "- Add PPAs"

  # https://linuxhint.com/bash_loop_list_strings/
  # Declare an array of string with type

  declare -a Add_PPAs=(

    # PPA/Repo Stuff
    "ppa:danielrichter2007/grub-customizer"   # GRUB Customizer
    "ppa:obsproject/obs-studio"               # OBS Studio
    "ppa:openrazer/stable"                    # Open Razer
    "ppa:otto-kesselgulasch/gimp"             # GNU Image Manipulation Program (GIMP)
    "ppa:qbittorrent-team/qbittorrent-stable" # qBittorrent
    "ppa:rvm/smplayer"                        # SMPlayer

  )

  # Iterate the string array using for loop
  echo "Installing via Advanced Package Tool (apt)..."
  for PPA in ${Add_PPAs[@]}; do
    echo "Installing: $PPA"
    sudo add-apt-repository -y $PPA
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

  echo "- Install Apt Packages"

  sudo dpkg --add-architecture i386                                           # Enable 32-bits Architecture
  sudo DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-restricted-extras # Remove interactivity | Useful proprietary stuff

  declare -a APT_Apps=(

    # Initial Libs that i use
    "adb"                 # Android Debugging
    "apt-transport-https" # Dependency - VS Code (64-Bits)
    "curl"                # Terminal Download Manager
    "fastboot"            # Android Debugging
    "gdebi"               # CLI/GUI .deb Installer
    "gdebi-core"          # CLI/GUI .deb Installer
    "git"                 # Git
    "gparted"             # Gparted
    "grub-efi"            # EFI GRUB Stuff
    "grub2-common"        # EFI GRUB Stuff
    "grub-customizer"     # GRUB Customizer
    "htop"                # Terminal System Monitor
    "neofetch"            # Neofetch Command
    "pavucontrol"         # Audio Controller
    "terminator"          # Better than Vanilla Terminal
    "ttf-dejavu"          # Font required by ONLY Office
    "vim"                 # Terminal Text Editor
    "wget"                # Terminal Download Manager
    "zsh"                 # Z-Shell

    # Essential Libs

    "ack-grep"
    "build-essential"
    "exuberant-ctags"
    "fontconfig"
    "gcc-multilib"
    "imagemagick"
    "libmagickwand-dev"
    "libsdl2-dev"
    "libssl-dev"
    "ncurses-term"
    "silversearcher-ag"
    "software-properties-common"

    # Personal Apps

    "code"                 # VS Code (64-Bits) # or code-insiders
    "discord"              # Discord
    "gimp"                 # GNU Image Manipulation Program (GIMP)
    "google-chrome-stable" # Google Chrome
    "default-jdk"          # Latest Java Dev Kit (OpenJDK)
    "default-jre"          # Latest Java Runtime Environment (OpenJDK)
    "microsoft-edge-beta"  # Microsoft Edge (Beta)
    "obs-studio"           # OBS Studio
    "openrazer-meta"       # Open Razer (1/2)
    "pip"                  # Python manager
    "python3-pip"          # Python 3
    "qbittorrent"          # qBittorrent
    "smplayer"             # SMPlayer
    "spotify-client"       # Spotify
    "vlc"                  # VLC

  )

  echo "Installing via Advanced Package Tool (apt)..."
  for App in ${APT_Apps[@]}; do
    echo "Installing: $App "
    sudo apt install -y $App
  done

  echo "Finishing setup of incomplete installs..."

  sudo gpasswd -a $USER plugdev

  declare -a Apps_check=(
    "discord"                   # Discord
    "onlyoffice-desktopeditors" # ONLY Office
    "parsec"                    # Parsec
  )

  # If these packages are not found, this is the manual install
  echo "Installing via Advanced Package Tool (apt)..."
  for App in ${Apps_check[@]}; do
    if apt list --installed | grep -i "$App/"; then
      echo "$App ALREADY INSTALLED, SKIPPING..."
    else
      echo "Installing: $App "
      app_name="$App"

      # I know, SWITCH CASE THING
      echo "Installing properly $app_name..."
      if [ "$app_name" = "discord" ]; then
        echo "$app_name"
        # Discord
        wget -c -O ~/$config_folder/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
        sudo gdebi -n ~/$config_folder/discord.deb
      fi

      if [ "$app_name" = "onlyoffice-desktopeditors" ]; then
        echo "$app_name"
        # ONLY Office
        wget -c -O ~/$config_folder/onlyoffice-desktopeditors_amd64.deb "http://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb"
        sudo gdebi -n ~/$config_folder/onlyoffice-desktopeditors_amd64.deb
      fi

      if [ "$app_name" = "parsec" ]; then
        echo "$app_name"
        # Parsec
        wget -c -O ~/$config_folder/parsec-linux.deb "https://builds.parsecgaming.com/package/parsec-linux.deb"
        sudo gdebi -n ~/$config_folder/parsec-linux.deb
      fi

    fi
  done

  # NVIDIA Graphics Driver
  sudo cat /etc/X11/default-display-manager
  if neofetch | grep -i Pop\!_OS; then # Verify if the Distro already include the NVIDIA driver, currently Pop!_OS.
    echo "OS already included Drivers on ISO, but installing if it isn't"
    sudo apt install -y system76-driver-nvidia
  else
    if nvidia-smi; then
      echo "NVIDIA Graphics Driver already installed...proceeding with Extras"
      sudo apt install -y ocl-icd-opencl-dev &&
        sudo apt install -y libvulkan1 libvulkan1:i386 &&
        sudo apt install -y nvidia-settings &&
        sudo apt install -y dkms build-essential linux-headers-generic
    else
      if lspci -k | grep -i NVIDIA; then # Checking if your GPU is from NVIDIA.
        echo "Blacklisting NOUVEAU driver from NVIDIA em /etc/modprobe.d/blacklist.conf"
        sudo sh -c "echo '# Freaking NVIDIA driver that glitches every systemblacklist nouveaublacklist lbm-nouveauoptions nouveau modeset=0alias nouveau offalias lbm-nouveau off' >> /etc/modprobe.d/blacklist.conf"

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

  echo "- Prepare GRUB"

  sudo grub-install
  if neofetch | grep -i Pop\!_OS; then
    # TODO translation
    sudo cp /boot/grub/x86_64-efi/grub.efi /boot/efi/EFI/pop/grubx64.efi
    echo "1) Clique na aba Arquivo > Alterar ambiente... " >~/$config_folder/grub.txt
    echo "2) onde está OUTPUT_FILE: /boot/grub/grub.cfg   MUDE PARA: " >>~/$config_folder/grub.txt
    echo "/boot/efi/EFI/pop/grub.cfg============================" >>~/$config_folder/grub.txt
    echo "3) Depois marque [X] Salvar esta configuração Aplique\!" >>~/$config_folder/grub.txt
  else
    echo "Not Pop\!_OS"
  fi

  clear
  cat ~/$config_folder/grub.txt
  sudo grub-customizer
  rm ~/$config_folder/grub.txt
  echo "GRUB Ready!"

}

function installSvp() {

  echo "- SVP Install"

  clear
  echo "SVP"
  svp_installer=$script_folder/src/scripts/install-svp.sh
  svp_folder=ConfigSVP
  if [ -f "$svp_installer" ]; then
    echo "$svp_installer EXISTS.Continuing..."
    mkdir --parents ~/$svp_folder
    cp "$svp_installer" ~/$svp_folder
    pushd ~/$svp_folder
    sudo su cd ~/$svp_folder/ &
    ./install-svp.sh
    popd
  else
    echo "$svp_installer DOES NOT EXIST."
  fi

  # Reinitialize variables
  initVariables

  # For some reason it gets out from this directory after installing SVP
  mkdir --parents ~/$config_folder
  cd ~/$config_folder

}

function installGnomeExt() {

  echo "- Install useful GNOME Extensions"

  echo "Install GNOME Extensions, only if the Distro's DE is GNOME"

  clear
  if gnome-shell --version; then # Used to verify if you're using the GNOME DE
    echo "Gnome Tweak Tool"
    sudo apt install -y gnome-tweak-tool
    echo "Gnome Shell Extensions"
    sudo apt install -y gnome-shell-extensions gnome-menus gir1.2-gmenu-3.0
    echo "Chrome Gnome Shell (Needs Chromium-based browser)"
    sudo apt install -y chrome-gnome-shell
    echo "Allows the Extension, refresh the page and click ON"
    $default_browser https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep?hl=pt-BR https://extensions.gnome.org/extension/1160/dash-to-panel/ https://extensions.gnome.org/extension/906/sound-output-device-chooser/ https://extensions.gnome.org/extension/1625/soft-brightness/ https://extensions.gnome.org/extension/750/openweather/ https://extensions.gnome.org/extension/7/removable-drive-menu/
  else
    echo "GNOME DOESN'T EXIST"
  fi

}

function main() {

  initVariables
  sudo apt install -fy wget zip unzip # Needed to download/install fonts
  configEnv

  fixPackagesUbuntu
  installKeysUbuntu
  installPackagesUbuntu
  installSvp
  setUpGrub
  installGnomeExt
  updateAllPackagesUbuntu

  installZsh
  configGit
}

main
