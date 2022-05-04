#!/usr/bin/env bash

source ./src/lib/arch-base-script.sh
source ./src/lib/base-script.sh

function main() {
  configEnv
  echoWSLArchScriptLogo
  preArchSetup
  sudo pacman -S --needed --noconfirm base-devel gcc man-db man-pages --ignore=fakeroot # Required To compilation proccesses | The parameter avoid an install bug on WSL
  installPackageManagers
  installFonts
  installZsh
  installOhMyZsh
}

main
