#!/bin/sh

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

  # AMD CPU Microcode # yay Dependency # Discord Canary # Flatpak Package Manager
  # Gimp # Git # Fixes keyring bug on VSCode (https://github.com/microsoft/vscode/issues/92972#issuecomment-625751232) # Gparted
  # GRUB Customizer (Conflict ERROR on Manjaro) # Sound for Wine # SVP Dependency # SVP Dependency
  # Terminal System Monitor # Console text editor # Neofetch command # Emoji Support
  # NTFS support (Windows Dualboot) # Turn Num Lock On, at least this time # OBS Studio # Detect Windows install
  # Audio Controller # Python Module manager # qBittorrent # SVP Dependency
  # SVP Dependency # SVP Dependency # Android ScrCpy # SMPlayer
  # Steam # Fix Steam GUI # Terminator # SVP Dependency
  # Console text editor # VLC # Z-Shell
  pacman_apps="amd-ucode base-devel discord-canary flatpak gimp git gnome-keyring gparted grub-customizer lib32-libpulse libmediainfo lsof htop nano neofetch noto-fonts-emoji ntfs-3g numlockx obs-studio os-prober pavucontrol python-pip qbittorrent qt5-base qt5-declarative qt5-svg scrcpy smplayer steam steam-native-runtime terminator vapoursynth vim vlc zsh"

  echoSection "Installing via Pacman"
  echo "$pacman_apps"
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

  # Microsoft Edge # Parsec # RAR/ZIP Manager GUI # SVP Dependency
  # SVP Dependency # Spotify adblock # SVP 4 Linux (AUR)
  # Google Chrome (Will make itself default when installed) # Full MPV working with SVP
  aur_apps="microsoft-edge-stable-bin parsec-bin peazip-qt5-bin rsound spirv-cross spotify-adblock-git svp" #google-chrome" #mpv-full"

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

  # ONLY Office
  snap_apps="onlyoffice-desktopeditors"

  echoTitle "Installing via Snap"
  installPackage "$snap_apps" "sudo snap install"

  echoSection "Snap Manual installations"
  sudo snap install code --classic  # VS Code (or code-insiders)
  sudo snap install slack --classic # Slack

  echoTitle "Enabling Flatpak repository"
  flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

  # Native Steam is better
  declare -a flatpak_apps=""

  echoSection "Installing via Flatpak"
  installPackage "$flatpak_apps" "flatpak --noninteractive --user install flathub"

}

function installPackage() {

  local apps="$1"
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
  #configEnv

  installPackagesArch
  postConfigs

  installZsh
  configGit

}

main
