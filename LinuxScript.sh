#!/usr/bin/env bash

source ./src/lib/base-script.sh

function mainMenu() {
  PS3="Select an option to see the scripts: "
  select option in "Exit" "Arch Scripts" "Ubuntu Scripts" "Utilities Scripts"; do
    echo "You choose $option"
    case $option in
    "Exit")
      clear
      echo "Exiting..." && echo
      break
      ;;
    "Arch Scripts")
      clear
      echoCaption "Arch"
      archMenu
      ;;
    "Ubuntu Scripts")
      clear
      echoCaption "Ubuntu"
      ubuntuMenu
      ;;
    "Utilities Scripts")
      clear
      echoCaption "Utilities"
      utilitiesMenu
      ;;
    *)
      clear
      echoError "ERROR: Invalid Option"
      main
      break
      ;;
    esac
    break
  done
}

function archMenu() {
  PS3="Select the script: "
  select script in "Go Back" "arch-script-menu.sh"; do
    echo "You chose the $script"
    case $script in
    "Go Back")
      clear
      main
      ;;
    "arch-script-menu.sh")
      clear
      echoCaption "I use Arch btw..."
      ./src/scripts/$script
      ;;
    *)
      clear
      echoError "ERROR: Invalid Option"
      archMenu
      ;;
    esac
    break
  done
}

function ubuntuMenu() {
  PS3="Select the script: "
  select script in "Go Back" ubuntu-script.sh wsl-ubuntu-script.sh; do
    echo "You chose the $script"
    case $script in
    "Go Back")
      clear
      main
      ;;
    ubuntu-script.sh)
      clear
      echoCaption "Ubuntu"
      ./src/scripts/$script
      ;;
    wsl-ubuntu-script.sh)
      clear
      echoCaption "Ubuntu WSL"
      ./src/scripts/$script
      ;;
    *)
      clear
      echoError "ERROR: Invalid Option"
      ubuntuMenu
      ;;
    esac
    break
  done
}

function utilitiesMenu() {
  PS3="Select the script: "
  select script in "Go Back" git-gpg-ssh-setup.sh; do
    echo "You chose the $script"
    case $script in
    "Go Back")
      clear
      main
      ;;
    git-gpg-ssh-setup.sh)
      clear
      echoCaption "Git, GPG and SSH setup (UTILS)"
      ./src/utils/$script
      ;;
    *)
      clear
      echoError "ERROR: Invalid Option"
      utilitiesMenu
      ;;
    esac
    break
  done
}

function main() {
  clear
  echo "<=====================================================================================>"
  echo '888      d8b                             .d8888b.                   d8b          888   '
  echo '888      Y8P                            d88P  Y88b                  Y8P          888   '
  echo '888                                     Y88b.                                    888   '
  echo '888      888 88888b.  888  888 888  888  "Y888b.    .d8888b 888d888 888 88888b.  888888'
  echo '888      888 888 "88b 888  888 `Y8bd8P"     "Y88b. d88P"    888P"   888 888 "88b 888   '
  echo '888      888 888  888 888  888   X88K         "888 888      888     888 888  888 888   '
  echo '888      888 888  888 Y88b 888 .d8""8b. Y88b  d88P Y88b.    888     888 888 d88P Y88b. '
  echo '88888888 888 888  888  "Y88888 888  888  "Y8888P"   "Y8888P 888     888 88888P"   "Y888'
  echo '                                                                        888            '
  echo '                                                                        888            '
  echo '                                                                        888            '
  echo "<=====================================================================================>"
  echoError '                                    Made by LeDragoX'
  echo "<=====================================================================================>"

  mainMenu
  echo "EXIT CODE: $?"
}

main
