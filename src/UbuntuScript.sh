#!/bin/bash

function initVariables {

    # Initialize Global variables

    clear
    app_num=0
    total_apps=37

    default_browser="microsoft-edge"
    config_folder=".config"
    script_folder=$(pwd)
    wait_time=7

    echo "
    app_num         = $app_num
    total_apps      = $total_apps
    default_browser = $default_browser
    config_folder   = $config_folder
    script_folder   = $script_folder
    wait_time       = $wait_time
    "

    echo ""
    read -t $wait_time -p "Waiting $wait_time seconds only ..."
    echo ""

}

function superEcho {
    echo ""
    echo "<==================== $1 ====================>"
    echo ""
}

function installCounter {
    superEcho "( $((app_num += 1))/$total_apps ) Installing: [$1]"
}

function setUpEnv {

    clear
    echo "To allow comments using on Zsh terminal | Temporary Workaround"
    setopt interactivecomments

    # 1 - Preparing the files location

    mkdir --parents ~/$config_folder
    cd ~/$config_folder

    # Making folders for Custom Themes
    mkdir --parents ~/.icons

    timedatectl set-local-rtc 1 # Using Local time (Dualboot with Windows)
    #sudo timedatectl set-timezone UTC # Using UTC

    # 2 - Fix currently installed Packages

    printf "[Adapted] Ubuntu fix broken packages (best solution)\n"
    sudo apt update -y --fix-missing
    sudo dpkg --configure -a # Attempts to fix problems with broken dependencies between program packages.
    sudo apt-get --fix-broken install

}

function setUpGit {
    # 3 - Set Up Git Commits Signature (Verified)

    # Install Git first
    sudo apt install -fy git
    # Use variables to make life easier
    git_user_name=$(git config --global user.name)
    git_user_email=$(git config --global user.email)

    ssh_path=~/.ssh
    ssh_enc_type=ed25519
    ssh_file=id_$ssh_enc_type

    mkdir --parents "$ssh_path"
    pushd "$ssh_path"
    if [ -f "$ssh_path/$ssh_file" ]; then
        print "$ssh_path/$ssh_file Exists"
    else
        print "$ssh_path/$ssh_file Not Exists | Creating..."
        print "Using your email from git to create a SSH Key: $git_user_email"
        # Generate a new ssh key, passing every parameter as variables (Make sure to config git first)
        ssh-keygen -t $ssh_enc_type -C "$git_user_email" -f "$ssh_path/$ssh_file"

        # Check if ssh-agent is running before adding
        eval "$(ssh-agent -s)"

        # Add your private key
        ssh-add "$ssh_path/$ssh_file"

        # If you want to save your passphrase (Dangerous)
        #echo "tottaly_secret_passphrase" >> $ssh_path/ssh_passphrase.txt
    fi
    popd

    mkdir --parents "~/.gnupg"
    pushd ~/.gnupg
    # Import GPG keys
    gpg --import *.gpg
    # Get the exact key ID from the system
    # Code adapted from: https://stackoverflow.com/a/66242583        # My key name
    key_id=$(gpg --list-signatures --with-colons | grep 'sig' | grep "$git_user_email" | head -n 1 | cut -d':' -f5)
    git config --global user.signingkey $key_id
    # Always commit with GPG signature
    git config --global commit.gpgsign true
    popd
}

