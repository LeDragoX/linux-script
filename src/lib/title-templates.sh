function echoTitle() {
  local text="$1"
  echo "\n<====================[ $text ]====================>\n"
}

function echoSection() {
  local text="$1"
  echo "\n<==========[ $text ]==========>\n"
}

function echoCaption() {
  local text="$1"
  echo "--> $1\n"
}
