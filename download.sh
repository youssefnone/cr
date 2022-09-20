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

# sync rom
cd
mkdir rom
cd rom
repo init --depth=1 -u https://github.com/crdroidandroid/android.git -b 10.0
repo sync

# add trees
git clone --depth=1 https://github.com/youssefnone/android_vendor_samsung_m10lte vendor/samsung/m10lte
git clone --depth=1 https://github.com/youssefnone/android_vendor_samsung_universal7870-common -b common vendor/samsung/universal7870-common

# build
. build/envsetup.sh
make vendor

TIMEOUT=20160
cd ~/rom
ls out/target/product/generic
zip vendor.zip out/target/product/generic/vendor.img
export OUTPUT="vendor.zip"
FILENAME=$(echo $OUTPUT)

# Upload to WeTransfer
# NOTE: the current Docker Image, "registry.gitlab.com/sushrut1101/docker:latest", includes the 'transfer' binary by Default
transfer wet $FILENAME > link.txt || { echo "ERROR: Failed to Upload the Build!" && exit 1; }

# Mirror to oshi.at
curl -T $FILENAME https://oshi.at/${FILENAME}/${OUTPUT} > mirror.txt || { echo "WARNING: Failed to Mirror the Build!"; }

DL_LINK=$(cat link.txt | grep Download | cut -d\  -f3)
MIRROR_LINK=$(cat mirror.txt | grep Download | cut -d\  -f1)

# Show the Download Link
echo "=============================================="
echo "Download Link: ${DL_LINK}" || { echo "ERROR: Failed to Upload the Build!"; }
echo "Mirror: ${MIRROR_LINK}" || { echo "WARNING: Failed to Mirror the Build!"; }
echo "=============================================="

exit 0
