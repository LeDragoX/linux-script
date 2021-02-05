#!/bin/bash

function init_variables {

    # Initialize Global variables

    clear
    app_num=0
    total_apps=37

    wait_time=7
    script_folder=$(pwd)
    config_folder="PKGSConfig"

        echo "    app_num = $app_num
    total_apps = $total_apps
    wait_time = $wait_time
    script_folder = $script_folder
    config_folder = $config_folder"

    echo ""
    read -t $wait_time -p "Waiting $wait_time seconds only ..."
    echo ""

}

function superEcho {
    echo ""
    echo "<==================== $1 ====================>"
    echo ""
    echo ""
}

function installCounter {
    superEcho "( $((app_num+=1))/$total_apps ) Installing: [$1]"
}

function InstallPackages {

    clear
    # To allow comments using # on Zsh terminal | Temporary Workaround
    setopt interactivecomments

    # 1 - Preparing

    # Everything must happen on this directory
    mkdir ~/$config_folder
    cd ~/$config_folder
    # Making folders for Custom Themes
    mkdir ~/.icons

    timedatectl set-local-rtc 1 # Using Local time (Dualboot with Windows)
    #sudo timedatectl set-timezone UTC # Using UTC

    # 2 - Fix currently installed Packages

    printf "[Adapted] Ubuntu fix broken packages (best solution)\n"
    sudo apt update -y --fix-missing
    sudo dpkg --configure -a            # Attempts to fix problems with broken dependencies between program packages.
    sudo apt-get --fix-broken install

    # 3 - Add PPAs

    # Add Manual first

    # Google Chrome
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'

    # Spotify
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add -
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

    # VS Code (64-Bits)
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    # Wine
    wget -nc https://dl.winehq.org/wine-builds/winehq.key # Release.key is old, winehq.key is the new repository
    sudo apt-key add winehq.key
    sudo add-apt-repository -y 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' # DANGEROUS LINE? | Ubuntu Focal = 20.04

    # Fix Bugged key
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key 76F1A20FF987672F

    # https://linuxhint.com/bash_loop_list_strings/
    # Declare an array of string with type

    declare -a Add_PPAs=(

        # PPA/Repo Stuff

        "ppa:danielrichter2007/grub-customizer"     # GRUB Customizer
        "ppa:lutris-team/lutris"                    # Lutris
        "ppa:obsproject/obs-studio"                 # OBS Studio
        "ppa:openrazer/stable"                      # Open Razer
        "ppa:otto-kesselgulasch/gimp"               # GNU Image Manipulation Program (GIMP)
        "ppa:qbittorrent-team/qbittorrent-stable"   # qBittorrent
        "ppa:rvm/smplayer"                          # SMPlayer

    )

    # Iterate the string array using for loop
    printf "\nInstalling via Advanced Package Tool (apt)...\n"
    for PPA in ${Add_PPAs[@]}; do
        printf "\nInstalling: $PPA \n"
        sudo add-apt-repository -y $PPA
        sudo apt update -y
    done

    # 4 - Install Apt Packages

    sudo dpkg --add-architecture i386                                               # Enable 32-bits Architecture
    sudo DEBIAN_FRONTEND=noninteractive apt install -fy ubuntu-restricted-extras    # Remove interactivity | Useful proprietary stuff

    declare -a APT_Apps=(

        # Initial Libs that i use

        "adb"                       # Android Debugging
        "android-tools-adb"         # Android Debugging
        "android-tools-fastboot"    # Android Debugging
        "apt-transport-https"       # Dependency - VS Code (64-Bits)
        "curl"                      # Terminal Download Manager
        "gdebi"                     # CLI/GUI .deb Installer
        "gdebi-core"                # CLI/GUI .deb Installer
        "git"                       # Git
        "gparted"                   # Gparted
        "grub-efi"                  # EFI GRUB Stuff
        "grub2-common"              # EFI GRUB Stuff
        "grub-customizer"           # GRUB Customizer
        "htop"                      # Terminal System Monitor
        "neofetch"                  # Neofetch Command
        "pavucontrol"               # Audio Controller
        "terminator"                # Better than Vanilla Terminal
        "ttf-dejavu"                # Font required by ONLY Office
        "vim"                       # Terminal Text Editor
        "wget"                      # Terminal Download Manager

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

        "code"                              # VS Code (64-Bits) # or code-insiders
        "discord"                           # Discord
        "gimp"                              # GNU Image Manipulation Program (GIMP)
        "google-chrome-stable"              # Google Chrome
        "default-jdk"                       # Latest Java Dev Kit (OpenJDK)
        "default-jre"                       # Latest Java Runtime Environment (OpenJDK)
        "lutris"                            # Lutris
        "obs-studio"                        # OBS Studio
        "openrazer-meta"                    # Open Razer (1/2)
        "python-minimal"                    # Python 3
        "python3-minimal"                   # Python 3
        "python3"                           # Python 3
        "python3-pip"                       # Python 3
        "python-pip"                        # Python 3
        "qbittorrent"                       # qBittorrent
        "smplayer"                          # SMPlayer
        "steam"                             # Steam
        "spotify-client"                    # Spotify
        "--install-recommends winehq-devel" # Wine
        "winetricks"                        # WineTricks
        "vlc"                               # VLC
        
    )

    printf "\nInstalling via Advanced Package Tool (apt)...\n"
    for App in ${APT_Apps[@]}; do
        printf "\nInstalling: $App \n"
        sudo apt install -fy $App
    done

    # Finishing setup of incomplete installs

    sudo gpasswd -a $USER plugdev

    # If these are not found, this is the manual install

    # Discord
    wget -c -O ~/$config_folder/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    sudo gdebi -n ~/$config_folder/discord.deb

    # ONLY Office
    wget -c -O ~/$config_folder/onlyoffice-desktopeditors_amd64.deb "http://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb"
    sudo gdebi -n ~/$config_folder/onlyoffice-desktopeditors_amd64.deb

    # Parsec
    wget -c -O ~/$config_folder/parsec-linux.deb "https://builds.parsecgaming.com/package/parsec-linux.deb"
    sudo gdebi -n ~/$config_folder/parsec-linux.deb

    # Steam
    if apt list --installed | grep steam then
        printf "STEAM ALREADY INSTALLED\n"
    else    # If the 1st attempt was not Successful
        sudo add-apt-repository -y multiverse
        sudo apt update -y && sudo apt install steam

        if apt list --installed | grep steam then   # Neither the 2nd attempt
            wget -c -O ~/$config_folder/steam.deb 'http://media.steampowered.com/client/installer/steam.deb'
            sudo gdebi -n ~/$config_folder/steam.deb
        fi
    fi

    # WineTricks setup
    winetricks -q corefonts dinput xinput directplay dxvk d3dx9 d3dx10 d3dcompiler_43 vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013
    winetricks -q vcrun2019 # Only recognises if vcrun2015 was not installed # includes: 2015, 2017 and 2019.
    # winetricks -q allcodecs # Strange bugs on XFCE
    # winetricks -q dotnet35 #dotnet40 #dotnet45 #dotnet46 #dotnet48 # ERROR

    # NVIDIA Graphics Driver
    sudo cat /etc/X11/default-display-manager
    if neofetch | grep -i Pop\!_OS then # Verify if the Distro already include the NVIDIA driver, currently Pop!_OS.
        printf "\nOS already included Drivers on ISO\n"
    else
        if nvidia-smi then 
            printf "\nNVIDIA Graphics Driver already installed...proceeding with Extras\n"
            sudo apt install -fy ocl-icd-opencl-dev &&
            sudo apt install -fy libvulkan1 libvulkan1:i386 &&
            sudo apt install -fy nvidia-settings && 
            sudo apt install -fy dkms build-essential linux-headers-generic
        else
            if lspci -k | grep -i NVIDIA then   # Checking if your GPU is from NVIDIA.
                printf "Blacklisting NOUVEAU driver from NVIDIA em /etc/modprobe.d/blacklist.conf\n"
                sudo sh -c "printf '\n\n# Freaking NVIDIA driver that glitches every system\nblacklist nouveau\nblacklist lbm-nouveau\noptions nouveau modeset=0\nalias nouveau off\nalias lbm-nouveau off' >> /etc/modprobe.d/blacklist.conf"
                
                installCounter "NVIDIA Graphics Driver and Extras"
                sudo add-apt-repository -y ppa:graphics-drivers/ppa &&
                sudo apt update -y &&
                sudo apt install -fy nvidia-driver-460 &&   # 01/2021 v460.xx = Proprietary
                sudo apt install -fy ocl-icd-opencl-dev &&
                sudo apt install -fy libvulkan1 libvulkan1:i386 &&
                sudo apt install -fy nvidia-settings && 
                sudo apt install -fy dkms build-essential linux-headers-generic
            else
                printf "\nGPU different from NVIDIA\n"
            fi
        fi
    fi

    # 5 - Update System

    sudo apt update -y
    sudo apt dist-upgrade -fy
    sudo apt autoclean -y  # limpa seu repositório local de todos os pacotes que o APT baixou.
    sudo apt autoremove -y # remove dependências que não são mais necessárias ao seu Sistema.

    # 6 - Reboot

    reboot

}

