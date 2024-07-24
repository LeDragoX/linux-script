#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/title-templates.sh

function main_menu() {
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
      set_gpg_key
      wait_prompt
      main_menu
      ;;
    "Create new SSH Key")
      clear
      set_ssh_key
      wait_prompt
      main_menu
      ;;
    "Import GPG and SSH Keys")
      clear
      import_keys_gpg_ssh
      wait_prompt
      main_menu
      ;;
    "Check current GIT profile")
      clear
      check_git_profile
      wait_prompt
      main_menu
      ;;
    "Config. GIT profile")
      clear
      config_git_profile
      wait_prompt
      main_menu
      ;;
    *)
      clear
      echo_error "ERROR: Invalid Option"
      main_menu
      break
      ;;
    esac
    break
  done
}

function enable_ssh_and_gpg_agents() {
  echo_section "Checking if ssh-agent is running before adding keys"
  eval "$(ssh-agent -s)"
  echo
}

function check_git_profile() {
  echo_section "Check GIT Profile"
  echo "Requires Git before"

  echo "Your Git name:   $(git config --global user.name)"
  echo "Your Git email:  $(git config --global user.email)"
  echo "GPG Signing key: $(git config --global user.signingkey)"
  echo "Commit gpgsign:  $(git config --global commit.gpgsign)"
  echo "Default Branch:  $(git config --global init.defaultBranch)"
  echo
}

function config_git_profile() {
  echo_section "Setup Git Profile"
  echo "Requires Git before"

  read -r -p "Set new Git user name (global): " git_user_name
  read -r -p "Set new Git user email (global): " git_user_email
  read -r -p "Set new Git Default Branch (global): " default_branch

  # Use variables to make life easier
  git config --global user.name "$git_user_name"
  git config --global user.email "$git_user_email"
  git config --global init.defaultBranch "$default_branch"

  echo "Your Git name (global):       $(git config --global user.name)"
  echo "Your Git email (global):      $(git config --global user.email)"
  echo "Your Default Branch (global): $(git config --global init.defaultBranch)"
  echo
}

function set_ssh_key() {
  echo_section "Setting SSH Key"

  local ssh_path=~/.ssh
  local ssh_encryption_type=ed25519
  local ssh_default_file_name="id_$ssh_encryption_type"

  echo "Creating folder on '$ssh_path'"
  mkdir --parents "$ssh_path"
  pushd "$ssh_path" || exit

  echo "I recommend you save your passphrase somewhere, in case you don't remember."
  echo "Generating new SSH Key on $ssh_path/$ssh_default_file_name"

  if [[ -f "$ssh_path/$ssh_default_file_name" ]]; then
    echo "$ssh_path/$ssh_default_file_name already exists"
  else
    echo "$ssh_path/$ssh_default_file_name does not exists | Creating..."
    echo "Using your email from git to create a SSH Key: $(git config --global user.email)"
    # Generate a new ssh key, passing every parameter as variables (Make sure to config git first)
    ssh-keygen -t $ssh_encryption_type -C "$(git config --global user.email) SSH Signing Key" -f "$ssh_default_file_name"
  fi

  echo "Validating files permissions"
  chmod 600 "$ssh_default_file_name"

  echo "Adding your private keys"
  ssh-add "$ssh_default_file_name"
  popd || exit
}

function set_gpg_key() {
  echo_section "Setting GPG Key"

  gpg --list-signatures # Use this instead of creating the folder, fix permissions
  pushd ~/.gnupg || exit
  echo_caption "Importing GPG keys"
  gpg --import ./*.gpg

  echo "Setting up GPG signing key"
  # Code adapted from: https://stackoverflow.com/a/66242583        # My key name
  key_id=$(gpg --list-signatures --with-colons | grep 'sig' | grep "$(git config --global user.email)" | head -n 1 | cut -d':' -f5)
  git config --global user.signingkey "$key_id"
  echo "Setting up Commit GPG signing to true"
  # Always commit with GPG signature
  git config --global commit.gpgsign true
  popd || exit
}

function import_keys_gpg_ssh() {
  echo "TIP: Go to the folder using a terminal and type 'pwd', use the output to paste on the request below"
  read -r -p "Select the existing GPG keys folder (accepts only .gpg file format): " folder

  echo_caption "Importing GPG keys from: $folder"
  pushd "$folder" || exit
  gpg --import "$folder"/*.gpg

  # Get the exact key ID from the system
  # Code adapted from: https://stackoverflow.com/a/66242583
  gpg --list-signatures --with-colons | grep 'sig'

  echo_caption "From those keys, select an e-mail address"
  read -r -p "To select one of the keys, type a valid e-mail: " identifier

  key_id=$(gpg --list-signatures --with-colons | grep 'sig' | grep "$identifier" | head -n 1 | cut -d':' -f5)
  echo_error "Using key: $key_id"
  git config --global user.signingkey "$key_id"
  # Always commit with GPG signature
  git config --global commit.gpgsign true
  popd || exit

  echo
  echo "TIP: Go to the folder using a terminal and type 'pwd', use the output to paste on the request below"
  read -r -p "Select the existing SSH keys folder (accepts any file format): " folder

  echo_caption "Importing SSH keys from: $folder"
  pushd "$folder" || exit

  echo "Validating files permissions"
  chmod 600 "$folder"/*

  echo "Adding your private keys"
  ssh-add "$folder"/*
  popd || exit
}

function main() {
  enable_ssh_and_gpg_agents
  config_git_profile
  main_menu
}

main
