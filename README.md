<h1 align="center">
  <img width=4% src=./src/lib/images/linux-tux.png>
  Linux Script
</h1>

## 📄 Resume

Script that configure my Linux post-install.

## ❗ Before running

Open the terminal and paste these lines:

### <img width="4%" src="./src/lib/images/ubuntu-icon.webp" /> For [Ubuntu (or based distros)](src/scripts/ubuntu-script.sh) or [WSL2](src/scripts/wsl2-script.sh) users.

```sh
sudo apt install -y git
```

### <img width="4%" src="./src/lib/images/arch-linux-icon.png" /> For [Arch (or pacman based distros)](src/scripts/arch-script.sh) users, made in Arch & Manjaro.

**This was made to install after you've runned the `archinstall` command and set up at least a minimal install before**

```sh
sudo pacman -Sy --noconfirm git
```

### ⚠️ Install reflector (Arch only)

Reflector allows Arch to get the fastest mirrors for package downloading.

_Note: If you are not in Brazil, then change "Brazil" to your own country._

```sh
sudo pacman -Sy --needed --noconfirm curl rsync reflector
sudo reflector -c 'Brazil' --sort rate --save /etc/pacman.d/mirrorlist
```

## 🚀 Usage

```sh
mkdir --parents ~/Downloads
git clone https://github.com/LeDragoX/LinuxScript.git ~/Downloads/LinuxScript
cd ~/Downloads/LinuxScript/
chmod --recursive +x *.sh     # Current folder files
chmod --recursive +x **/*.sh  # Check all folders inside the current folder
./LinuxScript.sh
```

## Installed Apps:

<div align="center">

|       App       |   Arch   |                    Ubuntu                    | WSL2 (Ubuntu) |
| :-------------: | :------: | :------------------------------------------: | :-----------: |
|     Discord     |    ✔️    |                      ✔️                      |      ❌       |
| Microsoft Edge  |    ✔️    |                      ✔️                      |      ❌       |
|      GDebi      |    ❌    |                      ✔️                      |      ❌       |
|      Gimp       |    ✔️    |                      ✔️                      |      ❌       |
|  Google Chrome  | Optional |                      ✔️                      |      ❌       |
|     GParted     |    ✔️    |                      ✔️                      |      ❌       |
| Grub Customizer |    ✔️    |                      ✔️                      |      ❌       |
| Microsoft Edge  |    ✔️    |                      ✔️                      |      ❌       |
|   ONLYOffice    |    ✔️    |                      ✔️                      |      ❌       |
|   OBS Studio    |    ✔️    |                      ✔️                      |      ❌       |
|     Parsec      |    ✔️    |                      ✔️                      |      ❌       |
|     Peazip      |    ✔️    |                      ❌                      |      ❌       |
|   qBittorrent   |    ✔️    |                      ✔️                      |      ❌       |
|     Spotify     |    ✔️    |                      ✔️                      |      ❌       |
|    SMPlayer     |    ✔️    |                      ✔️                      |      ❌       |
|      SVP 4      |    ✔️    | [install-svp.sh](src/scripts/install-svp.sh) |      ❌       |
|   Terminator    |    ✔️    |                      ✔️                      |      ❌       |
|       VLC       |    ✔️    |                      ✔️                      |      ❌       |
|     VS Code     |    ✔️    |                      ✔️                      |      ❌       |

</div>

## 📝 License

Licensed under the [MIT](LICENSE) license.
