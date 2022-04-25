#!/usr/bin/env bash

source ./src/lib/base-script.sh

function echoUbuntuScriptLogo() {
  echo '<====================================================================================================>'
  echo '888     888 888                        888              .d8888b.                   d8b          888   '
  echo '888     888 888                        888             d88P  Y88b                  Y8P          888   '
  echo '888     888 888                        888             Y88b.                                    888   '
  echo '888     888 88888b.  888  888 88888b.  888888 888  888  "Y888b.    .d8888b 888d888 888 88888b.  888888'
  echo '888     888 888 "88b 888  888 888 "88b 888    888  888     "Y88b. d88P"    888P"   888 888 "88b 888   '
  echo '888     888 888  888 888  888 888  888 888    888  888       "888 888      888     888 888  888 888   '
  echo 'Y88b. .d88P 888 d88P Y88b 888 888  888 Y88b.  Y88b 888 Y88b  d88P Y88b.    888     888 888 d88P Y88b. '
  echo ' "Y88888P"  88888P"   "Y88888 888  888  "Y888  "Y88888  "Y8888P"   "Y8888P 888     888 88888P"   "Y888'
  echo '                                                                                       888            '
  echo '                                                                                       888            '
  echo '                                                                                       888            '
  echo '<====================================================================================================>'
}

function echoWSLUbuntuScriptLogo() {
  echo '<=====================================================================================================>'
  echo '                               888       888  .d8888b.  888       .d8888b.                             '
  echo '                               888   o   888 d88P  Y88b 888      d88P  Y88b                            '
  echo '                               888  d8b  888 Y88b.      888             888                            '
  echo '                               888 d888b 888  "Y888b.   888           .d88P                            '
  echo '                               888d88888b888     "Y88b. 888       .od888P"                             '
  echo '                               88888P Y88888       "888 888      d88P"                                 '
  echo '                               8888P   Y8888 Y88b  d88P 888      888"                                  '
  echo '                               888P     Y888  "Y8888P"  88888888 888888888                             '
  echo '                                                                                                       '
  echo '888     888 888                        888              .d8888b.                   d8b          888    '
  echo '888     888 888                        888             d88P  Y88b                  Y8P          888    '
  echo '888     888 888                        888             Y88b.                                    888    '
  echo '888     888 88888b.  888  888 88888b.  888888 888  888  "Y888b.    .d8888b 888d888 888 88888b.  888888 '
  echo '888     888 888 "88b 888  888 888 "88b 888    888  888     "Y88b. d88P"    888P"   888 888 "88b 888    '
  echo '888     888 888  888 888  888 888  888 888    888  888       "888 888      888     888 888  888 888    '
  echo 'Y88b. .d88P 888 d88P Y88b 888 888  888 Y88b.  Y88b 888 Y88b  d88P Y88b.    888     888 888 d88P Y88b.  '
  echo ' "Y88888P"  88888P"   "Y88888 888  888  "Y888  "Y88888  "Y8888P"   "Y8888P 888     888 88888P"   "Y888 '
  echo '                                                                                       888             '
  echo '                                                                                       888             '
  echo '                                                                                       888             '
  echo '<=====================================================================================================>'
}

function fixPackagesUbuntu() {
  echo "- Fix/Update currently installed Packages"

  echo "[Adapted] Ubuntu fix broken packages (best solution)"
  sudo apt update -y --fix-missing
  sudo dpkg --configure -a # Attempts to fix problems with broken dependencies between program packages.
  sudo apt-get --fix-broken install
}

function updateAllPackagesUbuntu() {
  echo "- Update System"

  sudo apt update -y
  sudo apt dist-upgrade -fy
  sudo apt autoclean -y  # cleans your local repository of all packages that APT has downloaded.
  sudo apt autoremove -y # removes dependencies that are no longer needed by your System.
}
