#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/title-templates.sh

function install_package() {
  local apps=("$1")
  if [[ $# -eq 1 ]]; then
    local install_block="sudo dnf install -y"
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

function pre_fedora_setup() {
  # 2 Terminal Download Manager | 1 Git (If doesn't have) | 2 Compress/Extract zip files | 1 Tool to change Shell | 1 Z-Shell (ZSH) | 1 Install chsh commands + others
  install_package "curl wget git unzip zip which zsh util-linux-user"

  fix_time_zone
}

function upgrade_all_fedora() {
  sudo dnf upgrade
  install_package "dnf-plugin-system-upgrade"
}
