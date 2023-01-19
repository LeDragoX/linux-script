<h1 align="center">
  <img width=25px src=./src/assets/linux-tux.png>
  Linux Script
</h1>

**_Script that configure my Linux post-install._**

## ❗ Usage Requirements

Open the terminal and paste these lines:

<h1></h1>

<details>
<summary>Ubuntu</summary>

### _<img width="15px" src="./src/assets/ubuntu-icon.webp" /> [Ubuntu](src/scripts/ubuntu-script.sh)-like or [WSL2](src/scripts/wsl-ubuntu-script.sh)_

#### First time requirement

```sh
sudo apt install -y git
```

</details>

<h1></h1>

<details>
<summary>Arch</summary>

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
sudo pacman -Sy --needed --noconfirm curl rsync reflector reflector-simple
sudo reflector -c 'Brazil' --sort rate --save /etc/pacman.d/mirrorlist
# or if you can access from Desktop
sudo reflector-simple
```

</details>

<h1></h1>

<details>
<summary>ArchWSL</summary>

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
2. Select `[MENU] Arch for WSL` option,
3. Then `[WSL] ArchWSL setup Root and User` for setting root/user accounts
   1. Close the Terminal window;
   2. Open powershell and type `Arch.exe config --default-user <<YOUR_USERNAME>>`;
4. Then reopen the terminal and run steps 1-2 to select `[WSL] ArchWSL Post Configurations (Workflow)` for environment config.

</details>

<h1></h1>

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

### _<img width=15px src=./src/assets/linux-tux.png> ALL Distros_

|  Package  | All Distros |
| :-------: | :---------: |
| curl wget |     ✔️      |
|    git    |     ✔️      |
| unzip zip |     ✔️      |
|   which   |     ✔️      |
|    zsh    |     ✔️      |

### _<img width="15px" src="./src/assets/arch-linux-icon.png" /> Arch_

|             Package             |    Arch     | Arch (WSL2) |
| :-----------------------------: | :---------: | :---------: |
|  archlinux-keyring (Essential)  |     ✔️      |     ✔️      |
| adobe-source-han-sans-otc-fonts |     ✔️      |     ❌      |
|            amd-ucode            |     ✔️      |     ❌      |
|              code               |   ✔️ Snap   |     ❌      |
|             discord             |     ✔️      |     ❌      |
|              gimp               |     ✔️      |     ❌      |
|      google-chrome-stable       | ❌ Optional |     ❌      |
|             gparted             |     ✔️      |     ❌      |
|         grub-customizer         |     ✔️      |     ❌      |
|              htop               |     ✔️      |     ❌      |
|           intel-ucode           |     ✔️      |     ❌      |
|         lib32-pipewire          |     ✔️      |     ❌      |
|      microsoft-edge-stable      |   ✔️ AUR    |     ❌      |
|        man-db man-pages         |     ✔️      |     ✔️      |
|              nano               |     ✔️      |     ❌      |
|            neofetch             |     ✔️      |     ❌      |
|        noto-fonts-emoji         |     ✔️      |     ❌      |
|           obs-studio            |     ✔️      |     ❌      |
|    onlyoffice-desktopeditors    |   ✔️ Snap   |     ❌      |
|            os-prober            |     ✔️      |     ❌      |
|           parsec-bin            |   ✔️ AUR    |     ❌      |
|           pavucontrol           |     ✔️      |     ❌      |
|           peazip-qt5            |   ✔️ AUR    |     ❌      |
|            pipewire             |     ✔️      |     ❌      |
|          pipewire-alsa          |     ✔️      |     ❌      |
|          pipewire-jack          |     ✔️      |     ❌      |
|         pipewire-pulse          |     ✔️      |     ❌      |
|           python-pip            |     ✔️      |     ❌      |
|           qbittorrent           |     ✔️      |     ❌      |
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
|           wireplumber           |     ✔️      |     ❌      |
|               yay               |     ✔️      |     ✔️      |

### _<img width="15px" src="./src/assets/arch-linux-icon.png" /> Optional_

#### NVIDIA Users

|       Package       | Arch | Arch (WSL2) |
| :-----------------: | :--: | :---------: |
|        cuda         |  ✔️  |     ❌      |
| lib32-nvidia-utils  |  ✔️  |     ❌      |
| nvidia-lts / nvidia |  ✔️  |     ❌      |
|   nvidia-settings   |  ✔️  |     ❌      |

#### SVP Install

|     Package     |  Arch  | Arch (WSL2) |
| :-------------: | :----: | :---------: |
|  libmediainfo   |   ✔️   |     ❌      |
|      lsof       |   ✔️   |     ❌      |
|    mpv-full     | ✔️ AUR |     ❌      |
|    qt5-base     |   ✔️   |     ❌      |
| qt5-declarative |   ✔️   |     ❌      |
|     qt5-svg     |   ✔️   |     ❌      |
|     rsound      | ✔️ AUR |     ❌      |
|   spirv-cross   | ✔️ AUR |     ❌      |
|       svp       | ✔️ AUR |     ❌      |
|   vapoursynth   |   ✔️   |     ❌      |

### _<img width="15px" src="./src/assets/ubuntu-icon.webp" /> Ubuntu_

|          Package          | Require GPG/PPA | Ubuntu | Ubuntu (WSL2) |
| :-----------------------: | :-------------: | :----: | :-----------: |
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
|   microsoft-edge-stable   |     ✔️ GPG      |   ✔️   |      ❌       |
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
