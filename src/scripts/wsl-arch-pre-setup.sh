#!/usr/bin/env bash

source ./src/lib/arch-base-script.sh
source ./src/lib/base-script.sh

function setupAccounts() {
  _currentUser=$(id -u)
  if [[ "$_currentUser" -ne 0 ]]; then
    echoError "Please run as root user!"
    exit 1
  fi

  echoSection 'New ROOT Password'
  passwd 'root'
  echo "%wheel ALL=(ALL) ALL" >/etc/sudoers.d/wheel

  echoSection 'New USER account'

  read -r -p "Input your user name: " _userName
  useradd -m -G wheel -s /bin/bash $_userName
  echo "Now set a password for $_userName..."
  passwd $_userName

  echoError "!!! IMPORTANT !!!"
  echo "To set the new Default user to $_userName..."
  echo "Copy the follow command on the Powershell:" && echo
  echo "Arch.exe config --default-user $_userName" && echo
  echo "At the end close the terminal"
}

function main() {
  configEnv
  echoWSLArchScriptLogo
  setupAccounts
}

main
