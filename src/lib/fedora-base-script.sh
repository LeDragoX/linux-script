#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/title-templates.sh

function installPackage() {
  local _apps=($1)
  if [[ $# -eq 1 ]]; then
    local _installBlock="sudo dnf install -y --setopt='fastestmirror=True max_parallel_downloads=5'"
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

function preFedoraSetup() {
  # 2 Terminal Download Manager | 1 Git (If doesn't have) | 2 Compress/Extract zip files | 1 Tool to change Shell | 1 Z-Shell (ZSH) | 1 Install chsh commands + others
  installPackage "curl wget git unzip zip which zsh util-linux-user"

  fixTimeZone
}

function installPackagesFedora() {

}

function upgradeAllFedora() {
  sudo dnf upgrade --refresh
  installPackage "dnf-plugin-system-upgrade"
}
