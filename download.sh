#!/bin/bash

sudo apt-get install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip python -y

mkdir ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
sudo ln -sf ~/bin/repo /usr/bin/repo

git config --global user.email "you@example.com"
git config --global user.name "Your Name"

mkdir -p ~/carbon
cd ~/carbon
repo init -u https://github.com/CarbonROM/android.git -b cr-8.0
repo sync -j80
