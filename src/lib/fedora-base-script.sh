#!/bin/bash

source ./src/lib/base-script.sh
source ./src/lib/install-package.sh
source ./src/lib/title-templates.sh

function pre_fedora_setup() {
  # 2 Terminal Download Manager | 1 Git (If doesn't have) | 2 Compress/Extract zip files | 1 Tool to change Shell | 1 Z-Shell (ZSH) | 1 Install chsh commands + others
  install_package_fedora "curl wget git unzip zip which zsh util-linux-user"

  fix_time_zone
}

function upgrade_all_fedora() {
  sudo dnf upgrade
  install_package_fedora "dnf-plugin-system-upgrade"
}
