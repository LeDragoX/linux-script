# /etc/sudoers should get
# ledragox ALL=(ALL:ALL) ALL



sudo pacman -S --noconfirm wget curl git # -R para remover e -Rcns para remover com todas as dependencias
sudo pacman -S --noconfirm neofetch

mkdir ~/ConfigInicial & cd ~/ConfigInicial/

git clone https://aur.archlinux.org/google-chrome.git
pushd google-chrome
makepkg -s --noconfirm
sudo pacman -U --noconfirm google-chrome*.pkg.tar*
popd

git clone https://aur.archlinux.org/visual-studio-code-bin.git
pushd visual-studio-code-bin
makepkg -s --noconfirm
sudo pacman -U --noconfirm visual-studio-code-bin*.pkg.tar*
popd
