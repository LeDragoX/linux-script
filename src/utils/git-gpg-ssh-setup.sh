#!/usr/bin/env bash

source ./src/lib/title-templates.sh

function main_menu() {
  clear
  PS3="Select an option: "
  select option in "Exit" "Create new GPG key" "Create new SSH key" "Import GPG and SSH Keys" "Check current GIT profile" "Config. GIT profile"; do
    echo "You chose to $option"
    case $option in
    "Exit")
      echo "Exiting..." && echo
      break
      ;;
    "Create new GPG Key")
      setGPGKey
      wait_prompt
      main_menu
      ;;
    "Create new SSH Key")
      setSSHKey
      wait_prompt
      main_menu
      ;;
    "Import GPG and SSH Keys")
      importKeysGpgSsh
      wait_prompt
      main_menu
      ;;
    "Check current GIT profile")
      checkGitProfile
      wait_prompt
      main_menu
      ;;
    "Config. GIT profile")
      configGitProfile
      wait_prompt
      main_menu
      ;;
    *)
      echoError "ERROR: Invalid Option"
      main_menu
      ;;
    esac
    break
  done
}

function enableSshAndGpgAgent() {
  echoSection "Checking if ssh-agent is running before adding keys"
  eval "$(ssh-agent -s)"
  echo
}

function checkGitProfile() {
  echoSection "Check GIT Profile"
  echo "Requires Git before"

  # Use variables to make life easier
  local _gitUserName="$(git config --global user.name)"
  local _gitUserEmail="$(git config --global user.email)"

  echo "Your Git name:   $_gitUserName"
  echo "Your Git email:  $_gitUserEmail"
  echo "GPG Signing key: $(git config --global user.signingkey)"
  echo "Commit gpgsign:  $(git config --global commit.gpgsign)"
  echo
}

function configGitProfile() {
  echoSection "Setup Git Profile"
  echo "Requires Git before"

  read -p "Set new Git user name (global):  " _gitUserName
  read -p "Set new Git user email (global): " _gitUserEmail

  # Use variables to make life easier
  git config --global user.name "$_gitUserName"
  git config --global user.email "$_gitUserEmail"

  echo "Your Git name (global):  $(git config --global user.name)"
  echo "Your Git email (global): $(git config --global user.email)"
  echo
}

function setSSHKey() {
  echoSection "Setting SSH Key"

  local _sshPath=~/.ssh
  local _sshEncryptionType=ed25519
  local _sshDefaultFileName="id_$_sshEncryptionType"

  echo "Creating folder on '$_sshPath'"
  mkdir --parents "$_sshPath"
  pushd "$_sshPath"

  echo "I recommend you save your passphrase somewhere, in case you don't remember."
  echo "Generating new SSH Key on $_sshPath/$_sshDefaultFileName"

  if [[ -f "$_sshPath/$_sshDefaultFileName" ]]; then
    echo "$_sshPath/$_sshDefaultFileName already exists"
  else
    echo "$_sshPath/$_sshDefaultFileName does not exists | Creating..."
    echo "Using your email from git to create a SSH Key: $(git config --global user.email)"
    # Generate a new ssh key, passing every parameter as variables (Make sure to config git first)
    ssh-keygen -t $_sshEncryptionType -C "$(git config --global user.email)" -f "$_sshDefaultFileName"
  fi

  echo "Validating files permissions"
  chmod 600 "$_sshDefaultFileName"

  echo "Adding your private keys"
  ssh-add "$_sshDefaultFileName"
  popd
}

function setGPGKey() {
  echoSection "Setting GPG Key"

  gpg --list-signatures # Use this instead of creating the folder, fix permissions
  pushd ~/.gnupg
  echoCaption "Importing GPG keys"
  gpg --import *.gpg

  echo "Setting up GPG signing key"
  # Code adapted from: https://stackoverflow.com/a/66242583        # My key name
  key_id=$(gpg --list-signatures --with-colons | grep 'sig' | grep "$(git config --global user.email)" | head -n 1 | cut -d':' -f5)
  git config --global user.signingkey $key_id
  echo "Setting up Commit GPG signing to true"
  # Always commit with GPG signature
  git config --global commit.gpgsign true
  popd
}

function importKeysGpgSsh() {
  echo "TIP: Go to the folder using a terminal and type 'pwd', use the output to paste on the request below"
  read -p "Select the existing GPG keys folder (accepts only .gpg file format): " folder

  echoCaption "Importing GPG keys from: $folder"
  pushd "$folder"
  gpg --import $folder/*.gpg

  # Get the exact key ID from the system
  # Code adapted from: https://stackoverflow.com/a/66242583
  key_id=$(gpg --list-signatures --with-colons | grep 'sig' | head -n 1 | cut -d':' -f5)
  git config --global user.signingkey $key_id
  # Always commit with GPG signature
  git config --global commit.gpgsign true
  popd

  echo
  echo "TIP: Go to the folder using a terminal and type 'pwd', use the output to paste on the request below"
  read -p "Select the existing SSH keys folder (accepts any file format): " folder

  echoCaption "Importing SSH keys from: $folder"
  pushd "$folder"

  echo "Validating files permissions"
  chmod 600 $folder/*

  echo "Adding your private keys"
  ssh-add $folder/*
  popd
}

function wait_prompt() {
  read -r -p "Press ENTER to continue..."
}

function main() {
  enableSshAndGpgAgent
  configGit
  main_menu
}

main
