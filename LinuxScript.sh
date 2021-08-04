#!/bin/bash

function main() {

  PS3="Select the script: "
  select Script in arch-script.sh ubuntu-script.sh wsl2-script.sh; do
    echo "You chose the $Script"
    case $Script in arch-script.sh)
      echo "I use Arch btw..."
      ./src/scripts/$Script
      ;;
    ubuntu-script.sh)
      echo "UwUbuntu"
      ./src/scripts/$Script
      ;;
    wsl2-script.sh)
      echo "Windows Subsystem for Linux 2"
      ./src/scripts/$Script
      ;;
    *) echo "ERROR: Invalid Option" ;;
    esac
    break
  done

}

main
