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

# sync lineage os
mkdir -p ~/lineageos
cd ~/carbon
repo init --depth=1 -u https://github.com/LineageOS/android.git -b lineage-17.1
repo sync

# add trees
git clone --depth=1 https://github.com/youssefnone/android_vendor_samsung_m10lte vendor/samsung/m10lte
git clone --depth=1 https://github.com/youssefnone/android_kernel_samsung_m10lte kernel/samsung/m10lte
git clone --depth=1 https://github.com/youssefnone/android_device_samsung_m10lte device/samsung/m10lte
. build/envsetup.sh
breakfast m10lte
export JACK_SERVER_VM_ARGUMENTS="-Dfile.encoding=UTF-8 -XX:+TieredCompilation -Xmx4096m"
croot
brunch m10lte