init_variables
InstallPackages

clear
installCounter "Preparing GRUB..."
sudo grub-install
if neofetch | grep -i Pop\!_OS
then    # TODO translate
    sudo cp /boot/grub/x86_64-efi/grub.efi /boot/efi/EFI/pop/grubx64.efi
    printf "1) Clique na aba Arquivo > Alterar ambiente... \n\n" > ~/$config_folder/grub.txt
    printf "2) onde está OUTPUT_FILE: \n/boot/grub/grub.cfg\n   MUDE PARA: \n" >> ~/$config_folder/grub.txt
    printf "/boot/efi/EFI/pop/grub.cfg\n============================\n\n" >> ~/$config_folder/grub.txt
    printf "3) Depois marque \n[X] Salvar esta configuração \nAplique\!\n" >> ~/$config_folder/grub.txt
else
    printf "\nNot Pop\!_OS\n"
fi

clear
cat ~/$config_folder/grub.txt
sudo grub-customizer
rm ~/$config_folder/grub.txt
superEcho "GRUB Ready!"

clear
installCounter "SVP"
svp_installer=$script_folder/install-svp.sh
svp_folder=ConfigSVP
if [ -f "$svp_installer" ]; 
    then
        printf "$svp_installer EXISTS.\nContinuing...\n"
        mkdir ~/$svp_folder
        cp "$svp_installer" ~/$svp_folder
        pushd ~/$svp_folder
        sudo su cd ~/$svp_folder/ & ./install-svp.sh
	    popd
    else 
        printf "$svp_installer DOES NOT EXIST.\n"
