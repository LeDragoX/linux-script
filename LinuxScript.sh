#!/bin/bash

function main() {

  pushd src/

  PS3="Select the script: "
  select Script in arch-script.sh ubuntu-script.sh wsl2-script.sh; do
    printf "You chose the $Script"
    break
  done

  case $Script in arch-script)
    printf "I use Arch btw..."
    source $Script
    ;;
  ubuntu-script.sh)
    printf "UwUbuntu!"
    source $Script
    ;;
  wsl2-script.sh)
    printf "Windows Subsystem for Linux!"
    source $Script
    ;;
  *) echo "ERROR: Invalid Option!" ;;
  esac

  popd

}

main
