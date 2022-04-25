#!/usr/bin/env bash

source ./src/lib/base-script.sh

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

  PS3="Select the script: "
  select Script in arch-script.sh ubuntu-script.sh wsl-ubuntu-script.sh wsl-arch-pre-setup.sh wsl-arch-script.sh git-gpg-ssh-setup.sh; do
    echo "You chose the $Script"
    case $Script in arch-script.sh)
      echo "- I use Arch btw..." && echo
      ./src/scripts/$Script
      ;;
    ubuntu-script.sh)
      echo "- Ubuntu" && echo
      ./src/scripts/$Script
      ;;
    wsl-ubuntu-script.sh)
      echo "- Ubuntu WSL" && echo
      ./src/scripts/$Script
      ;;
    wsl-arch-pre-setup.sh)
      echo "- Arch WSL Pre Setup" && echo
      ./src/scripts/$Script
      ;;
    wsl-arch-script.sh)
      echo "- Arch WSL" && echo
      ./src/scripts/$Script
      ;;
    git-gpg-ssh-setup.sh)
      echo "- Git, GPG and SSH setup (UTILS)" && echo
      ./src/utils/$Script
      ;;
    *)
      echo "ERROR: Invalid Option"
      ;;
    esac
    break
  done

  echo "EXIT CODE: $?"
}

main
