#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/title-templates.sh

function install_package() {
  local apps=("$1")
  if [[ $# -eq 1 ]]; then
    local install_block="sudo apt install -y"
  else
    local install_block="$2"
  fi

  echo_caption "Runnning: $install_block"
  echo_caption "For each package: ${apps[*]}"

  # Using IFS (Internal Field Separator) to manage arrays
  local counter=0
  while IFS=" " read -ra array; do
    for app in "${array[@]}"; do
      echo_section "($((counter += 1))/${#array[@]}) - ${app}"
      eval "$install_block" "${app}"
    done
  done <<<"${apps[@]}"
}

function pre_ubuntu_setup() {
  echo_title "Pre Ubuntu Setup"
  echo_section "Fix/Update currently installed Packages"

  echo_caption "Fixing broken packages..."
  sudo apt update -y --fix-missing
  sudo dpkg --configure -a # Attempts to fix problems with broken dependencies between program packages.
  sudo apt-get --fix-broken install

  echo_caption "Updating repositories and removing leftovers..."
  sudo apt update -y
  sudo apt autoclean -y  # cleans your local repository of all packages that APT has downloaded.
  sudo apt autoremove -y # removes dependencies that are no longer needed by your System.

  echo_caption "Installing required packages for every script..."
  # 2 Terminal Download Manager | 1 Git (If doesn't have) | 2 Compress/Extract zip files | 1 Tool to change Shell | 1 Z-Shell (ZSH)
  install_package "curl wget git unzip zip zsh"

  fix_time_zone
}

function upgrade_all_ubuntu() {
  echo_caption "Upgrading System..."

  sudo apt dist-upgrade -fy
}
