#!/usr/bin/env bash

source ./src/lib/base-script.sh

function mainMenu() {
  PS3="Select an option to see the scripts: "
  select option in "Exit" "Arch Scripts" "Ubuntu Scripts" "Utilities Scripts"; do
    echo "You choose $option"
    case $option in
    "Exit")
      echo "Exiting..." && echo
      break
      ;;
    "Arch Scripts")
      echo "- Arch" && echo
      archMenu
      ;;
    "Ubuntu Scripts")
      echo "- Ubuntu" && echo
      ubuntuMenu
      ;;
    "Utilities Scripts")
      echo "- Utilities" && echo
      utilitiesMenu
      ;;
    *)
      echoError "ERROR: Invalid Option"
      main
      ;;
    esac
    break
  done
}

function archMenu() {
  clear
  PS3="Select the script: "
  select script in "Go Back" "arch-script.sh" "wsl-arch-pre-setup.sh" "wsl-arch-script.sh"; do
    echo "You chose the $script"
    case $script in
    "Go Back")
      main
      ;;
    "arch-script.sh")
      echo "- I use Arch btw..." && echo
      ./src/scripts/$script
      ;;
    "wsl-arch-pre-setup.sh")
      echo "- Arch WSL Pre Setup" && echo
      ./src/scripts/$script
      ;;
    "wsl-arch-script.sh")
      echo "- Arch WSL" && echo
      ./src/scripts/$script
      ;;
    *)
      echoError "ERROR: Invalid Option"
      archMenu
      ;;
    esac
    break
  done
}

function ubuntuMenu() {
  clear
  PS3="Select the script: "
  select script in "Go Back" ubuntu-script.sh wsl-ubuntu-script.sh; do
    echo "You chose the $script"
    case $script in
    "Go Back")
      main
      ;;
    ubuntu-script.sh)
      echo "- Ubuntu" && echo
      ./src/scripts/$script
      ;;
    wsl-ubuntu-script.sh)
      echo "- Ubuntu WSL" && echo
      ./src/scripts/$script
      ;;
    *)
      echoError "ERROR: Invalid Option"
      ubuntuMenu
      ;;
    esac
    break
  done
}

function utilitiesMenu() {
  clear
  PS3="Select the script: "
  select script in "Go Back" git-gpg-ssh-setup.sh; do
    echo "You chose the $script"
    case $script in
    "Go Back")
      main
      ;;
    git-gpg-ssh-setup.sh)
      echo "- Git, GPG and SSH setup (UTILS)" && echo
      ./src/utils/$script
      ;;
    *)
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
