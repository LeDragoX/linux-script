#!/usr/bin/env bash

source ./src/lib/title-templates.sh

function scriptLogo() {
  echo "<••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••>"
  echo '██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗███████╗ ██████╗██████╗ ██╗██████╗ ████████╗'
  echo '██║     ██║████╗  ██║██║   ██║╚██╗██╔╝██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝'
  echo '██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ ███████╗██║     ██████╔╝██║██████╔╝   ██║   '
  echo '██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   '
  echo '███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗███████║╚██████╗██║  ██║██║██║        ██║   '
  echo '╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   '
  echo "<••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••>"
  echoError '   Made by LeDragoX'
  echo "<••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••>"
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

function installProgrammingLanguagesWithVersionManagers() {
  echoTitle "Installing programming languages which support version management"
  echoSection "NVM - Node Version Manager"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  echoCaption "Installing latest LTS Node..."
  nvm install --lts

  echoSection "RVM - Ruby Version Manager (With Rails)"
  gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  \curl -sSL https://get.rvm.io | bash -s stable --rails
  rvm requirements run
  rvm install ruby
  rvm --default use ruby
  gem install rails
}

function installFonts() {
  echoTitle "JetBrainsMono + MesloLGS Fonts install"
  echoSection "Making fonts folder"
  mkdir --parents fonts/JetBrainsMono/
  mkdir --parents fonts/MesloLGS/

  echoSection "Downloading JetBrains Mono font"
  pushd fonts/JetBrainsMono
  wget -c -O JetBrainsMono.zip "https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip"
  unzip JetBrainsMono.zip "fonts/ttf/*.ttf"
  mv fonts/ttf/*.ttf ./
  rm -r fonts
  rm JetBrainsMono.zip
  popd

  echoSection "Downloading MesloLGS NF font"
  pushd fonts/MesloLGS
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
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

  if [[ -d "~/.oh-my-zsh" ]]; then
    echoError "ATTENTION - Removing ~/.oh-my-zsh file to reinstall from 0."
    sudo rm --recursive ~/.oh-my-zsh
  fi

  echoCaption "Installing Oh My Zsh..."
  echoError "TYPE 'Y', THEN 'EXIT', THE SCRIPT IS NOT FINISHED YET"
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echoCaption "Setting Powerlevel10k theme on ZSH..."
  sudo sed -i 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

  echoSection "Powerlevel10k for Oh My Zsh"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

  echoCaption "Updating Powerlevel10k..."
  git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull

  echoCaption "Install plugins on oh-my-zsh custom plugins folder: (git zsh-autosuggestions zsh-syntax-highlighting docker nvm node ruby rails)"
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  echoCaption "Adding plugins to ~/.zshrc file..."
  sudo sed -i 's/^plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker nvm node ruby rails)/' ~/.zshrc
}

function waitPrompt() {
  read -r -p "Press ENTER to continue..."
}
