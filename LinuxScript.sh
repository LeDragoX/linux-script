#!/bin/sh

function main() {

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
  echo '                                    Made by LeDragoX'
  echo "<=====================================================================================>"

  PS3="Select the script: "
  select Script in arch-script.sh ubuntu-script.sh wsl2-script.sh; do
    echo "You chose the $Script"
    case $Script in arch-script.sh)
      echo "I use Arch btw..."
      ./src/scripts/$Script
      ;;
    ubuntu-script.sh)
      echo "Ubuntu"
      ./src/scripts/$Script
      ;;
    wsl2-ubuntu-script.sh)
      echo "WSL2 Ubuntu"
      ./src/scripts/$Script
      ;;
    wsl2-arch-script.sh)
      echo "WSL2 Arch"
      ./src/scripts/$Script
      ;;
    *)
      echo "ERROR: Invalid Option"
      ;;
    esac
    break
  done

}

main
