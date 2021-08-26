#!/bin/bash

function main() {

  echo "========= Installing ALL Dependencies ========="
  sudo apt-get update -y
  sudo apt install -fy lsof
  sudo apt install -fy ffmpeg
  sudo apt-get install -fy g++
  sudo apt-get install -fy beignet-opencl-icd # OpenCL driver
  sudo apt-get install -fy mediainfo          # Media Info
  sudo apt-get install -fy libqt5concurrent5 libqt5svg5 libqt5qml5
  sudo apt-get install -fy libssl-dev libfribidi-dev libluajit-5.1-dev libx264-dev xorg-dev libegl1-mesa-dev libfreetype-dev libfontconfig-dev
  sudo apt-get install -fy libasound2-dev libpulse-dev
  sudo apt-get install -fy python-is-python3 # Python 3
  sudo apt-get install -fy python-minimal    # Python minimal

  clear
  echo "========= Installing the SVP APP ========="
  wget -c -O svp4-linux.tar.bz2 "https://www.svp-team.com/files/svp4-latest.php?linux"
  tar -xjvf svp4-linux.tar.bz2
  ./svp4-linux-64.run

  clear
  echo "========= Setting up SVP 4 (Complete) ========="
  FILESVP=~/SVP\ 4/SVPManager
  if [ -f "$FILESVP" ]; then
    echo "$FILESVP EXISTS."
    echo "========= PROCEEDING INSTALL ========="

    sudo apt-get install -fy make autoconf automake libtool pkg-config nasm git

    clear
    echo "========= Zimg (For SVP) ========="
    git clone https://github.com/sekrit-twc/zimg.git # Zimg
    cd zimg
    ./autogen.sh
    ./configure
    make
    sudo make install
    cd ..
    sudo apt-get install -fy cython3 # Cython3
    pip3 install Cython

    clear
    echo "========= VapourSynth (For SVP) ========="
    git clone --branch R50 https://github.com/vapoursynth/vapoursynth.git # Vapoursynth
    cd vapoursynth
    ./autogen.sh
    ./configure
    make
    sudo make install
    cd ..
    sudo ldconfig
    sudo ln -sf /usr/local/lib/python3.8/site-packages/vapoursynth.so /usr/lib/python3.8/lib-dynload/vapoursynth.so
    # read -n 1 -s -r -p "Press any key to continue" # Pause the Terminal if needed (The most trouble part)

    clear
    echo "========= VLC Settings ========="
    sudo chmod 777 /usr/lib/vlc/plugins/video_filter
    # OR (e.g. Ubuntu 17.04)
    sudo chmod 777 /usr/lib/x86_64-linux-gnu/vlc/plugins/video_filter

    clear
    echo "========= MPV Dependencies ========="
    git clone https://github.com/freetype/freetype2.git
    cd freetype2
    ./autogen.sh
    make
    sudo make install
    cd ..

    clear
    python3 -m pip install meson
    python3 -m pip install ninja
    git clone https://github.com/fribidi/fribidi.git
    cd fribidi/
    ./autogen.sh
    make
    sudo make install
    cd ..

    clear
    sudo apt install -fy autopoint gperf
    git clone https://gitlab.freedesktop.org/fontconfig/fontconfig.git
    cd fontconfig/
    sudo ./autogen.sh --sysconfdir=/etc --prefix=/usr --mandir=/usr/share/man
    make
    sudo make install
    cd ..

    sudo apt remove -y mpv
    clear
    echo "========= MPV from GIT (For SVP) ========="
    git clone https://github.com/mpv-player/mpv-build.git # MPV Build
    cd mpv-build
    echo --enable-libx264 >>ffmpeg_options
    echo --enable-vapoursynth >>mpv_options
    echo --enable-libmpv-shared >>mpv_options
    ./rebuild -j4
    sudo ./install
    cd ..
  else
    echo "$FILESVP DOES NOT EXIST."
  fi

}

main