#!/bin/bash

source ./../lib/base-script.sh

function installPackagesWsl() {

    title1 "Install Apt Packages"

    sudo dpkg --add-architecture i386                                           # Enable 32-bits Architecture
    sudo DEBIAN_FRONTEND=noninteractive apt install -y ubuntu-restricted-extras # Remove interactivity | Useful proprietary stuff

    declare -a apt_pkgs=(

        # Initial Libs that i use

        "adb"        # Android Debugging
        "curl"       # Terminal Download Manager
        "fastboot"   # Android Debugging
        "gdebi"      # CLI/GUI .deb Installer
        "gdebi-core" # CLI/GUI .deb Installer
        "git"        # Git
        "htop"       # Terminal System Monitor
        "neofetch"   # Neofetch Command
        "vim"        # Terminal Text Editor
        "wget"       # Terminal Download Manager
        "zsh"        # Z-Shell

        # Programming languages for devlopment

        "python3-pip" # Python 3 pip
    )

    section1 "Installing via Advanced Package Tool (apt)..."
    for App in ${apt_pkgs[@]}; do
        caption1 "Installing: $App "
        sudo apt install -y $App
    done

    caption1 "Check Python version"
    python3 --version
    pip3 --version

    caption1 "Ruby and Rails via RVM"
    gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    \curl -sSL https://get.rvm.io | bash -s stable --ruby
    source ~/.rvm/scripts/rvm
    \curl -sSL https://get.rvm.io | bash -s stable --rails
    rvm -v  # Check RVM version
    ruby -v # Check RUBY version

    rvm install 3.0.0
    rvm use 3.0.0 --default
    rvm requirements

    caption1 "NodeJS & NPM"
    curl -sL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
    node -v
    npm -v
    caption1 "Yarn for NodeJS"
    sudo npm install --global yarn
    yarn --version

}

function main() {

    initVariables
    sudo apt install -fy wget zip unzip # Needed to download/install fonts
    configEnv

    fixPackagesUbuntu
    installPackagesWsl

    updateAllPackagesUbuntu
    installZsh
    configGit

}

main