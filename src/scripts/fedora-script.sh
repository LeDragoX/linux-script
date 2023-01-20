#!/usr/bin/env bash

source ./src/lib/base-script.sh
source ./src/lib/fedora-base-script.sh

function main() {
  configEnv
  scriptLogo
  preFedoraSetup
  installPackagesFedora
  installProgrammingLanguagesWithVersionManagers
  installFonts
  installZsh
  installOhMyZsh
  upgradeAllFedora
}

main
