#!/bin/sh

function echoTitle() {
  local text="$1"
  echo
  echo "<====================[ $text ]====================>"
  echo
}

function echoSection() {
  local text="$1"
  echo
  echo "<==========[ $text ]==========>"
  echo
}

function echoCaption() {
  local text="$1"
  echo "--> $1"
  echo
}
