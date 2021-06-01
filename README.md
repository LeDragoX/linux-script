<h1>
  <img width=4% src=./images/LinuxTux.png>
  LinuxScript
</h1>

### Resume
    These scripts just install my apps in a OS post-install.

### How to Use

  Open the terminal and paste these lines:

## <img width=4% src=./images/Ubuntu-icon.webp> For Ubuntu based users, made in Linux Mint.

```s
# Dependencies (Ubuntu)
sudo apt install -fy git

git clone https://github.com/LeDragoX/LinuxScript.git ~/Downloads/LinuxScript
cd ~/Downloads/LinuxScript
chmod +x *.sh && yes | ./UbuntuScript.sh
```

## <img width=4% src=./images/ArchLinux-icon.png> For Arch based users, made in Manjaro.
```s
# Dependencies (Arch)
sudo pacman -Sy --noconfirm git

git clone https://github.com/LeDragoX/LinuxScript.git ~/Downloads/LinuxScript
cd ~/Downloads/LinuxScript
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
- Lutris
- Microsoft Edge
- ONLYOffice
- Parsec (*Ubuntu only*)
- qBittorrent
- Spotify
- Steam
- SMPlayer
- **[UBUNTU ONLY]** SVP 4 (install-svp.sh)
- Terminator
- VLC
- VS Code (*Uses Snap on Arch*)

### Will be unninstalled:
- **[UBUNTU ONLY]** MPV (If the SVP script doesn't work correctly)

## License

Check the License file [here](LICENSE).