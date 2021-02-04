# https://linuxhint.com/bash_loop_list_strings/
# Declare an array of string with type

declare -a PacmanApps=(
    ""      # App Name
)

printf "\nInstalling via Pacman...\n"
# Iterate the string array using for loop
for App in ${PacmanApps[@]}; do
    printf "\nInstalling: $App"
    sudo pacman -Sy --noconfirm $App
done
