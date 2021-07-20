<h1>
  <img width=4% src=./lib/images/linux-tux.png>
  Linux Scripto
</h1>

## Resume
  These scripts just install my apps in a OS post-install.

## Usage

  Open the terminal and paste these lines:

## <img width=4% src=./lib/images/ubuntu-icon.webp> For [Ubuntu](src/UbuntuScript.sh) or [WSL2](src/WSL2UbuntuScript.sh) users.

```sh
sudo apt install -fy git

mkdir ~/Downloads
git clone https://github.com/LeDragoX/LinuxScript.git ~/Downloads/LinuxScript
cd ~/Downloads/LinuxScript/src
chmod +x *.sh && yes | ./UbuntuScript.sh # OR ./WSL2UbuntuScript.sh
```

## <img width=4% src=./lib/images/arch-linux-icon.png> For [Arch](src/ArchScript.sh) users, made in Manjaro.
```sh
sudo pacman -Sy --noconfirm git

mkdir ~/Downloads
git clone https://github.com/LeDragoX/LinuxScript.git ~/Downloads/LinuxScript
cd ~/Downloads/LinuxScript/src
chmod +x *.sh && yes | ./ArchScript.sh
```

### Will be installed:
- Discord
- Microsoft Edge (*Arch only [WIP]*)
- GDebi
- Gimp
- Google Chrome
- GParted
- Grub Customizer
- Microsoft Edge
- ONLYOffice
- Parsec (*Ubuntu only*)
- qBittorrent
- Spotify
- SMPlayer
- **[UBUNTU ONLY]** SVP 4 (install-svp.sh)
- Terminator
- VLC
- VS Code (*Uses Snap on Arch*)

### Will be unninstalled:
- **[UBUNTU ONLY]** MPV (If the SVP script doesn't work correctly)

## License

Check the License file [here](LICENSE).