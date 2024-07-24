#!/usr/bin/env bash

function echo_title() {
  local text="$1"
  echo && echo "<•••••••••••••••••••••••••••••••••••••••••••••••••••••••>"
  echo "   $text"
  echo "<•••••••••••••••••••••••••••••••••••••••••••••••••••••••>"
}

function echo_section() {
  local text="$1"
  echo && echo "<••••••••••{ $text }••••••••••>"
}

function echo_caption() {
  local text="$1"
  echo "••> $1"
}

# Code from: https://stackoverflow.com/a/18216114
function echo_error() {
  printf '\E[31m'
  echo "$@"
  printf '\E[0m'
}
