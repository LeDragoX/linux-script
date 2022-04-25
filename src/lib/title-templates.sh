#!/usr/bin/env bash

function echoTitle() {
  local _text="$1"
  echo "<===================={ $_text }====================>" && echo
}

function echoSection() {
  local _text="$1"
  echo "<=========={ $_text }==========>" && echo
}

function echoCaption() {
  local _text="$1"
  echo "==> $1" && echo
}

# Code from: https://stackoverflow.com/a/18216114
function echoError() {
  printf '\E[31m'
  echo "$@"
  printf '\E[0m'
}
