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

  MIT License

  Copyright (c) 2021 Plínio Larrubia

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.