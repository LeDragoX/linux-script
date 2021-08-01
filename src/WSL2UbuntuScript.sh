#!/bin/bash

function initVariables() {

    # Initialize Global variables

    clear
    app_num=0
    total_apps=10

    config_folder=".config/ledragox-linux-script"
    script_folder=$(pwd)
    wait_time=7

    echo "
    app_num         = $app_num
    total_apps      = $total_apps

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
    printf "1 - Preparing the files location\n"
    mkdir --parents ~/$config_folder
    printf "Copying configs to $config_folder\n"
    cp --recursive ../lib/configs/ ~/$config_folder
    cd ~/$config_folder

    printf "Create Downloads folder\n"
    mkdir --parents ~/Downloads

    timedatectl set-local-rtc 1 # Using Local time (Dualboot with Windows)
    #sudo timedatectl set-timezone UTC # Using UTC

    printf "2 - Fix currently installed Packages\n"

    printf "[Adapted] Ubuntu fix broken packages (best solution)\n"
    sudo apt update -y --fix-missing
    sudo dpkg --configure -a # Attempts to fix problems with broken dependencies between program packages.
    sudo apt-get --fix-broken install

}

function setUpGit {
    printf "3 - Set Up Git Commits Signature (Verified)\n"

    sudo apt install -y git
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

function installPackages {

    printf "4 - Install Apt Packages\n"

    sudo dpkg --add-architecture i386                                           # Enable 32-bits Architecture
    sudo DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-restricted-extras # Remove interactivity | Useful proprietary stuff

    declare -a apt_pkgs=(

        # Initial Libs that i use

        "adb"        # Android Debugging
        "curl"       # Terminal Download Manager
        "fastboot"   # Android Debugging
        "gdebi"      # CLI/GUI .deb Installer
        "gdebi-core" # CLI/GUI .deb Installer
        "htop"       # Terminal System Monitor
        "neofetch"   # Neofetch Command
        "vim"        # Terminal Text Editor
        "wget"       # Terminal Download Manager

        # Programming languages for devlopment

        "python3-pip" # Python 3 pip
    )

    printf "\nInstalling via Advanced Package Tool (apt)...\n"
    for App in ${apt_pkgs[@]}; do
        printf "\nInstalling: $App \n"
        sudo apt install -y $App
    done

    printf "Check Python version\n"
    python3 --version
    pip3 --version

    printf "Ruby and Rails via RVM\n"
    gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    \curl -sSL https://get.rvm.io | bash -s stable --ruby
    source ~/.rvm/scripts/rvm
    \curl -sSL https://get.rvm.io | bash -s stable --rails
    rvm -v  # Check RVM version
    ruby -v # Check RUBY version

    rvm install 3.0.0
    rvm use 3.0.0 --default
    rvm requirements

    printf "NodeJS & NPM\n"
    curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    node -v
    npm -v
    printf "Yarn for NodeJS\n"
    sudo npm install --global yarn
    yarn --version

}

function installZsh {

    # 5 - Install Zsh

    printf "Zsh install\n"
    sudo apt install -y zsh
    printf "Make Zsh the default shell\n"
    chsh -s $(which zsh)
    $SHELL --version

    printf "Needs to log out and log in to make the changes\n"
    echo $SHELL

    printf "Oh My Zsh\n"
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

    printf "Copy the template .zshrc.zsh-template configuration file to the home directory .zshrc"
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
    printf "But instead copy my template from .zshrc\n"
    mv configs/.zshrc ~/
    printf "Apply the configuration by running the source command.\n"
    source ~/.zshrc

    printf "Installing fonts required by Powerlevel10k\n"
    sudo mv configs/*.ttf /usr/local/share/fonts
    fc-cache -v -f

    printf "Set Powerlevel10k theme on ZSH\n"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    ZSH_THEME="powerlevel10k/powerlevel10k" # Only first time can use variable
    printf "Copy my template from .p10k.zsh\n"
    mv configs/.p10k.zsh ~/

    printf "Install plugins on oh-my-zsh custom plugins folder: (zsh-autosuggestions zsh-syntax-highlighting)\n"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

}

function updateAll {

    printf "6 - Update System\n"

    sudo apt update -y
    sudo apt dist-upgrade -fy
    sudo apt autoclean -y  # limpa seu repositório local de todos os pacotes que o APT baixou.
    sudo apt autoremove -y # remove dependências que não são mais necessárias ao seu Sistema.

}

initVariables
setUpEnv

setUpGit
installPackages
installZsh
updateAll
