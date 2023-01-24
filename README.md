<h1 align="center">
  <img width=25px src=./src/assets/linux-tux.png>
  Linux Script
</h1>

**_Script that configure my Linux post-install._**

## ⚙️ Setup Requirements

Open the terminal and paste these lines:

<h1></h1>

### <img width="15px" src="./src/assets/arch-linux-logo.png" /> Arch-like

<details>

**This was made to install after you've runned the `archinstall` command and set up at least a minimal install before**

```sh
sudo pacman -Sy --needed --noconfirm curl rsync reflector git
```

#### **⚠️ Get Fastest Mirrors (Arch only)**

Reflector allows Arch to get the fastest mirrors for package downloading.

_**Note:** If you are not in Brazil, then change "BR" to your own country/code._

```sh
sudo reflector --country BR,AR,CL,EC,PY,US,CA,MX --sort rate --save /etc/pacman.d/mirrorlist
```

### <img width="15px" src="./src/assets/arch-linux-logo.png" /> ArchWSL ~ [Project Link](https://github.com/yuk7/ArchWSL)

These steps are for ArchWSL only.

```sh
# Fix 'git: /usr/lib/libc.so.6: version `GLIBC_2.34' not found (required by git)'
sudo pacman -Sy --noconfirm archlinux-keyring git glibc
```

#### ❔ Notes for ArchWSL

1. Open the `linux-script.sh`,
2. Select `[MENU] Arch for WSL` option,
3. Then `[WSL] ArchWSL setup Root and User` for setting root/user accounts
   1. Close the Terminal window;
   2. Open powershell and type `Arch.exe config --default-user <<YOUR_USERNAME>>`;
4. Then reopen the terminal and run steps 1-2 to select `[WSL] ArchWSL Post Configurations (Workflow)` for environment config.

</details>

<h1></h1>

### <img width="15px" src="./src/assets/fedora-logo.png" /> Fedora

<details>

Get `git` for Fedora:

```sh
sudo dnf install -y git
```

</details>

<h1></h1>

### <img width="15px" src="./src/assets/ubuntu-logo.webp" /> Ubuntu-like or WSL2

<details>

Get `git` for Ubuntu:

```sh
sudo apt install -y git
```

</details>

<h1></h1>

## 🚀 Usage

> **_Never sudo this script, OKAY? It requests sudo when needed_**

```sh
mkdir --parents ~/Downloads
git clone https://github.com/LeDragoX/LinuxScript.git ~/Downloads/LinuxScript
cd ~/Downloads/LinuxScript/
chmod --recursive +x *.sh       # Current folder files
chmod --recursive +x **/**/*.sh # Check all folders inside the current folder
bash --login ./linux-script.sh
```

<div align="center">

## 📦 Installed Packages

### _<img width=15px src=./src/assets/linux-tux.png> ALL Distros_

|  Package  | All Distros |
| :-------: | :---------: |
|   asdf    |     ✔️      |
| curl wget |     ✔️      |
|    git    |     ✔️      |
|    nvm    |     ✔️      |
|    rvm    |     ✔️      |
| unzip zip |     ✔️      |
|   which   |     ✔️      |
|    zsh    |     ✔️      |

### _<img width="15px" src="./src/assets/arch-linux-logo.png" /> Arch_

| Package                                                                    |    Arch     | Arch (WSL2) |
| :------------------------------------------------------------------------- | :---------: | :---------: |
| archlinux-keyring (Essential)                                              |     ✔️      |     ✔️      |
| adobe-source-han-sans-cn/hk/jp/kr/otc/tw-fonts noto-fonts-emoji ttf-dejavu |     ✔️      |     ❌      |
| amd-ucode intel-ucode                                                      |     ✔️      |     ❌      |
| arc-gtk-theme                                                              |     ✔️      |     ❌      |
| code                                                                       |   ✔️ Snap   |     ❌      |
| discord                                                                    |     ✔️      |     ❌      |
| emote                                                                      |   ✔️ Snap   |     ❌      |
| file-roller                                                                |     ✔️      |     ❌      |
| gimp                                                                       |     ✔️      |     ❌      |
| google-chrome-stable                                                       | ❌ Optional |     ❌      |
| gnome-keyring                                                              |     ✔️      |     ❌      |
| gparted                                                                    |     ✔️      |     ❌      |
| grub-customizer os-prober                                                  |     ✔️      |     ❌      |
| htop                                                                       |     ✔️      |     ❌      |
| lib32-pipewire pipewire pipewire-alsa/jack/pulse wireplumber               |     ✔️      |     ❌      |
| microsoft-edge-stable                                                      |   ✔️ AUR    |     ❌      |
| man-db man-pages                                                           |     ✔️      |     ✔️      |
| nano vim                                                                   |     ✔️      |     ❌      |
| neofetch                                                                   |     ✔️      |     ❌      |
| obs-studio                                                                 |     ✔️      |     ❌      |
| onlyoffice-desktopeditors                                                  |   ✔️ Snap   |     ❌      |
| parsec-bin                                                                 |   ✔️ AUR    |     ❌      |
| pavucontrol                                                                |     ✔️      |     ❌      |
| peazip-qt5                                                                 |   ✔️ AUR    |     ❌      |
| python-pip                                                                 |     ✔️      |     ❌      |
| qbittorrent                                                                |     ✔️      |     ❌      |
| scrcpy                                                                     |     ✔️      |     ❌      |
| slack                                                                      |   ✔️ Snap   |     ❌      |
| spotify-client                                                             |   ✔️ AUR    |     ❌      |
| steam                                                                      |     ✔️      |     ❌      |
| steam-native-runtime                                                       |     ✔️      |     ❌      |
| svp                                                                        |   ✔️ AUR    |     ❌      |
| terminator                                                                 |     ✔️      |     ❌      |
| vlc                                                                        |     ✔️      |     ❌      |
| snapd yay                                                                  |     ✔️      |     ✔️      |

### _<img width="15px" src="./src/assets/arch-linux-logo.png" /> Optional_

<details align="left">

#### NVIDIA Users

|                       Package                       | Arch | Arch (WSL2) |
| :-------------------------------------------------: | :--: | :---------: |
| cuda lib32-nvidia-utils nvidia/-lts nvidia-settings |  ✔️  |     ❌      |

#### SVP Install

|                            Package                             |  Arch  | Arch (WSL2) |
| :------------------------------------------------------------: | :----: | :---------: |
| libmediainfo lsof qt5-base qt5-declarative qt5-svg vapoursynth |   ✔️   |     ❌      |
|                mpv-full rsound spirv-cross svp                 | ✔️ AUR |     ❌      |

</details>

### _<img width="15px" src="./src/assets/ubuntu-logo.webp" /> Ubuntu_

| Package                                                    | Require GPG/PPA |   Ubuntu    | Ubuntu (WSL2) |
| :--------------------------------------------------------- | :-------------: | :---------: | :-----------: |
| adb fastboot scrcpy                                        |       ❌        |     ✔️      |      ❌       |
| apt-transport-https code                                   |     ❌/GPG      |     ✔️      |      ❌       |
| build-essential                                            |       ❌        |     ✔️      |      ✔️       |
| discord                                                    |       ❌        |   ✔️ Deb    |      ❌       |
| file-roller                                                |       ❌        |     ✔️      |      ❌       |
| gdebi gdebi-core                                           |       ❌        |     ✔️      |      ✔️       |
| gimp                                                       |     ✔️ PPA      |     ✔️      |      ❌       |
| google-chrome-stable                                       |     ✔️ GPG      | ❌ Optional |      ❌       |
| gparted                                                    |       ❌        |     ✔️      |      ❌       |
| grub-customizer grub-efi grub2-common os-prober            | ✔️ PPA/❌/❌/❌ |     ✔️      |      ❌       |
| htop                                                       |       ❌        |     ✔️      |      ✔️       |
| pipewire pipewire-pulse/audio-client-libraries wireplumber |       ❌        |     ✔️      |      ✔️       |
| gstreamer1.0-pipewire libspa-0.2-bluetooth libspa-0.2-jack |       ❌        |     ✔️      |      ✔️       |
| microsoft-edge-stable                                      |     ✔️ GPG      |     ✔️      |      ❌       |
| neofetch                                                   |       ❌        |     ✔️      |      ✔️       |
| ntfs-3g                                                    |       ❌        |     ✔️      |      ❌       |
| nvidia-driver-xxx                                          |       ❌        |   ✔️ v525   |      ❌       |
| obs-studio                                                 |     ✔️ PPA      |     ✔️      |      ❌       |
| onlyoffice-desktopeditors                                  |       ❌        |   ✔️ Deb    |      ❌       |
| parsec-bin                                                 |       ❌        |   ✔️ Deb    |      ❌       |
| pavucontrol                                                |       ❌        |     ✔️      |      ❌       |
| pip                                                        |       ❌        |     ✔️      |      ❌       |
| qbittorrent                                                |     ✔️ PPA      |     ✔️      |      ❌       |
| spotify-client                                             |     ✔️ GPG      |     ✔️      |      ❌       |
| terminator                                                 |       ❌        |     ✔️      |      ❌       |
| nano vim                                                   |       ❌        |     ✔️      |      ✔️       |
| vlc                                                        |       ❌        |     ✔️      |      ❌       |

</div>

## 📝 License

Licensed under the [MIT](LICENSE) license.
