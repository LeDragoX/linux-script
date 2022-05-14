<h1 align="center">
  <img width=25px src=./src/assets/linux-tux.png>
  Linux Script
</h1>

## 📄 Resume

Script that configure my Linux post-install.

## ❗ Before running

Open the terminal and paste these lines:

### _<img width="15px" src="./src/assets/ubuntu-icon.webp" /> [Ubuntu](src/scripts/ubuntu-script.sh)-like or [WSL2](src/scripts/wsl-ubuntu-script.sh)_

#### First time requirement

```sh
sudo apt install -y git
```

### _<img width="15px" src="./src/assets/arch-linux-icon.png" /> [Arch](src/scripts/arch-script-menu.sh)-like_

**This was made to install after you've runned the `archinstall` command and set up at least a minimal install before**

#### First time requirement

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

### <img width="15px" src="./src/assets/arch-linux-icon.png" /> [_ArchWSL_](src/scripts/arch-script-menu.sh) ([_Project Link_](https://github.com/yuk7/ArchWSL))

#### First time requirement

```sh
# Fix 'git: /usr/lib/libc.so.6: version `GLIBC_2.34' not found (required by git)'
sudo pacman -Sy --noconfirm archlinux-keyring
sudo pacman -Sy --noconfirm glibc
sudo pacman -Sy --noconfirm git
```

#### Notes

1. Open the `LinuxScript.sh`,
2. Select `Arch Scripts` option,
3. Select `arch-script-menu.sh`,
4. Then `[WSL] ArchWSL Pre Setup` for setting root/user accounts
   1. Close the Terminal window;
   2. Open powershell and type `Arch.exe config --default-user <<YOUR_USERNAME>>`;
5. Then reopen the terminal and run steps 1-3 to select `[WSL] Finish ArchWSL installation` for environment config.

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

|             Package             |    Arch     | Arch (WSL2) |
| :-----------------------------: | :---------: | :---------: |
|  archlinux-keyring (Essential)  |     ✔️      |     ✔️      |
|      curl wget (Essential)      |     ✔️      |     ✔️      |
|         git (Essential)         |     ✔️      |     ✔️      |
|      unzip zip (Essential)      |     ✔️      |     ✔️      |
|      which zsh (Essential)      |     ✔️      |     ✔️      |
| adobe-source-han-sans-otc-fonts |     ✔️      |     ❌      |
|            amd-ucode            |     ✔️      |     ❌      |
|              code               |   ✔️ Snap   |     ❌      |
|             discord             |     ✔️      |     ❌      |
|              gimp               |     ✔️      |     ❌      |
|      google-chrome-stable       | ❌ Optional |     ❌      |
|             gparted             |     ✔️      |     ❌      |
|         grub-customizer         |     ✔️      |     ❌      |
|              htop               |     ✔️      |     ❌      |
|       microsoft-edge-beta       |   ✔️ AUR    |     ❌      |
|        man-db man-pages         |     ✔️      |     ✔️      |
|              nano               |     ✔️      |     ❌      |
|            neofetch             |     ✔️      |     ❌      |
|        noto-fonts-emoji         |     ✔️      |     ❌      |
|             nvidia              |     ✔️      |     ❌      |
|           obs-studio            |     ✔️      |     ❌      |
|    onlyoffice-desktopeditors    |   ✔️ Snap   |     ❌      |
|            os-prober            |     ✔️      |     ❌      |
|           parsec-bin            |   ✔️ AUR    |     ❌      |
|           pavucontrol           |     ✔️      |     ❌      |
|         peazip-qt5-bin          |     ✔️      |     ❌      |
|           python-pip            |     ✔️      |     ❌      |
|           qbittorrent           |     ✔️      |     ❌      |
|            qt5-base             |     ✔️      |     ❌      |
|         qt5-declarative         |     ✔️      |     ❌      |
|             qt5-svg             |     ✔️      |     ❌      |
|             scrcpy              |     ✔️      |     ❌      |
|              slack              |   ✔️ Snap   |     ❌      |
|            smplayer             |     ✔️      |     ❌      |
|         spotify-client          |   ✔️ AUR    |     ❌      |
|              steam              |     ✔️      |     ❌      |
|      steam-native-runtime       |     ✔️      |     ❌      |
|               svp               |   ✔️ AUR    |     ❌      |
|           terminator            |     ✔️      |     ❌      |
|               vim               |     ✔️      |     ❌      |
|               vlc               |     ✔️      |     ❌      |
|              snapd              |     ✔️      |     ✔️      |
|             flatpak             |     ✔️      |     ✔️      |
|               yay               |     ✔️      |     ✔️      |

### _<img width="15px" src="./src/assets/ubuntu-icon.webp" /> Ubuntu_

|          Package          | Require GPG/PPA | Ubuntu | Ubuntu (WSL2) |
| :-----------------------: | :-------------: | :----: | :-----------: |
|   curl wget (Essential)   |       ❌        |   ✔️   |      ✔️       |
|      git (Essential)      |       ❌        |   ✔️   |      ✔️       |
|   unzip zip (Essential)   |       ❌        |   ✔️   |      ✔️       |
|      zsh (Essential)      |       ❌        |   ✔️   |      ✔️       |
|       adb fastboot        |       ❌        |   ✔️   |      ❌       |
|    apt-transport-https    |       ❌        |   ✔️   |      ❌       |
|           code            |     ✔️ GPG      |   ✔️   |      ❌       |
|          discord          |       ❌        | ✔️ Deb |      ❌       |
|     gdebi gdebi-core      |       ❌        |   ✔️   |      ✔️       |
|           gimp            |     ✔️ PPA      |   ✔️   |      ❌       |
|   google-chrome-stable    |     ✔️ GPG      |   ✔️   |      ❌       |
|          gparted          |       ❌        |   ✔️   |      ❌       |
|      grub-customizer      |     ✔️ PPA      |   ✔️   |      ❌       |
|         grub-efi          |       ❌        |   ✔️   |      ❌       |
|       grub2-common        |       ❌        |   ✔️   |      ❌       |
|           htop            |       ❌        |   ✔️   |      ✔️       |
|    microsoft-edge-beta    |     ✔️ GPG      |   ✔️   |      ❌       |
|           nano            |       ❌        |   ✔️   |      ✔️       |
|         neofetch          |       ❌        |   ✔️   |      ✔️       |
|          ntfs-3g          |       ❌        |   ✔️   |      ❌       |
|          nvidia           |       ❌        | ✔️ Old |      ❌       |
|        obs-studio         |     ✔️ PPA      |   ✔️   |      ❌       |
| onlyoffice-desktopeditors |       ❌        | ✔️ Deb |      ❌       |
|         os-prober         |       ❌        |   ✔️   |      ❌       |
|        parsec-bin         |       ❌        | ✔️ Deb |      ❌       |
|        pavucontrol        |       ❌        |   ✔️   |      ❌       |
|            pip            |       ❌        |   ✔️   |      ❌       |
|        qbittorrent        |     ✔️ PPA      |   ✔️   |      ❌       |
|         smplayer          |     ✔️ PPA      |   ✔️   |      ❌       |
|      spotify-client       |     ✔️ GPG      |   ✔️   |      ❌       |
|        terminator         |       ❌        |   ✔️   |      ❌       |
|        ttf-dejavu         |       ❌        |   ✔️   |      ❌       |
|            vim            |       ❌        |   ✔️   |      ✔️       |
|            vlc            |       ❌        |   ✔️   |      ❌       |

</div>

## 📝 License

Licensed under the [MIT](LICENSE) license.
