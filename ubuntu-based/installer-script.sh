#!/bin/bash

# Antes de TUDO, para rodar o Script use
# chmod +x *.sh && yes | ./script-linux_ubuntu.sh
# sudo chmod -R 777 folder/
# pra ter todas as permissões dentro daquela pasta

# Algumas Dicas
# Só precisa dar 'apt update' se você tiver acabado de adicionar um repositório de pacotes
# Use "apt list --installed" para ver os pacotes (programas) instalados

# Initialize Global variables
num=0
last_num=34

function init_variables {

    clear
    wait_time=10
    config_folder="PKGSConfig"

    ########## Ubuntu ##########

    pkg="apt"
    old_pkg="apt-get"
    f_addrepo="add-apt-repository -y"
    f_addkey="-key"
    f_update="update -y"
    f_ugrade="dist-upgrade -fy"
    f_install="install -fy"
    f_clean="autoclean -y"
    f_remove="autoremove -y"

    echo "    pkg = $pkg
    old_pkg = $old_pkg
    f_addrepo = $f_addrepo
    f_addkey = $f_addkey
    f_update = $f_update
    f_ugrade = $f_ugrade
    f_install = $f_install
    f_clean = $f_clean
    f_remove = $f_remove"

    echo ""
    read -t $wait_time -p "Waiting $wait_time seconds only ..."
    echo ""

    ##############################

}

function superEcho {
    echo ""
    echo "==================== $1 ===================="
    echo ""
    echo ""
}

function installCounter {
    superEcho "( $((num+=1))/$last_num ) Installing: [$1]"
    #echo "$((last_num+=1))"
}

init_variables

clear
superEcho "PREPARATIVOS DO SISTEMA"

# Tudo deve ocorrer nesse diretório pra ficar mais visível
mkdir ~/$config_folder
cd ~/$config_folder
# Criando pasta para temas personalizados
mkdir ~/.icons

printf "[Adapted] Ubuntu fix broken package (best solution)\n"
sudo $pkg $f_update --fix-missing
sudo dpkg --configure -a # attempts to fix problems with broken dependencies between program packages.
sudo $old_pkg --fix-broken install
#
#
#
superEcho "Desbugando a hora do Windows (dualboot)"
timedatectl set-local-rtc 1 # Será colocado o horário local
# sudo timedatectl set-timezone UTC # Pra voltar pra UTC

clear
superEcho "APLICATIVOS INICIAIS"
printf "\nPara fazer outras coisas enquanto instala TUDO\n"


installCounter "Wget & Curl (Se já não estiver)"
sudo $pkg $f_install wget curl

clear
installCounter "Git"
sudo $pkg $f_install git

clear
installCounter "NeoFetch (Visão Geral do Sistema)"
sudo $pkg $f_install neofetch

clear
installCounter "Terminator"
sudo $pkg $f_install terminator

clear
installCounter "htop (Monitor de Sistema em shell)"
sudo $pkg $f_install htop

clear
installCounter "Google Chrome"
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo $pkg$f_addkey add -
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
sudo $pkg $f_update
sudo $pkg $f_install google-chrome-stable
superEcho "Desinstalando o Firefox :D"
sudo $pkg remove -y firefox

clear
installCounter "GDebi (Manage .deb files)"
sudo $pkg $f_install gdebi gdebi-core

clear
installCounter "Discord"
wget -c -O ~/$config_folder/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
sudo gdebi -n ~/$config_folder/discord.deb

clear
installCounter "PulseAudio (Audio Controller)"
sudo $pkg $f_install pavucontrol

clear
installCounter "Spotify"
curl -sS https://download.spotify.com/debian/pubkey.gpg | sudo $pkg$f_addkey add - 
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo $pkg $f_update
sudo $pkg $f_install spotify-client



clear
superEcho "Ativa a arquitetura 32-bits"
sudo dpkg --add-architecture i386

clear
installCounter "Preparing GRUB..."
sudo $pkg $f_install grub-efi grub2-common grub-customizer
sudo grub-install
if neofetch | grep -i Pop\!_OS
then
    sudo cp /boot/grub/x86_64-efi/grub.efi /boot/efi/EFI/pop/grubx64.efi
    printf "1) Clique na aba Arquivo > Alterar ambiente... \n\n" > grub.txt
    printf "2) onde está OUTPUT_FILE: \n/boot/grub/grub.cfg\n   MUDE PARA: \n" >> grub.txt
    printf "/boot/efi/EFI/pop/grub.cfg\n============================\n\n" >> grub.txt
    printf "3) Depois marque \n[X] Salvar esta configuração \nAplique\!\n" >> grub.txt
else
    printf "\nNot Pop\!_OS\n"
fi

clear
cat ~/$config_folder/grub.txt
sudo grub-customizer
rm ~/$config_folder/grub.txt
superEcho "GRUB pronto!"

