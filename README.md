<h1 align="center">
  <img width=4% src=./src/lib/images/linux-tux.png>
  Linux Script
</h1>

## Resume

Script that configure my Linux post-install.

## Usage

Open the terminal and paste these lines:

### <img width="4%" src="./src/lib/images/ubuntu-icon.webp" /> For [Ubuntu](src/ubuntu-script.sh) or [WSL2](src/wsl2-script.sh) users.

```sh
sudo apt install -y git
```

### <img width="4%" src="./src/lib/images/arch-linux-icon.png" /> For [Arch](src/arch-script.sh) users, made in Arch & Manjaro.

```sh
sudo pacman -Sy --noconfirm git
```

### Usage

```sh
mkdir --parents ~/Downloads
git clone https://github.com/LeDragoX/LinuxScript.git ~/Downloads/LinuxScript
cd ~/Downloads/LinuxScript/
chmod --recursive +x *.sh     # Current folder files
chmod --recursive +x **/*.sh  # All folders inside files
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
|     Parsec      |    ❌    |                      ✔️                      |      ❌       |
|   qBittorrent   |    ✔️    |                      ✔️                      |      ❌       |
|     Spotify     |    ✔️    |                      ✔️                      |      ❌       |
|    SMPlayer     |    ✔️    |                      ✔️                      |      ❌       |
|      SVP 4      |    ✔️    | [install-svp.sh](src/scripts/install-svp.sh) |      ❌       |
|   Terminator    |    ✔️    |                      ✔️                      |      ❌       |
|       VLC       |    ✔️    |                      ✔️                      |      ❌       |
|     VS Code     |    ✔️    |                      ✔️                      |      ❌       |

</div>

## License

Check the License file [here](LICENSE).

JetBrains Mono font is under `SIL Open Font License 1.1` and MesloLGS under `Apache License, Version 2.0`.
