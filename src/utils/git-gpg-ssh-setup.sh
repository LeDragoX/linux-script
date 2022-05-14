#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/title-templates.sh

function mainMenu() {
  PS3="Select an option: "
  select option in "Exit" "Create new GPG key" "Create new SSH key" "Import GPG and SSH Keys" "Check current GIT profile" "Config. GIT profile"; do
    echo "You chose to $option"
    case $option in
    "Exit")
      clear
      echo "Exiting..." && echo
      break
      ;;
    "Create new GPG Key")
      clear
      setGPGKey
      waitPrompt
      mainMenu
      ;;
    "Create new SSH Key")
      clear
      setSSHKey
      waitPrompt
      mainMenu
      ;;
    "Import GPG and SSH Keys")
      clear
      importKeysGpgSsh
      waitPrompt
      mainMenu
      ;;
    "Check current GIT profile")
      clear
      checkGitProfile
      waitPrompt
      mainMenu
      ;;
    "Config. GIT profile")
      clear
      configGitProfile
      waitPrompt
      mainMenu
      ;;
    *)
      clear
      echoError "ERROR: Invalid Option"
      mainMenu
      break
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

  echo "Your Git name:   $(git config --global user.name)"
  echo "Your Git email:  $(git config --global user.email)"
  echo "GPG Signing key: $(git config --global user.signingkey)"
  echo "Commit gpgsign:  $(git config --global commit.gpgsign)"
  echo "Default Branch:  $(git config --global init.defaultBranch)"
  echo
}

function configGitProfile() {
  echoSection "Setup Git Profile"
  echo "Requires Git before"

  read -p "Set new Git user name (global):      " _gitUserName
  read -p "Set new Git user email (global):     " _gitUserEmail
  read -p "Set new Git Default Branch (global): " _defaultBranch

  # Use variables to make life easier
  git config --global user.name "$_gitUserName"
  git config --global user.email "$_gitUserEmail"
  git config --global init.defaultBranch "$_defaultBranch"

  echo "Your Git name (global):       $(git config --global user.name)"
  echo "Your Git email (global):      $(git config --global user.email)"
  echo "Your Default Branch (global): $(git config --global init.defaultBranch)"
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
    ssh-keygen -t $_sshEncryptionType -C "$(git config --global user.email) SSH Signing Key" -f "$_sshDefaultFileName"
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
  git config --global user.signingkey $_key_id
  echo "Setting up Commit GPG signing to true"
  # Always commit with GPG signature
  git config --global commit.gpgsign true
  popd
}

function importKeysGpgSsh() {
  echo "TIP: Go to the folder using a terminal and type 'pwd', use the output to paste on the request below"
  read -p "Select the existing GPG keys folder (accepts only .gpg file format): " _folder

  echoCaption "Importing GPG keys from: $_folder"
  pushd "$_folder"
  gpg --import $_folder/*.gpg

  # Get the exact key ID from the system
  # Code adapted from: https://stackoverflow.com/a/66242583
  echo $(gpg --list-signatures --with-colons | grep 'sig')

  echoCaption "From those keys, select an e-mail address"
  read -p "To select one of the keys, type a valid e-mail: " _identifier

  _key_id=$(gpg --list-signatures --with-colons | grep 'sig' | grep "$_identifier" | head -n 1 | cut -d':' -f5)
  echoError "Using key: $_key_id"
  git config --global user.signingkey $_key_id
  # Always commit with GPG signature
  git config --global commit.gpgsign true
  popd

  echo
  echo "TIP: Go to the folder using a terminal and type 'pwd', use the output to paste on the request below"
  read -p "Select the existing SSH keys folder (accepts any file format): " _folder

  echoCaption "Importing SSH keys from: $_folder"
  pushd "$_folder"

  echo "Validating files permissions"
  chmod 600 $_folder/*

  echo "Adding your private keys"
  ssh-add $_folder/*
  popd
}

function main() {
  enableSshAndGpgAgent
  configGit
  mainMenu
}

main
