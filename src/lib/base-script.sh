#!/bin/bash

source ./src/lib/title-templates.sh

function initVariables() {

  # Initialize Global variables

  app_num=0
  config_folder=.config/ledragox-linux-script
  script_folder=$(pwd)

  echo "
    app_num         = $app_num
    config_folder   = $config_folder
    script_folder   = $script_folder
    "

}

function configEnv() {

  echo "- Preparing the files location"
  mkdir --parents ~/$config_folder
  echo "Copying configs to ~/$config_folder"
  cp --recursive src/lib/configs/ ~/$config_folder
  cd ~/$config_folder
  rm -r ~/$config_folder/"~"

  echo "- Create Downloads folder"
  mkdir --parents ~/Downloads

  sudo timedatectl set-timezone UTC # Using UTC

}

function installZsh() {

  echo "- Install Zsh"

  sudo apt install -y zsh
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

  echo "Installing fonts required by Powerlevel10k"
  sudo mv configs/*.ttf /usr/local/share/fonts
  fc-cache -v -f

  echo "Set Powerlevel10k theme on ZSH"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  ZSH_THEME="powerlevel10k/powerlevel10k" # Only first time can use variable, after this, just edit the ~/.zshrc
  echo "Copy my template from .p10k.zsh"
  mv configs/.p10k.zsh ~/

  echo "Install plugins on oh-my-zsh custom plugins folder: (zsh-autosuggestions zsh-syntax-highlighting)"
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

}

function configGit() {

  echo "- Set Up Git Commits Signature (Verified)"
  echo "Requires Git before"

  # Use variables to make life easier
  git_user_name=$(git config --global user.name)
  git_user_email=$(git config --global user.email)

  ssh_path=~/.ssh
  ssh_enc_type=ed25519
  ssh_file="$($git_user_email)_id_$ssh_enc_type"
  ssh_alt_file="id_$ssh_enc_type" # Need to be checked

  mkdir --parents "$ssh_path"
  pushd "$ssh_path"
  if [ -f "$ssh_path/$ssh_file" ] || [ -f "$ssh_path/$ssh_alt_file" ]; then
    echo "$ssh_path/$ssh_file Exists OR"
    echo "$ssh_path/$ssh_alt_file Exists"
  else
    echo "$ssh_path/$ssh_file Not Exists | Creating..."
    echo "Using your email from git to create a SSH Key: $git_user_email"
    # Generate a new ssh key, passing every parameter as variables (Make sure to config git first)
    ssh-keygen -t $ssh_enc_type -C "$git_user_email" -f "$ssh_path/$ssh_file"

    # Check if ssh-agent is running before adding
    eval "$(ssh-agent -s)"

    # Add your private key
    ssh-add "$ssh_path/$ssh_file"
    ssh-add "$ssh_path/$ssh_alt_file"

  fi
  popd

  gpg --list-signatures # Use this instead creating the folder, fix permissions
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