fi

# Reinitialize variables
init_variables 

# For some reason it gets out from this directory after installing SVP
mkdir ~/$config_folder
cd ~/$config_folder

clear
if gnome-shell --version    # Used to verify if you're using the GNOME DE
    then
        installCounter "Gnome Tweak Tool (Only if the Distro's UI is GNOME)"
        sudo apt install -fy gnome-tweak-tool
        installCounter "Gnome Shell Extensions"
        sudo apt install -fy gnome-shell-extensions gnome-menus gir1.2-gmenu-3.0
        installCounter "Chrome Gnome Shell (Needs Google Chrome)"
        sudo apt install -fy chrome-gnome-shell
        superEcho "Allows the Extension, refresh the page and click ON"
        google-chrome https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep?hl=pt-BR https://extensions.gnome.org/extension/1160/dash-to-panel/ https://extensions.gnome.org/extension/906/sound-output-device-chooser/ https://extensions.gnome.org/extension/1625/soft-brightness/ https://extensions.gnome.org/extension/750/openweather/ https://extensions.gnome.org/extension/7/removable-drive-menu/
    else
        printf "\nGNOME DOESN'T EXIST\n"
fi
# TODO translate
#
#
clear
printf "\n\n============== Adicionando informações ao leia-me.txt ==============\n\n"
printf "\n============== CONFIGURAÇÕES MANUAIS (INFELIZMENTE) ==============\n" > ~/Downloads/leia-me.txt

