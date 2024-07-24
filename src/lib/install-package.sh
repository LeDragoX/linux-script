#!/bin/bash

source ./src/lib/title-templates.sh

# TODO: detect the OS package manager and do it automatically
# TODO 2: Allow to use flags such as:
# - Per Distro: --apt --dnf --aur (with yay) --pacman
# - Globally: --snap --flatpak (--nix?)
# - More options: --single-install (default) --multiple-install --add-apt-repo
function install_package() {
  local apps=("$1")
  if [[ $# -eq 1 ]]; then
    echo_error "Package install command missing!!! Quitting..." || exit
  else
    local install_block="$2"
  fi

  echo_caption "Runnning: $install_block"
  echo_caption "For each package: ${apps[*]}"

  # Using IFS (Internal Field Separator) to manage arrays
  local counter=0
  while IFS=" " read -ra apps; do
    for app in "${apps[@]}"; do
      echo_section "($((counter += 1))/${#apps[@]}) - ${app}"
      eval "$install_block" "${app}"
    done
  done <<<"${apps[@]}"
}

function install_package_flatpak() {
  if [[ $# -eq 1 ]]; then
    install_package "$1" "flatpak install flathub --system -y"
  elif [[ $# -eq 2 ]]; then
    install_package "$1" "$2"
  fi
}

function install_package_arch() {
  if [[ $# -eq 1 ]]; then
    install_package "$1" "sudo pacman -S --needed --noconfirm"
  elif [[ $# -eq 2 ]]; then
    install_package "$1" "$2"
  fi
}

function install_package_fedora() {
  if [[ $# -eq 1 ]]; then
    install_package "$1" "sudo dnf install -y"
  elif [[ $# -eq 2 ]]; then
    install_package "$1" "$2"
  fi
}

function install_package_ubuntu() {
  if [[ $# -eq 1 ]]; then
    install_package "$1" "sudo apt install -y"
  elif [[ $# -eq 2 ]]; then
    install_package "$1" "$2"
  fi
}