clear
sudo cat /etc/X11/default-display-manager
if neofetch | grep -i Pop\!_OS # Verifica sistemas que já instalam nativamente o driver da GPU, no caso só o Pop!_OS
then 
    printf "\nNão necessita da instalação do driver de vídeo, pois já possui nativamente\n"
else
    if nvidia-smi
    then 
        printf "\nDriver da NVIDIA já instalado\n"
        sudo $pkg $f_install ocl-icd-opencl-dev &&
        sudo $pkg $f_install libvulkan1 libvulkan1:i386 &&
        sudo $pkg $f_install nvidia-settings && 
        sudo $pkg $f_install dkms build-essential linux-headers-generic
    else
    	if lspci -k | grep -i NVIDIA # Verificação de GPU NVIDIA antes de instalar qualquer driver
        then
            clear
            printf "Bloqueando driver NOUVEAU da NVIDIA em /etc/modprobe.d/blacklist.conf\n"
            sudo sh -c "printf '\n\n# Freaking NVIDIA driver that glitches every system\nblacklist nouveau\nblacklist lbm-nouveau\noptions nouveau modeset=0\nalias nouveau off\nalias lbm-nouveau off' >> /etc/modprobe.d/blacklist.conf"
            
            installCounter "NVIDIA driver"
            sudo $f_addrepo ppa:graphics-drivers/ppa &&
            sudo $pkg $f_update &&
            sudo $pkg $f_install nvidia-driver-450-server && # 09/2020 Versão 450-server = proprietária
            sudo $pkg $f_install ocl-icd-opencl-dev &&
            sudo $pkg $f_install libvulkan1 libvulkan1:i386 &&
            sudo $pkg $f_install nvidia-settings && 
            sudo $pkg $f_install dkms build-essential linux-headers-generic
        else
            printf "\nPlaca de vídeo diferente da NVIDIA\n"
        fi
    fi
fi


clear
installCounter "Essential packages for the System"
sudo $pkg $f_install build-essential gcc-multilib libsdl2-dev software-properties-gtk

clear
installCounter "OpenRazer"
sudo $f_addrepo ppa:openrazer/stable
sudo $pkg $f_update
sudo $pkg $f_install openrazer-meta
sudo gpasswd -a $USER plugdev

clear
installCounter "ppa-purge (importante pra depois c; )"
sudo $pkg $f_install ppa-purge

clear
installCounter "GParted"
sudo $pkg $f_install gparted

clear
installCounter "ADB (Android Debugging)"
sudo $pkg $f_install android-tools-adb android-tools-fastboot

clear
installCounter "Python 3"
python3 --version
sudo $pkg $f_install python-minimal
sudo $pkg $f_install python3-minimal
sudo $pkg $f_install python3
sudo $pkg $f_install python3-pip
sudo $pkg $f_install python-pip

clear
installCounter "OpenJDK 11 and 14"
sudo $f_addrepo ppa:openjdk-r/ppa
sudo $pkg $f_update
sudo $pkg $f_install openjdk-15-jdk openjdk-15-jre
#
#
#
clear
superEcho "APLICATIVOS"

installCounter "SMPlayer (Best Player, for SVP)"
sudo $f_addrepo ppa:rvm/smplayer
sudo $pkg $f_update
sudo $pkg $f_install smplayer smplayer-themes smplayer-skins
superEcho "Desinstalando Players padrões"
sudo $pkg remove -y totem
sudo $pkg remove -y celluloid

clear
installCounter "VS Code (64-bits)"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo $pkg $f_install apt-transport-https
sudo $pkg $f_update
sudo $pkg $f_install code # or code-insiders

clear
if gnome-shell --version # Usado para verificar se usa o Gnome
    then
        installCounter "Gnome Tweak Tool (Only if the Distro's UI is GNOME)"
        sudo $pkg $f_install gnome-tweak-tool
        installCounter "Gnome Shell Extensions"
        sudo $pkg $f_install gnome-shell-extensions gnome-menus gir1.2-gmenu-3.0
        installCounter "Chrome Gnome Shell (Needs Google Chrome)"
        sudo $pkg $f_install chrome-gnome-shell && sudo $pkg $f_update
        superEcho "Permite a extensão, atualiza a página e clica em ON"
        google-chrome https://chrome.google.com/webstore/detail/gnome-shell-integration/gphhapmejobijbbhgpjhcjognlahblep?hl=pt-BR https://extensions.gnome.org/extension/1160/dash-to-panel/ https://extensions.gnome.org/extension/906/sound-output-device-chooser/ https://extensions.gnome.org/extension/1625/soft-brightness/ https://extensions.gnome.org/extension/750/openweather/ https://extensions.gnome.org/extension/7/removable-drive-menu/
    else
        printf "NÃO EXISTE GNOME\n"
fi

clear
installCounter "qBittorrent"
sudo $f_addrepo ppa:qbittorrent-team/qbittorrent-stable
sudo $pkg $f_update
sudo $old_pkg $f_install qbittorrent

clear
installCounter "Steam"
sudo $pkg $f_install steam
if $pkg list --installed | grep steam
then
    printf "STEAM ALREADY INSTALLED\n"