printf "\n============== CONFIGURAÇÕES SVP ==============\n\n" >> ~/Downloads/leia-me.txt
printf "1) Abra o SVP\n" >> ~/Downloads/leia-me.txt
printf "2) Clique no ícone no canto superior esquerdo\n" >> ~/Downloads/leia-me.txt
printf "3) Vá em Configuraçẽos do Programa\n" >> ~/Downloads/leia-me.txt
printf "4) [x] Minimize to Tray (Marcar)\n\n" >> ~/Downloads/leia-me.txt

printf "Torne o aplicativos padrão de vídeo para SMPlayer (só funcionou por ele)\n" >> ~/Downloads/leia-me.txt
printf "0) Vá em Configurações > Detalhes > Aplicativos Padrão > Vídeo e Selecione o SMPlayer\n\n" >> ~/Downloads/leia-me.txt

printf "1) Agora abra o SMPlayer (pode ser outro player em outras distros)\n" >> ~/Downloads/leia-me.txt
printf "2) Vai na aba Opções > Preferências > sub-aba 'Vídeo'\n" >> ~/Downloads/leia-me.txt
printf "3) Marque: \n[x] Iniciar vídeos em modo de tela cheia'\n\n" >> ~/Downloads/leia-me.txt

printf "4) Agora vá na aba 'Avançado' > MPlayer/mpv\n" >> ~/Downloads/leia-me.txt
printf "5) Em 'Opções:' coloque\n" >> ~/Downloads/leia-me.txt
printf "6) --input-ipc-server=/tmp/mpvsocket\n" >> ~/Downloads/leia-me.txt
printf "7) Aplica e tem mais.\n" >> ~/Downloads/leia-me.txt
printf "8) Vá na aba INTERFACE e faça as seguintes mudanças:\n\n" >> ~/Downloads/leia-me.txt
printf "9) \nIdioma: <Idioma do Sistema> \nGUI: Inferface Personalizável \nSkin: Modern \nEstilo: GTK+\n\n" >> ~/Downloads/leia-me.txt
printf "10) Aplica e tem mais.\n" >> ~/Downloads/leia-me.txt
printf "11) Vá na aba TECLADO E MOUSE > Mouse\n" >> ~/Downloads/leia-me.txt
printf "12) Em Funções do botão:\n\n" >> ~/Downloads/leia-me.txt
printf "13) \nClique esquerdo: Pausa \nDuplo Clique: Tela cheia \nClique direito: Mostrar menu de contexto \nClique no meio: Silenciar \n\nFunções da roda do mouse: Controlar volume\n" >> ~/Downloads/leia-me.txt
printf "14) Dê OK\n" >> ~/Downloads/leia-me.txt
printf "Foi esse que pegou no Pop\!_OS 20.04.\n" >> ~/Downloads/leia-me.txt

printf "\n============== CONFIGURAÇÕES Google Chrome ==============\n\n" >> ~/Downloads/leia-me.txt
printf "Ir para Configurações > Avançado > Sistema\n" >> ~/Downloads/leia-me.txt
printf "[OFF] Executar aplicativos em SEGUNDO PLANO quando o Google Chrome estiver fechado\n" >> ~/Downloads/leia-me.txt
#
#
#
rm ~/$config_folder/grub.txt
xdg-open ~/Downloads/leia-me.txt && exit
