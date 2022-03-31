#!/usr/bin/env bash

source ./src/lib/title-templates.sh

# Code from: https://stackoverflow.com/a/18216114
function error() {
  printf '\E[31m'
  echo "$@"
  printf '\E[0m'
}

function configEnv() {
  # Initialize Global variables
  _appNum=0
  _configFolder=.config/ledragox-linux-script
  _scriptFolder=$(pwd)

  cat <<EOF
_appNum       = $_appNum
_configFolder = $_configFolder
_scriptFolder = $_scriptFolder
EOF

  echo && echo "- Preparing the files location"
  mkdir --parents ~/$_configFolder
}

function installFonts() {
  echoTitle "JetBrainsMono + MesloLGS Fonts install"
  echoSection "Making fonts folder"
  mkdir --parents fonts/JetBrainsMono/
  mkdir --parents fonts/MesloLGS/

  echoSection "Downloading JetBrains Mono font"
  wget -c -O ./configs/JetBrainsMono.zip https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip
  unzip configs/JetBrainsMono.zip "fonts/ttf/*.ttf"
  mv fonts/ttf/*.ttf fonts/JetBrainsMono/
  rm -r fonts/ttf

  echoSection "Downloading MesloLGS NF font"
  pushd fonts/MesloLGS
  wget -c https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  wget -c https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
  wget -c https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
  wget -c https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
  popd

  echoSection "Installing fonts required by Oh My Zsh ~> Powerlevel10k"
  sudo mkdir --parents /usr/share/fonts
  sudo mv fonts/* /usr/share/fonts
  fc-cache -v -f

  echoSection "Create Downloads folder"
  mkdir --parents ~/Downloads
}

function installZsh() {
  echoTitle "Z-Shell install"
  echoCaption "Zsh should already be installed, this just to finish it's install"

  echoCaption "Make Zsh the default shell"
  chsh --shell $(which zsh)
  $SHELL --version

  echoCaption "Needs to log out and log in to make the changes"
  echo $SHELL
}

function installOhMyZsh() {
  echoSection "Oh My Zsh"

  if [[ -f "~/.oh-my-zsh" ]]; then
    error "!!! ATTENTION !!! Removing ~/.oh-my-zsh file to reinstall from 0."
    sudo rm --recursive ~/.oh-my-zsh
  fi

  echoCaption "Installing Oh My Zsh..."
  error "TYPE 'Y', THEN 'EXIT', THE SCRIPT IS NOT FINISHED YET"
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echoCaption "Setting Powerlevel10k theme on ZSH..."
  sudo sed -i 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

  echoSection "Powerlevel10k for Oh My Zsh"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  echoCaption "Updating Powerlevel10k..."
  git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull

  echoCaption "Install plugins on oh-my-zsh custom plugins folder: (docker zsh-autosuggestions zsh-syntax-highlighting)"
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  echoCaption "Adding plugins to ~/.zshrc file..."
  sudo sed -i 's/^plugins=(git)/plugins=(docker git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
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

  if [[ -f "$_sshPath/$_sshFile" ]] || [[ -f "$_sshPath/$_sshAltFile" ]]; then

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