else
    # Se não foi de primeira
    sudo $f_addrepo multiverse
    sudo $pkg $f_update && sudo $pkg install steam
    # E nem assim
    wget -c -O steam.deb 'http://media.steampowered.com/client/installer/steam.deb'
    sudo gdebi -n steam.deb
fi

clear
installCounter "Lutris"
sudo $f_addrepo ppa:lutris-team/lutris
sudo $pkg $f_update
sudo $pkg $f_install lutris

clear
installCounter "OBS Studio"
sudo $f_addrepo ppa:obsproject/obs-studio
sudo $pkg $f_update
sudo $pkg $f_install obs-studio

clear
installCounter "Parsec"
wget -c -O parsec-linux.deb "https://builds.parsecgaming.com/package/parsec-linux.deb"
sudo gdebi -n parsec-linux.deb

clear
installCounter "Gimp (Image Editor)"
sudo $pkg $f_install gimp gimp-gmic

clear
installCounter "PreMiD (Locally)"
wget -c -O ~/$config_folder/PreMiD.tar.gz https://github.com/PreMiD/Linux/releases/latest/download/PreMiD.tar.gz
tar -xf ~/$config_folder/PreMiD.tar.gz
mv ~/$config_folder/PreMiD ~/
mv PreMiD ~/

clear
installCounter "SVP"
svp_installer=$(pwd)/install-svp.sh
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

# Por algum motivo ele sai desse diretório depois de rodar o outro script
mkdir ~/$config_folder
cd ~/$config_folder

clear
installCounter "Wine"
wget -nc https://dl.winehq.org/wine-builds/winehq.key # Release.key é antigo, winehq.key é o novo repositório
sudo $pkg$f_addkey add winehq.key
sudo $f_addrepo 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' # LINHA PERIGOSA? | Ubuntu Focal = 20.04

sudo $pkg $f_update && sudo $pkg $f_install --install-recommends winehq-devel
# Consertar chave bugada
sudo $pkg$f_addkey adv --keyserver keyserver.ubuntu.com --recv-key 76F1A20FF987672F

clear
installCounter "WineTricks"
sudo $pkg $f_install winetricks

clear
superEcho "2- Configurando o WineTricks"
winetricks -q corefonts dinput xinput directplay dxvk d3dx9 d3dx10 d3dcompiler_43 vcrun2005 vcrun2008 vcrun2010 vcrun2012 vcrun2013
clear
winetricks -q vcrun2019 # Só reconhece se não instalar o vcrun2015
# winetricks -q allcodecs # Bugs estranhos no XFCE
#winetricks -q vcrun2015 # Desnecessário: o vcrun2019 inclui o 2015, 2017 e 2019
# winetricks -q dotnet35 #dotnet40 #dotnet45 #dotnet46 #dotnet48 # ERRO
#
#
#
#
#
#
clear
neofetch # hehe

superEcho "CONFIGURAÇÕES MANUAIS (Durante o script) ==============\n"
printf "\nSe quiser pode deixar pra depois\n\n"
if gnome-shell --version # Usado para verificar se usa o Gnome
    then
        superEcho "CONFIGURAÇÕES Dash to Panel (O qual abriu agora)==============\n\n"
        printf "1) Vá na aba Sobre\n"
        printf "2) Clique em Import from file\n"
        printf "3) Vá na pasta \"Downloads\"\n"
        printf "4) Escolha \"config-gnome-dash-to-panel.cfg\" e feche \n"
        gnome-shell-extension-prefs dash-to-panel@jderose9.github.com
        
        superEcho "CONFIGURAÇÕES Dash to Panel" > ~/Downloads/leia-me-gnome.txt
        printf "1) Vá na aba Sobre\n" >> ~/Downloads/leia-me-gnome.txt
        printf "2) Clique em Import from file\n" >> ~/Downloads/leia-me-gnome.txt
        printf "3) Vá na pasta \"Downloads\"\n" >> ~/Downloads/leia-me-gnome.txt
        printf "4) Escolha \"config-gnome-dash-to-panel.cfg\" e feche \n" >> ~/Downloads/leia-me-gnome.txt
    else
        printf "NÃO EXISTE GNOME\n"
fi
#
#
#
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
#
#
clear
printf "\n============== ÚLTIMOS PASSOS ==============\n\n"

printf "Garante que você vai ter a última versão de tudo e tira coisas inúteis\n"
sudo $pkg $f_update
sudo $pkg $f_ugrade
sudo $pkg $f_ugrade
sudo $pkg $f_clean # limpa seu repositório local de todos os pacotes que o APT baixou.
sudo $pkg $f_remove # remove dependências que não são mais necessárias ao seu Sistema.

clear
printf "Removendo PPAs bugados (Sem Release)\n\n"
sudo $f_addrepo --remove ppa:djcj/hybrid

rm grub.txt
xdg-open ~/Downloads/leia-me.txt && cd ~/PreMiD && ./premid && exit
