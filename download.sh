#!/bin/bash

# install package
sudo apt install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip python -y
# run repo

mkdir ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
sudo ln -sf ~/bin/repo /usr/bin/repo

# set configs
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# sync carbon rom
mkdir -p ~/carbon
cd ~/carbon
repo init --depth=1 -u https://github.com/CarbonROM/android.git -b cr-8.0
repo sync -j80

# add trees
git clone --depth=1 https://github.com/youssefnone/android_vendor_samsung_m10lte vendor/samsung/m10lte
