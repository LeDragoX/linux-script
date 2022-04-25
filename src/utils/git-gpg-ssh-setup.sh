#!/usr/bin/env bash

source ./src/lib/title-templates.sh

function enableSshAndGpgAgent() {
  echoSection "Checking if ssh-agent is running before adding keys"
  eval "$(ssh-agent -s)"
  echo
}

function configGit() {
  echoSection "Set Up Git Commits Signature (Verified on Git)"
  echo "Requires Git before"

  # Use variables to make life easier
  local _gitUserName="$(git config --global user.name)"
  local _gitUserEmail="$(git config --global user.email)"
  echo
}

function setSSHKey() {
  echoSection "Setting SSH Key"

  local _sshPath=~/.ssh
  local _sshEncryptionType=ed25519
  local _sshDefaultFileName="id_$_sshEncryptionType"
  local _sshAltFile="id_$_sshEncryptionType" # Need to be checked

  echo "Creating folder on '$_sshPath'"
  mkdir --parents "$_sshPath"
  pushd "$_sshPath"

  echo "I recommend you save your passphrase somewhere, in case you don't remember."
  echo "Generating new SSH Key on $_sshPath\\$_sshDefaultFileName"

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
  echo
}

function setGPGKey() {
  echoSection "Setting GPG Key"

  gpg --list-signatures # Use this instead of creating the folder, fix permissions
  pushd ~/.gnupg
  # Import GPG keys
  gpg --import *.gpg
  # Get the exact key ID from the system
  # Code adapted from: https://stackoverflow.com/a/66242583        # My key name
  key_id=$(gpg --list-signatures --with-colons | grep 'sig' | grep "$(git config --global user.email)" | head -n 1 | cut -d':' -f5)
  git config --global user.signingkey $key_id
  # Always commit with GPG signature
  git config --global commit.gpgsign true
  popd
  echo
}

function main() {
  enableSshAndGpgAgent
  configGit
  setSSHKey
  setGPGKey
}

main
