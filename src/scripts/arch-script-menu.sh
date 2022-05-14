#!/usr/bin/env bash

source ./src/lib/arch-base-script.sh
source ./src/lib/base-script.sh

function mainMenu() {
  echoArchScriptLogo
  PS3="Select an option: "
  select option in "Exit" "[REBOOT] Install Package Managers (Yay, Snap and Flatpak)" "Install Desktop Environment (Menu)" "Install all Arch Packages (Requires package managers)" "Post Configurations (Workflow)" "Install SVP (Convert video FPS to 60+)" "[WSL] ArchWSL setup Root and User" "[WSL] Finish ArchWSL installation"; do
    echo "You chose to $option"
    case $option in
    "Exit")
      clear
      echo "Exiting..." && echo
      break
      ;;
    "[REBOOT] Install Package Managers (Yay, Snap and Flatpak)")
      clear
      installPackageManagers

      waitPrompt
      mainMenu
      ;;
    "Install Desktop Environment (Menu)")
      clear
      installDE

      waitPrompt
      mainMenu
      ;;
    "Install all Arch Packages (Requires package managers)")
      clear
      installPackagesArch

      waitPrompt
      mainMenu
      ;;
    "Post Configurations (Workflow)")
      clear
      configureBootAndGraphicsDriver
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
    "[WSL] ArchWSL setup Root and User")
      clear
      echoWSLArchScriptLogo
      archWslSetupAccounts

      waitPrompt
      mainMenu
      ;;
    "[WSL] Finish ArchWSL installation")
      clear
      echoWSLArchScriptLogo
      preArchSetup
      installPackagesArchWsl
      installPackageManagers
      installFonts
      installZsh
      installOhMyZsh

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

function archWslSetupAccounts() {
  _currentUser=$(id -u)
  if [[ "$_currentUser" -ne 0 ]]; then
    echoError "Please run as root user!"
    exit 1
  fi

  echoSection 'New ROOT Password'
  passwd 'root'
  echo "%wheel ALL=(ALL) ALL" >/etc/sudoers.d/wheel

  echoSection 'New USER account'

  read -r -p "Input your user name: " _userName
  useradd -m -G wheel -s /bin/bash $_userName
  echo "Now set a password for $_userName..."
  passwd $_userName

  echoError "!!! IMPORTANT (ArchWSL) !!!"
  echo "To set the new Default user to $_userName..."
  echo "Copy the follow command on the Powershell:" && echo
  echo "Arch.exe config --default-user $_userName" && echo
  echo "At the end close the terminal"
}

function configureBootAndGraphicsDriver() {
  echoTitle "Post Script Setup For Desktop"

  echoCaption "Help GRUB detect Windows installs..."
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

function disableLoginManagers() {
  echoCaption "Disabling all Login Managers before enabling another..."

  sudo systemctl disable gdm
  sudo systemctl disable lightdm
  sudo systemctl disable sddm
}

function installDE() {
  installPackage "xorg" # | XOrg & XOrg Server |

  PS3="Select the Desktop Environment (1 to skip): "
  select _desktopEnv in "None" "KDE Plasma (Minimal)" "Gnome (Minimal)" "XFCE (Minimal)"; do
    echo "You chose the $_desktopEnv"
    case $_desktopEnv in
    "None (Skip)")
      echoCaption "Skipping..."
      break
      ;;
    "KDE Plasma (Minimal)")
      echoSection "Installing $_desktopEnv"
      # | SDDM Login Manager | Pure KDE Plasma | Wayland Session for KDE | KDE file manager | KDE screenshot tool
      installPackage "sddm plasma plasma-wayland-session dolphin spectacle"
      disableLoginManagers

      echoCaption "Setting sudo systemctl enable sddm..."
      sudo systemctl enable sddm
      ;;
    "Gnome (Minimal)")
      echoSection "Installing $_desktopEnv"
      # | GDM Login Manager | Pure Gnome |
      installPackage "gdm gnome"
      disableLoginManagers

      echo "Setting sudo systemctl enable gdm"
      sudo systemctl enable gdm
      ;;
    "XFCE (Minimal)")
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
      installDE
      break
      ;;
    esac
    break
  done
}

function installPackagesArch() {
  # | Adobe Asian Fonts (CN, JP, KR, TW)          | AMD CPU Microcode               | Discord
  # | Gimp                                        | Git    ScrCpy                   | Gparted
  # | GRUB Customizer (Conflict ERROR on Manjaro) | Htop: Terminal System Monitor   | man-db: Manual utility
  # | man-pages: System commands manual (English) | Nano: Console text editor       | Neofetch command
  # | Emoji Support                               | ntfs-3g: NTFS support           | OBS Studio
  # | OS Prober: Detect Windows install           | Audio Controller                | Python Module manager
  # | qBittorrent                                 | Android ScrCpy                  | SMPlayer
  # | Steam                                       | steam-native-runtime: Fix Steam | Terminator
  # | Vim: Console text editor                    | VLC
  local _archPacmanApps="adobe-source-han-sans-otc-fonts amd-ucode discord
  gimp git gparted
  grub-customizer htop man-db
  man-pages nano neofetch
  noto-fonts-emoji ntfs-3g obs-studio
  os-prober pavucontrol python-pip
  qbittorrent scrcpy smplayer
  steam steam-native-runtime terminator
  vim vlc"

  echoSection "Installing via Pacman"
  echo "$_archPacmanApps"
  installPackage "$_archPacmanApps"

  # | Microsoft Edge  | Parsec | RAR/ZIP Manager GUI
  # | Spotify adblock | Google Chrome (Optional)
  local _archAurApps="microsoft-edge-stable-bin parsec-bin peazip-qt5-bin spotify-adblock-git" #google-chrome"

  echoTitle "Installing via Yay (AUR)"
  installPackage "$_archAurApps" "yay -S --needed --noconfirm"

  # ONLY Office
  _archSnapApps="onlyoffice-desktopeditors"

  echoTitle "Installing via Snap"
  installPackage "$_archSnapApps" "sudo snap install"

  echoSection "Snap Manual installations"
  sudo snap install code --classic  # VS Code (or code-insiders)
  sudo snap install slack --classic # Slack

  # N/A
  declare -a _archFlatpakApps=""

  echoSection "Installing via Flatpak"
  installPackage "$_archFlatpakApps" "flatpak --noninteractive --user install flathub"
}

function installPackagesArchWsl() {
  # Required To compilation proccesses | The parameter to ignore fakeroot is avoid an install bug on WSL |
  local _archPacmanApps="base-devel gcc man-db man-pages"

  echoSection "Installing via Pacman"
  echo "$_archPacmanApps"
  installPackage "$_archPacmanApps" "sudo pacman -S --needed --noconfirm --ignore=fakeroot"
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
