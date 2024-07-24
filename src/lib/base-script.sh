#!/usr/bin/env bash

source ./src/lib/title-templates.sh

SYSTEM_BASED_ON=$(grep -i "ID_LIKE=" /etc/*-release | sed -e "s/^.*ID_LIKE=//" | head -n1)
SYSTEM_NAME=$( (lsb_release -ds || cat /etc/*-release || uname -om) 2>/dev/null | head -n1 | sed -e "s/\"//g")
ARCH=$(uname -om | sed -e "s/\ .*//")

readonly SYSTEM_BASED_ON
readonly SYSTEM_NAME
readonly ARCH

# Initialize Global variables
readonly CONFIG_FOLDER=.config/ledragox-linux-script
SCRIPT_FOLDER=$(pwd)
app_counter=0

readonly SCRIPT_FOLDER

function script_logo() {
  echo "<••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••>"
  echo '██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗███████╗ ██████╗██████╗ ██╗██████╗ ████████╗'
  echo '██║     ██║████╗  ██║██║   ██║╚██╗██╔╝██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝'
  echo '██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝ ███████╗██║     ██████╔╝██║██████╔╝   ██║   '
  echo '██║     ██║██║╚██╗██║██║   ██║ ██╔██╗ ╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   '
  echo '███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗███████║╚██████╗██║  ██║██║██║        ██║   '
  echo '╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   '
  echo "<••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••>"
  echo -n "   " && echo "$SYSTEM_NAME $ARCH - Based on $SYSTEM_BASED_ON"
  echo_error '   Script made by LeDragoX'
  echo "<••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••>"
}

function config_environment() {
  cat <<EOF
app_counter   = $app_counter
CONFIG_FOLDER = $CONFIG_FOLDER
SCRIPT_FOLDER = $SCRIPT_FOLDER
EOF

  echo && echo "- Preparing the files location"
  mkdir --parents ~/$CONFIG_FOLDER
}

function fix_time_zone() {
  echo_title "Setting time zone to local (fix dual boot clock)"
  sudo timedatectl set-local-rtc 1 --adjust-system-clock
}

function install_version_managers() {
  echo_title "Installing programming languages which support version management"
  echo_section "NVM - Node Version Manager"
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
  echo_caption "Installing latest LTS Node..."
  nvm install --lts
  nvm install node
  nvm alias default "lts/*"
  npm config set registry https://registry.npmjs.org/ --global
  npm cache clear --force
  node -v
  corepack enable
  yarn -v

  echo_section "RVM - Ruby Version Manager (With Rails)"
  gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
  \curl -sSL https://get.rvm.io | bash -s head --rails --auto-dotfiles
  rvm -v
  rvm --default use ruby
  ruby -v
  gem install rails
  rails -v

  echo_section "ASDF - Manage multiple runtime versions with a single CLI tool"
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1
}

function install_fonts() {
  echo_title "Installing Nerd Fonts"
  echo_section "Making fonts/ folder"
  mkdir --parents fonts/JetBrainsMono/
  mkdir --parents fonts/MesloLGS/

  echo_section "Downloading JetBrains Mono font"
  pushd fonts/JetBrainsMono || exit
  wget -c -O JetBrainsMono.zip "https://download.jetbrains.com/fonts/JetBrainsMono-2.242.zip"
  unzip JetBrainsMono.zip "fonts/ttf/*.ttf"
  echo_section "Moving JetBrains Mono font"
  mv --force --verbose fonts/ttf/*.ttf ./
  rm -r fonts
  rm JetBrainsMono.zip
  popd || exit

  echo_section "Downloading MesloLGS NF font"
  pushd fonts/MesloLGS || exit
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf"
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf"
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf"
  wget -c "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf"
  popd || exit

  echo_section "Installing fonts required by Oh My Zsh ~> Powerlevel10k"
  sudo mkdir --parents /usr/share/fonts
  sudo mv --force --verbose fonts/* /usr/share/fonts
  fc-cache -v -f

  echo_caption "Removing fonts/ folder from $(pwd)"
  rm -r fonts/

  echo_section "Create Downloads folder"
  mkdir --parents ~/Downloads
}

function install_zsh() {
  echo_title "Z-Shell install"
  echo_caption "Zsh should already be installed, this just to finish it's install"

  echo_caption "Make Zsh the default shell"
  chsh --shell "$(which zsh)"
  $SHELL --version

  echo_caption "Needs to log out and log in to make the changes"
  echo "$SHELL"
}

function install_oh_my_zsh() {
  local ZSH_PLUGINS="(git zsh-autosuggestions zsh-syntax-highlighting asdf nvm node ruby rails docker)"
  readonly ZSH_PLUGINS

  echo_section "Oh My Zsh"

  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    echo_error "ATTENTION - Removing ~/.oh-my-zsh file to reinstall from 0."
    sudo rm --recursive ~/.oh-my-zsh
  fi

  echo_caption "Installing Oh My Zsh..."
  echo_error "TYPE 'Y', THEN 'EXIT', THE SCRIPT IS NOT FINISHED YET"
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  echo_caption "Setting Powerlevel10k theme on ZSH..."
  sudo sed -i 's/^ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

  echo_section "Powerlevel10k for Oh My Zsh"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k

  echo_caption "Updating Powerlevel10k..."
  git -C "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"/themes/powerlevel10k pull

  echo_caption "Install plugins on oh-my-zsh custom plugins folder: $ZSH_PLUGINS"
  git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting

  echo_caption "Adding plugins to ~/.zshrc file..."
  sudo sed -i "s/^plugins=.*/plugins=$ZSH_PLUGINS/" ~/.zshrc
}

function wait_prompt() {
  read -r -p "Press ENTER to continue..."
}
