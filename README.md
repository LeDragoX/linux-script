<h1 align="center">
  <img width=15px src=./src/assets/linux-tux.png>
  Linux Script
</h1>

## 📄 Resume

Script that configure my Linux post-install.

## ❗ Before running

Open the terminal and paste these lines:

### <img width="15px" src="./src/assets/ubuntu-icon.webp" /> [**Ubuntu**](src/scripts/ubuntu-script.sh)-like or [**WSL2**](src/scripts/wsl-ubuntu-script.sh)

```sh
sudo apt install -y git
```

### <img width="15px" src="./src/assets/arch-linux-icon.png" /> [**Arch**](src/scripts/arch-script.sh)-like

**This was made to install after you've runned the `archinstall` command and set up at least a minimal install before**

```sh
sudo pacman -Sy --noconfirm git
```

#### **⚠️ Install reflector (Arch only)**

Reflector allows Arch to get the fastest mirrors for package downloading.

_Note: If you are not in Brazil, then change "Brazil" to your own country._

```sh
sudo pacman -Sy --needed --noconfirm curl rsync reflector
sudo reflector -c 'Brazil' --sort rate --save /etc/pacman.d/mirrorlist
```

### <img width="15px" src="./src/assets/arch-linux-icon.png" /> [**ArchWSL**](src/scripts/wsl-arch-pre-setup.sh) ([Project Link](https://github.com/yuk7/ArchWSL))

#### Notes:

1. Do the same steps as Arch, but after opening the `LinuxScript.sh`,
2. Select `wsl-arch-pre-setup.sh` for setting root/user accounts,
3. Then `wsl-arch-script.sh` for environment config.

## 🚀 Usage

```sh
# You should run as a NORMAL user
mkdir --parents ~/Downloads
git clone https://github.com/LeDragoX/LinuxScript.git ~/Downloads/LinuxScript
cd ~/Downloads/LinuxScript/
chmod --recursive +x *.sh     # Current folder files
chmod --recursive +x **/*.sh  # Check all folders inside the current folder
bash ./LinuxScript.sh
```

<div align="center">

## 📦 Installed Packages

|             Package             |     Arch     | Ubuntu  |  Ubuntu (WSL2)  | Arch (WSL2) |
| :-----------------------------: | :----------: | :-----: | :-------------: | :---------: |
|              snapd              |      ✔️      |   ❌    |       ❌        |     ✔️      |
|             flatpak             |      ✔️      |   ❌    |       ❌        |     ✔️      |
|          adb fastboot           |      ❌      |   ✔️    |       ❌        |     ❌      |
| adobe-source-han-sans-otc-fonts |      ✔️      |   ❌    |       ❌        |     ❌      |
|            amd-ucode            |      ✔️      |   ❌    |       ❌        |     ❌      |
|       apt-transport-https       |      ❌      |   ✔️    |       ❌        |     ❌      |
|              code               |   ✔️(Snap)   |   ✔️    |       ❌        |     ❌      |
|              curl               |      ✔️      |   ❌    |       ❌        |     ✔️      |
|             discord             |  ✔️(canary)  | ✔️(Deb) |       ❌        |     ❌      |
|        gdebi-core gdebi         |      ❌      |   ✔️    |       ✔️        |     ❌      |
|              gimp               |      ✔️      |   ✔️    |       ❌        |     ❌      |
|               git               |      ✔️      |   ❌    |       ❌        |     ✔️      |
|          gnome-keyring          |      ✔️      |   ❌    |       ❌        |     ❌      |
|      google-chrome-stable       | ❌(optional) |   ✔️    |       ❌        |     ❌      |
|             gparted             |      ✔️      |   ✔️    |       ❌        |     ❌      |
|         grub-customizer         |      ✔️      |   ✔️    |       ❌        |     ❌      |
|            grub-efi             |      ❌      |   ✔️    |       ❌        |     ❌      |
|          grub2-common           |      ❌      |   ✔️    |       ❌        |     ❌      |
|         lib32-libpulse          |      ✔️      |   ❌    |       ❌        |     ❌      |
|          libmediainfo           |      ✔️      |   ❌    |       ❌        |     ❌      |
|              lsof               |      ✔️      |   ❌    |       ❌        |     ❌      |
|              htop               |      ✔️      |   ✔️    |       ✔️        |     ❌      |
|       microsoft-edge-beta       |   ✔️(AUR)    |   ✔️    |       ❌        |     ❌      |
|              nano               |      ✔️      |   ✔️    |       ✔️        |     ❌      |
|            neofetch             |      ✔️      |   ✔️    |       ✔️        |     ❌      |
|        noto-fonts-emoji         |      ✔️      |   ❌    |       ❌        |     ❌      |
|             ntfs-3g             |      ✔️      |   ❌    |       ❌        |     ❌      |
|             nvidia              |      ✔️      | ✔️(Old) |       ❔        |     ❔      |
|           obs-studio            |      ✔️      |   ✔️    |       ❌        |     ❌      |
|    onlyoffice-desktopeditors    |   ✔️(Snap)   | ✔️(Deb) |       ❌        |     ❌      |
|            os-prober            |      ✔️      |   ✔️    |       ❌        |     ❌      |
|           parsec-bin            |   ✔️(AUR)    | ✔️(Deb) |       ❌        |     ❌      |
|           pavucontrol           |      ✔️      |   ✔️    |       ❌        |     ❌      |
|         peazip-qt5-bin          |      ✔️      |   ❌    |       ❌        |     ❌      |
|           python-pip            |      ✔️      | ✔️(pip) | ✔️(python3-pip) |     ❌      |
|           qbittorrent           |      ✔️      |   ✔️    |       ❌        |     ❌      |
|            qt5-base             |      ✔️      |   ❌    |       ❌        |     ❌      |
|         qt5-declarative         |      ✔️      |   ❌    |       ❌        |     ❌      |
|             qt5-svg             |      ✔️      |   ❌    |       ❌        |     ❌      |
|             scrcpy              |      ✔️      |   ❌    |       ❌        |     ❌      |
|              slack              |   ✔️(Snap)   |   ❌    |       ❌        |     ❌      |
|         spotify-client          |   ✔️(AUR)    |   ✔️    |       ❌        |     ❌      |
|              steam              |      ✔️      |   ❌    |       ❌        |     ❌      |
|      steam-native-runtime       |      ✔️      |   ❌    |       ❌        |     ❌      |
|               svp               |   ✔️(AUR)    |   ❌    |       ❌        |     ❌      |
|           terminator            |      ✔️      |   ✔️    |       ❌        |     ❌      |
|           ttf-dejavu            |      ❌      |   ✔️    |       ❌        |     ❌      |
|           vapoursynth           |      ✔️      |   ❌    |       ❌        |     ❌      |
|               vim               |      ✔️      |   ✔️    |       ✔️        |     ❌      |
|               vlc               |      ✔️      |   ✔️    |       ❌        |     ❌      |
|              wget               |      ✔️      |   ✔️    |       ✔️        |     ✔️      |
|            unzip zip            |      ✔️      |   ✔️    |       ✔️        |     ✔️      |
|               zsh               |      ✔️      |   ✔️    |       ✔️        |     ✔️      |
|               yay               |      ✔️      |   ❔    |       ❔        |     ✔️      |
|        archlinux-keyring        |      ✔️      |   ❔    |       ❔        |     ✔️      |

> There still more, but i'll do later...

</div>

## 📝 License

Licensed under the [MIT](LICENSE) license.
