#!/usr/bin/env bash

source ./src/lib/title-templates.sh

function scriptLogo() {
  _SYSTEM=$( (lsb_release -ds || cat /etc/*-release || uname -om) 2>/dev/null | head -n1 | sed -e "s/\"//g")
  _ARCH=$(uname -om | sed -e "s/\ .*//")
  _BASED_ON=$(grep -i "ID_LIKE=" /etc/*-release | sed -e "s/^.*ID_LIKE=//" | head -n1)

  echo "<••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••>"
  echo '██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗███████╗ ██████╗██████╗ ██╗██████╗ ████████╗'
  echo '██║     ██║████╗  ██║██║   ██║╚██╗██╔╝██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝'
  echo '██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ ███████╗██║     ██████╔╝██║██████╔╝   ██║   '
  echo '██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   '
  echo '███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗███████║╚██████╗██║  ██║██║██║        ██║   '
  echo '╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   '
  echo "<••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••>"
  echo -n "   " && echo "$_SYSTEM $_ARCH - Based on $_BASED_ON"
  echoError '   Script made by LeDragoX'
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

function fixTimeZone() {
  echoTitle "Setting time zone to local (fix dual boot clock)"
  sudo timedatectl set-local-rtc 1 --adjust-system-clock
}

function installProgrammingLanguagesWithVersionManagers() {
  echoTitle "Installing programming languages which support version management"
  echoSection "NVM - Node Version Manager"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  echoCaption "Installing latest LTS Node..."
  nvm install --lts
  nvm install node
  nvm alias default "lts/*"
  npm config set registry https://registry.npmjs.org/ --global
  npm cache clear --force
  node -v
  corepack enable
  yarn -v

  echoSection "RVM - Ruby Version Manager (With Rails)"
  gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  \curl -sSL https://get.rvm.io | bash -s head --rails --auto-dotfiles
  rvm -v
  rvm --default use ruby
  ruby -v
  gem install rails
  rails -v

  echoSection "ASDF - Manage multiple runtime versions with a single CLI tool"
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1
}

function installFonts() {
  echoTitle "Installing Nerd Fonts"
  echoSection "Making fonts/ folder"
  mkdir --parents fonts/JetBrainsMono/
  mkdir --parents fonts/MesloLGS/

  echoSection "Downloading JetBrains Mono font"
  pushd fonts/JetBrainsMono || exit
  wget -c -O JetBrainsMono.zip "https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip"
  unzip JetBrainsMono.zip "fonts/ttf/*.ttf"
  echoSection "Moving JetBrains Mono font"
  mv --force --verbose fonts/ttf/*.ttf ./
  rm -r fonts
  rm JetBrainsMono.zip
  popd || exit

  echoSection "Downloading MesloLGS NF font"
  pushd fonts/MesloLGS || exit
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
  popd || exit

  echoSection "Installing fonts required by Oh My Zsh ~> Powerlevel10k"
  sudo mkdir --parents /usr/share/fonts
  sudo mv --force --verbose fonts/* /usr/share/fonts
  fc-cache -v -f

  echoCaption "Removing fonts/ folder from $(pwd)"
  rm -r fonts/

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

  local _zshPlugins="(git zsh-autosuggestions zsh-syntax-highlighting asdf nvm node ruby rails docker)"
  echoCaption "Install plugins on oh-my-zsh custom plugins folder: $_zshPlugins"
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

  echoCaption "Adding plugins to ~/.zshrc file..."
  sudo sed -i "s/^plugins=.*/plugins=$_zshPlugins/" ~/.zshrc
}

function waitPrompt() {
  read -r -p "Press ENTER to continue..."
}
