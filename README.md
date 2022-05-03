<h1 align="center">
  <img width=25px src=./src/assets/linux-tux.png>
  Linux Script
</h1>

## 📄 Resume

Script that configure my Linux post-install.

## ❗ Before running

Open the terminal and paste these lines:

### <img width="15px" src="./src/assets/ubuntu-icon.webp" /> [**Ubuntu**](src/scripts/ubuntu-script.sh)-like or [**WSL2**](src/scripts/wsl-ubuntu-script.sh)

#### First time requirement:

```sh
sudo apt install -y git
```

### <img width="15px" src="./src/assets/arch-linux-icon.png" /> [**Arch**](src/scripts/arch-script.sh)-like

**This was made to install after you've runned the `archinstall` command and set up at least a minimal install before**

#### First time requirement:

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

#### First time requirement:

```sh
# Fix 'git: /usr/lib/libc.so.6: version `GLIBC_2.34' not found (required by git)'
sudo pacman -Sy --noconfirm archlinux-keyring
sudo pacman -Sy --noconfirm glibc
sudo pacman -Sy --noconfirm git
```

#### Notes:

1. Open the `LinuxScript.sh`,
2. Select `Arch Scripts` option,
3. Select `wsl-arch-pre-setup.sh` for setting root/user accounts,
4. Then `wsl-arch-script.sh` for environment config.

## 🚀 Usage

```sh
# Never sudo this script, OKAY? It requests sudo when needed
mkdir --parents ~/Downloads
git clone https://github.com/LeDragoX/LinuxScript.git ~/Downloads/LinuxScript
cd ~/Downloads/LinuxScript/
chmod --recursive +x *.sh        # Current folder files
chmod --recursive +x **/**/*.sh  # Check all folders inside the current folder
bash ./LinuxScript.sh
```

<div align="center">

## 📦 Installed Packages

### _<img width="15px" src="./src/assets/arch-linux-icon.png" /> Arch_

|             Package             |   Arch   | Arch (WSL2) |
| :-----------------------------: | :------: | :---------: |
|              snapd              |    ✔️    |     ✔️      |
|             flatpak             |    ✔️    |     ✔️      |
| adobe-source-han-sans-otc-fonts |    ✔️    |     ❌      |
|            amd-ucode            |    ✔️    |     ❌      |
|        archlinux-keyring        |    ✔️    |     ✔️      |
|              code               | ✔️(Snap) |     ❌      |
|              curl               |    ✔️    |     ✔️      |
|             discord             |    ✔️    |     ❌      |
|              gimp               |    ✔️    |     ❌      |
|               git               |    ✔️    |     ✔️      |
|      google-chrome-stable       | Optional |     ❌      |
|             gparted             |    ✔️    |     ❌      |
|         grub-customizer         |    ✔️    |     ❌      |
|         lib32-libpulse          |    ✔️    |     ❌      |
|          libmediainfo           |    ✔️    |     ❌      |
|              lsof               |    ✔️    |     ❌      |
|              htop               |    ✔️    |     ❌      |
|       microsoft-edge-beta       | ✔️(AUR)  |     ❌      |
|              nano               |    ✔️    |     ❌      |
|            neofetch             |    ✔️    |     ❌      |
|        noto-fonts-emoji         |    ✔️    |     ❌      |
|             nvidia              |    ✔️    |     ❌      |
|           obs-studio            |    ✔️    |     ❌      |
|    onlyoffice-desktopeditors    | ✔️(Snap) |     ❌      |
|            os-prober            |    ✔️    |     ❌      |
|           parsec-bin            | ✔️(AUR)  |     ❌      |
|           pavucontrol           |    ✔️    |     ❌      |
|         peazip-qt5-bin          |    ✔️    |     ❌      |
|           python-pip            |    ✔️    |     ❌      |
|           qbittorrent           |    ✔️    |     ❌      |
|            qt5-base             |    ✔️    |     ❌      |
|         qt5-declarative         |    ✔️    |     ❌      |
|             qt5-svg             |    ✔️    |     ❌      |
|             scrcpy              |    ✔️    |     ❌      |
|              slack              | ✔️(Snap) |     ❌      |
|         spotify-client          | ✔️(AUR)  |     ❌      |
|              steam              |    ✔️    |     ❌      |
|      steam-native-runtime       |    ✔️    |     ❌      |
|               svp               | ✔️(AUR)  |     ❌      |
|           terminator            |    ✔️    |     ❌      |
|           vapoursynth           |    ✔️    |     ❌      |
|               vim               |    ✔️    |     ❌      |
|               vlc               |    ✔️    |     ❌      |
|              wget               |    ✔️    |     ✔️      |
|            unzip zip            |    ✔️    |     ✔️      |
|               yay               |    ✔️    |     ✔️      |
|               zsh               |    ✔️    |     ✔️      |

### _<img width="15px" src="./src/assets/ubuntu-icon.webp" /> Ubuntu_

|          Package          | Ubuntu  |  Ubuntu (WSL2)  |
| :-----------------------: | :-----: | :-------------: |
|       adb fastboot        |   ✔️    |       ❌        |
|    apt-transport-https    |   ✔️    |       ❌        |
|           code            |   ✔️    |       ❌        |
|          discord          | ✔️(Deb) |       ❌        |
|     gdebi-core gdebi      |   ✔️    |       ✔️        |
|           gimp            |   ✔️    |       ❌        |
|   google-chrome-stable    |   ✔️    |       ❌        |
|          gparted          |   ✔️    |       ❌        |
|      grub-customizer      |   ✔️    |       ❌        |
|         grub-efi          |   ✔️    |       ❌        |
|       grub2-common        |   ✔️    |       ❌        |
|           htop            |   ✔️    |       ✔️        |
|    microsoft-edge-beta    |   ✔️    |       ❌        |
|           nano            |   ✔️    |       ✔️        |
|         neofetch          |   ✔️    |       ✔️        |
|          ntfs-3g          |   ✔️    |       ❌        |
|          nvidia           | ✔️(Old) |       ❌        |
|        obs-studio         |   ✔️    |       ❌        |
| onlyoffice-desktopeditors | ✔️(Deb) |       ❌        |
|         os-prober         |   ✔️    |       ❌        |
|        parsec-bin         | ✔️(Deb) |       ❌        |
|        pavucontrol        |   ✔️    |       ❌        |
|        python-pip         | ✔️(pip) | ✔️(python3-pip) |
|        qbittorrent        |   ✔️    |       ❌        |
|      spotify-client       |   ✔️    |       ❌        |
|        terminator         |   ✔️    |       ❌        |
|        ttf-dejavu         |   ✔️    |       ❌        |
|            vim            |   ✔️    |       ✔️        |
|            vlc            |   ✔️    |       ❌        |
|           wget            |   ✔️    |       ✔️        |
|         unzip zip         |   ✔️    |       ✔️        |
|            zsh            |   ✔️    |       ✔️        |

> There still more, but i'll do later...

</div>

## 📝 License

Licensed under the [MIT](LICENSE) license.
