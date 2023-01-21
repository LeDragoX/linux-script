#!/usr/bin/env bash

source ./src/lib/base-script.sh

function installPackage() {
  local _apps=($1)
  if [[ $# -eq 1 ]]; then
    local _installBlock="sudo apt install -y"
  else
    local _installBlock="$2"
  fi

  echoCaption "Runnning: $_installBlock"
  echoCaption "For each package: ${_apps[*]}"
  for key in ${!_apps[@]}; do
    echoSection "($(($key + 1))/${#_apps[@]}) - ${_apps[$key]}"
    eval $_installBlock ${_apps[$key]}
  done
}

function preUbuntuSetup() {
  echoTitle "Pre Ubuntu Setup"
  echoSection "Fix/Update currently installed Packages"

  echoCaption "Fixing broken packages..."
  sudo apt update -y --fix-missing
  sudo dpkg --configure -a # Attempts to fix problems with broken dependencies between program packages.
  sudo apt-get --fix-broken install

  echoCaption "Updating repositories and removing leftovers..."
  sudo apt update -y
  sudo apt autoclean -y  # cleans your local repository of all packages that APT has downloaded.
  sudo apt autoremove -y # removes dependencies that are no longer needed by your System.

  echoCaption "Installing required packages for every script..."
  # 2 Terminal Download Manager | 1 Git (If doesn't have) | 2 Compress/Extract zip files | 1 Tool to change Shell | 1 Z-Shell (ZSH)
  installPackage "curl wget git unzip zip zsh"

  fixTimeZone
}

function upgradeAllUbuntu() {
  echoCaption "Upgrading System..."

  sudo apt dist-upgrade -fy
}