function installKeys {

    # 4 - Add PPAs

    # https://linuxhint.com/bash_loop_list_strings/
    # Declare an array of string with type

    declare -a Add_PPAs=(

        # PPA/Repo Stuff

        "ppa:danielrichter2007/grub-customizer"   # GRUB Customizer
        "ppa:lutris-team/lutris"                  # Lutris
        "ppa:obsproject/obs-studio"               # OBS Studio
        "ppa:openrazer/stable"                    # Open Razer
        "ppa:otto-kesselgulasch/gimp"             # GNU Image Manipulation Program (GIMP)
        "ppa:qbittorrent-team/qbittorrent-stable" # qBittorrent
        "ppa:rvm/smplayer"                        # SMPlayer

    )

    # Iterate the string array using for loop
    printf "\nInstalling via Advanced Package Tool (apt)...\n"
    for PPA in ${Add_PPAs[@]}; do
        printf "\nInstalling: $PPA \n"
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

function installPackages {

    # 5 - Install Apt Packages

    sudo dpkg --add-architecture i386                                            # Enable 32-bits Architecture
    sudo DEBIAN_FRONTEND=noninteractive apt install -fy ubuntu-restricted-extras # Remove interactivity | Useful proprietary stuff

    declare -a APT_Apps=(

        # Initial Libs that i use

        "adb"                 # Android Debugging
        "apt-transport-https" # Dependency - VS Code (64-Bits)
        "curl"                # Terminal Download Manager
        "fastboot"            # Android Debugging
        "gdebi"               # CLI/GUI .deb Installer
        "gdebi-core"          # CLI/GUI .deb Installer
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
        "python3"              # Python 3
        "qbittorrent"          # qBittorrent
        "smplayer"             # SMPlayer
        "spotify-client"       # Spotify
        "vlc"                  # VLC

    )

    printf "\nInstalling via Advanced Package Tool (apt)...\n"
    for App in ${APT_Apps[@]}; do
        printf "\nInstalling: $App \n"
        sudo apt install -fy $App
    done

    printf "\nFinishing setup of incomplete installs...\n"

    sudo gpasswd -a $USER plugdev

    declare -a Apps_check=(
        "discord"                   # Discord
        "onlyoffice-desktopeditors" # ONLY Office
        "parsec"                    # Parsec
    )

    # If these packages are not found, this is the manual install
    printf "\nInstalling via Advanced Package Tool (apt)...\n"
    for App in ${Apps_check[@]}; do
        if apt list --installed | grep -i "$App/"; then
            printf "$App ALREADY INSTALLED, SKIPPING...\n"
        else
            printf "\nInstalling: $App \n"
            app_name="$App"

            # I know, SWITCH CASE THING
            printf "\nInstalling properly $app_name...\n"
            if [ "$app_name" = "discord" ]; then
                printf "$app_name\n"
                # Discord
                wget -c -O ~/$config_folder/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
                sudo gdebi -n ~/$config_folder/discord.deb
            fi

            if [ "$app_name" = "onlyoffice-desktopeditors" ]; then
                printf "$app_name\n"
                # ONLY Office
                wget -c -O ~/$config_folder/onlyoffice-desktopeditors_amd64.deb "http://download.onlyoffice.com/install/desktop/editors/linux/onlyoffice-desktopeditors_amd64.deb"
                sudo gdebi -n ~/$config_folder/onlyoffice-desktopeditors_amd64.deb
            fi

            if [ "$app_name" = "parsec" ]; then
                printf "$app_name\n"
                # Parsec
                wget -c -O ~/$config_folder/parsec-linux.deb "https://builds.parsecgaming.com/package/parsec-linux.deb"
                sudo gdebi -n ~/$config_folder/parsec-linux.deb
            fi

        fi
    done

    # NVIDIA Graphics Driver
    sudo cat /etc/X11/default-display-manager
    if neofetch | grep -i Pop\!_OS; then # Verify if the Distro already include the NVIDIA driver, currently Pop!_OS.
        printf "\nOS already included Drivers on ISO\n"
    else
        if nvidia-smi; then
            printf "\nNVIDIA Graphics Driver already installed...proceeding with Extras\n"
            sudo apt install -fy ocl-icd-opencl-dev &&
                sudo apt install -fy libvulkan1 libvulkan1:i386 &&
                sudo apt install -fy nvidia-settings &&
                sudo apt install -fy dkms build-essential linux-headers-generic
        else
            if lspci -k | grep -i NVIDIA; then # Checking if your GPU is from NVIDIA.
                printf "Blacklisting NOUVEAU driver from NVIDIA em /etc/modprobe.d/blacklist.conf\n"
                sudo sh -c "printf '\n\n# Freaking NVIDIA driver that glitches every system\nblacklist nouveau\nblacklist lbm-nouveau\noptions nouveau modeset=0\nalias nouveau off\nalias lbm-nouveau off' >> /etc/modprobe.d/blacklist.conf"

                installCounter "NVIDIA Graphics Driver and Extras"
                sudo add-apt-repository -y ppa:graphics-drivers/ppa &&
                    sudo apt update -y &&
                    sudo apt install -fy nvidia-driver-465 && # 06/2021 v460.xx = Proprietary
                    sudo apt install -fy ocl-icd-opencl-dev &&
                    sudo apt install -fy libvulkan1 libvulkan1:i386 &&
                    sudo apt install -fy nvidia-settings &&
                    sudo apt install -fy dkms build-essential linux-headers-generic
            else
                printf "\nGPU different from NVIDIA\n"
            fi
        fi
    fi

}

function installZsh {

    # 6 - Install Zsh

    printf "Zsh install\n"
    sudo apt install -fy zsh
    printf "Make Zsh the default shell\n"
    chsh -s $(which zsh)
    $SHELL --version

    printf "Needs to log out and log in to make the changes\n"
    echo $SHELL

    printf "Oh My Zsh\n"
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

}

function setUpGrub {

    # 7 - Prepare GRUB

    clear
    installCounter "Preparing GRUB..."
    sudo grub-install
    if neofetch | grep -i Pop\!_OS; then
        # TODO translation
        sudo cp /boot/grub/x86_64-efi/grub.efi /boot/efi/EFI/pop/grubx64.efi
        printf "1) Clique na aba Arquivo > Alterar ambiente... \n\n" >~/$config_folder/grub.txt
        printf "2) onde está OUTPUT_FILE: \n/boot/grub/grub.cfg\n   MUDE PARA: \n" >>~/$config_folder/grub.txt
        printf "/boot/efi/EFI/pop/grub.cfg\n============================\n\n" >>~/$config_folder/grub.txt
        printf "3) Depois marque \n[X] Salvar esta configuração \nAplique\!\n" >>~/$config_folder/grub.txt
    else
        printf "\nNot Pop\!_OS\n"
    fi

    clear
    cat ~/$config_folder/grub.txt
    sudo grub-customizer
    rm ~/$config_folder/grub.txt
    superEcho "GRUB Ready!"

}

function installSvp {

    # 8 - SVP Install

    clear
    installCounter "SVP"
    svp_installer=$script_folder/install-svp.sh
    svp_folder=ConfigSVP
    if [ -f "$svp_installer" ]; then
        printf "$svp_installer EXISTS.\nContinuing...\n"
        mkdir --parents ~/$svp_folder
        cp "$svp_installer" ~/$svp_folder
        pushd ~/$svp_folder
        sudo su cd ~/$svp_folder/ &
        ./install-svp.sh
        popd
    else
        printf "$svp_installer DOES NOT EXIST.\n"
    fi

    # Reinitialize variables
    initVariables

    # For some reason it gets out from this directory after installing SVP
    mkdir --parents ~/$config_folder
    cd ~/$config_folder

}

function installGnomeExt {

    # 9 - GNOME useful Extensions

    printf "\nInstall GNOME Extensions, only if the Distro's DE is GNOME\n"

    clear
    if gnome-shell --version; then # Used to verify if you're using the GNOME DE
        installCounter "Gnome Tweak Tool"
        sudo apt install -fy gnome-tweak-tool
        installCounter "Gnome Shell Extensions"
        sudo apt install -fy gnome-shell-extensions gnome-menus gir1.2-gmenu-3.0
        installCounter "Chrome Gnome Shell (Needs Chromium-based browser)"
        sudo apt install -fy chrome-gnome-shell
        superEcho "Allows the Extension, refresh the page and click ON"
        $default_browser https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep?hl=pt-BR https://extensions.gnome.org/extension/1160/dash-to-panel/ https://extensions.gnome.org/extension/906/sound-output-device-chooser/ https://extensions.gnome.org/extension/1625/soft-brightness/ https://extensions.gnome.org/extension/750/openweather/ https://extensions.gnome.org/extension/7/removable-drive-menu/
    else
        printf "\nGNOME DOESN'T EXIST\n"
    fi

    # TODO translation

    clear
    printf "\n\n============== Adicionando informações ao leia-me.txt ==============\n\n"
    printf "\n============== CONFIGURAÇÕES MANUAIS (INFELIZMENTE) ==============\n" >~/Downloads/leia-me.txt

    printf "\n============== CONFIGURAÇÕES SVP ==============\n\n" >>~/Downloads/leia-me.txt
    printf "1) Abra o SVP\n" >>~/Downloads/leia-me.txt
    printf "2) Clique no ícone no canto superior esquerdo\n" >>~/Downloads/leia-me.txt
    printf "3) Vá em Configuraçẽos do Programa\n" >>~/Downloads/leia-me.txt
    printf "4) [x] Minimize to Tray (Marcar)\n\n" >>~/Downloads/leia-me.txt

    printf "Torne o aplicativos padrão de vídeo para SMPlayer (só funcionou por ele)\n" >>~/Downloads/leia-me.txt
    printf "0) Vá em Configurações > Detalhes > Aplicativos Padrão > Vídeo e Selecione o SMPlayer\n\n" >>~/Downloads/leia-me.txt

    printf "1) Agora abra o SMPlayer (pode ser outro player em outras distros)\n" >>~/Downloads/leia-me.txt
    printf "2) Vai na aba Opções > Preferências > sub-aba 'Vídeo'\n" >>~/Downloads/leia-me.txt
    printf "3) Marque: \n[x] Iniciar vídeos em modo de tela cheia'\n\n" >>~/Downloads/leia-me.txt

    printf "4) Agora vá na aba 'Avançado' > MPlayer/mpv\n" >>~/Downloads/leia-me.txt
    printf "5) Em 'Opções:' coloque\n" >>~/Downloads/leia-me.txt
    printf "6) --input-ipc-server=/tmp/mpvsocket\n" >>~/Downloads/leia-me.txt
    printf "7) Aplica e tem mais.\n" >>~/Downloads/leia-me.txt
    printf "8) Vá na aba INTERFACE e faça as seguintes mudanças:\n\n" >>~/Downloads/leia-me.txt
    printf "9) \nIdioma: <Idioma do Sistema> \nGUI: Inferface Personalizável \nSkin: Modern \nEstilo: GTK+\n\n" >>~/Downloads/leia-me.txt
    printf "10) Aplica e tem mais.\n" >>~/Downloads/leia-me.txt
    printf "11) Vá na aba TECLADO E MOUSE > Mouse\n" >>~/Downloads/leia-me.txt
    printf "12) Em Funções do botão:\n\n" >>~/Downloads/leia-me.txt
    printf "13) \nClique esquerdo: Pausa \nDuplo Clique: Tela cheia \nClique direito: Mostrar menu de contexto \nClique no meio: Silenciar \n\nFunções da roda do mouse: Controlar volume\n" >>~/Downloads/leia-me.txt
    printf "14) Dê OK\n" >>~/Downloads/leia-me.txt
    printf "Foi esse que pegou no Pop\!_OS 20.04.\n" >>~/Downloads/leia-me.txt

    rm ~/$config_folder/grub.txt
    xdg-open ~/Downloads/leia-me.txt && exit

}

function updateAndReboot {

    # 10 - Update System

    sudo apt update -y
    sudo apt dist-upgrade -fy
    sudo apt autoclean -y  # limpa seu repositório local de todos os pacotes que o APT baixou.
    sudo apt autoremove -y # remove dependências que não são mais necessárias ao seu Sistema.

    reboot

}

initVariables
setUpEnv
setUpGit
installKeys
installPackages
installZsh
installSvp
setUpGrub
installGnomeExt
updateAndReboot
