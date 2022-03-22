#!/bin/sh

source ./src/lib/title-templates.sh

function initVariables() {

  # Initialize Global variables

  _appNum=0
  _configFolder=.config/ledragox-linux-script
  _scriptFolder=$(pwd)

  echo "
    _appNum         = $_appNum
    _configFolder   = $_configFolder
    _scriptFolder   = $_scriptFolder
    "

}

function configEnv() {

  echo "- Preparing the files location"
  mkdir --parents ~/$_configFolder

  echo "- Copying configs to ~/$_configFolder"
  cp --recursive src/lib/configs/ ~/$_configFolder
  cd ~/$_configFolder
  rm -r ~/$_configFolder/"~"

  echo "- Making fonts folder"
  mkdir --parents fonts/JetBrainsMono/
  mkdir --parents fonts/MesloLGS/

  echo "- Downloading JetBrains Mono font"
  wget -c -O ./configs/JetBrainsMono.zip https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip
  unzip configs/JetBrainsMono.zip "fonts/ttf/*.ttf"
  mv fonts/ttf/*.ttf fonts/JetBrainsMono/
  rm -r fonts/ttf

  echo "- Downloading MesloLGS NF font"
  pushd fonts/MesloLGS
  wget -c https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  wget -c https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
  wget -c https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
  wget -c https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
  popd

  echo "- Installing fonts required by Zsh ~> Powerlevel10k"
  sudo mkdir --parents /usr/share/fonts
  sudo mv fonts/* /usr/share/fonts
  fc-cache -v -f

  echo "- Create Downloads folder"
  mkdir --parents ~/Downloads

  sudo timedatectl set-timezone UTC # Using UTC

}

function installZsh() {

  echo "- Zsh should already be installed, this just to finish it's install"

  echo "Make Zsh the default shell"
  chsh -s $(which zsh)
  $SHELL --version

  echo "Needs to log out and log in to make the changes"
  echo $SHELL

  echo "Oh My Zsh"
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

  echo "Copy the template .zshrc.zsh-template configuration file to the home directory .zshrc"
  cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
  echo "But instead copy my template from .zshrc"
  mv configs/.zshrc ~/
  echo "Apply the configuration by running the source command."
  source ~/.zshrc

  echo "Set Powerlevel10k theme on ZSH"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  ZSH_THEME="powerlevel10k/powerlevel10k" # Only first time can use variable, after this, just edit the ~/.zshrc
  echo "Copy my template from .p10k.zsh"
  mv configs/.p10k.zsh ~/.p10k.zsh

  echo "Install plugins on oh-my-zsh custom plugins folder: (zsh-autosuggestions zsh-syntax-highlighting)"
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

}

function configGit() {

  echo "- Set Up Git Commits Signature (Verified)"
  echo "Requires Git before"

  # Use variables to make life easier
  local _gitUserName="$(git config --global user.name)"
  local _gitUserEmail="$(git config --global user.email)"

  local _sshPath=~/.ssh
  local _sshEncType=ed25519
  local _sshFile="$(echo $_gitUserEmail)_id_$_sshEncType"
  local _sshAltFile="id_$_sshEncType" # Need to be checked

  mkdir --parents "$_sshPath"
  pushd "$_sshPath"

  if [ -f "$_sshPath/$_sshFile" ] || [ -f "$_sshPath/$_sshAltFile" ]; then

    echo "$_sshPath/$_sshFile Exists OR"
    echo "$_sshPath/$_sshAltFile Exists"

  else

    echo "$_sshPath/$_sshFile Not Exists | Creating..."
    echo "Using your email from git to create a SSH Key: $_gitUserEmail"
    # Generate a new ssh key, passing every parameter as variables (Make sure to config git first)
    ssh-keygen -t $_sshEncType -C "$_gitUserEmail" -f "$_sshPath/$_sshFile"

  fi

  echo "Checking if ssh-agent is running before adding keys"
  eval "$(ssh-agent -s)"

  echo "Validating files permissions"
  chmod 600 "$_sshPath/$_sshFile"
  chmod 600 "$_sshPath/$_sshAltFile"

  echo "Adding your private keys"
  ssh-add "$_sshPath/$_sshFile"
  ssh-add "$_sshPath/$_sshAltFile"
  popd

  gpg --list-signatures # Use this instead of creating the folder, fix permissions
  pushd ~/.gnupg
  # Import GPG keys
  gpg --import *.gpg
  # Get the exact key ID from the system
  # Code adapted from: https://stackoverflow.com/a/66242583        # My key name
  key_id=$(gpg --list-signatures --with-colons | grep 'sig' | grep "$_gitUserEmail" | head -n 1 | cut -d':' -f5)
  git config --global user.signingkey $key_id
  # Always commit with GPG signature
  git config --global commit.gpgsign true
  popd

}

function fixPackagesUbuntu() {
  echo "- Fix/Update currently installed Packages"

  echo "[Adapted] Ubuntu fix broken packages (best solution)"
  sudo apt update -y --fix-missing
  sudo dpkg --configure -a # Attempts to fix problems with broken dependencies between program packages.
  sudo apt-get --fix-broken install

}

function updateAllPackagesUbuntu() {

  echo "- Update System"

  sudo apt update -y
  sudo apt dist-upgrade -fy
  sudo apt autoclean -y  # limpa seu repositório local de todos os pacotes que o APT baixou.
  sudo apt autoremove -y # remove dependências que não são mais necessárias ao seu Sistema.

}
