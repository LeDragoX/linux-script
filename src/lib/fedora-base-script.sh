#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/title-templates.sh

function installPackage() {
  local _apps=("$1")
  if [[ $# -eq 1 ]]; then
    local _installBlock="sudo dnf install -y"
  else
    local _installBlock="$2"
  fi

  echoCaption "Runnning: $_installBlock"
  echoCaption "For each package: ${_apps[*]}"

  # Using IFS (Internal Field Separator) to manage arrays
  local _counter=0
  while IFS=" " read -ra _array; do
    for _app in "${_array[@]}"; do
      echoSection "($((_counter += 1))/${#_array[@]}) - ${_app}"
      eval "$_installBlock" "${_app}"
    done
  done <<<"${_apps[@]}"
}

function preFedoraSetup() {
  # 2 Terminal Download Manager | 1 Git (If doesn't have) | 2 Compress/Extract zip files | 1 Tool to change Shell | 1 Z-Shell (ZSH) | 1 Install chsh commands + others
  installPackage "curl wget git unzip zip which zsh util-linux-user"

  fixTimeZone
}

function upgradeAllFedora() {
  sudo dnf upgrade
  installPackage "dnf-plugin-system-upgrade"
}
