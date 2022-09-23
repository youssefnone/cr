#!/bin/bash

# install package.
sudo apt install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc unzip python -y
# run repo.

mkdir ~/bin
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
sudo ln -sf ~/bin/repo /usr/bin/repo

# set configs.
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

# Create dirs
mkdir crdroid ; cd crdroid

# Init repo
repo init --depth=1 -u https://github.com/crdroidandroid/android.git -b 10.0

# Clone my local repo
git clone https://github.com/youssefnone/android_manifest_samsung_m10lte.git -b crdroid .repo/local_manifests

# tmate
curl -L -o tmate.deb http://ftp.us.debian.org/debian/pool/main/t/tmate/tmate_2.4.0-2_amd64.deb
curl -L -o lib1.deb http://ftp.us.debian.org/debian/pool/main/libe/libevent/libevent-2.1-7_2.1.12-stable-5+b1_amd64.deb
curl -L -o lib2.deb http://ftp.us.debian.org/debian/pool/main/libs/libssh/libssh-4_0.10.4-2_amd64.deb
curl -L -o lib3.deb http://ftp.us.debian.org/debian/pool/main/m/msgpack-c/libmsgpackc2_4.0.0-1_amd64.deb
sudo dpkg -i lib1.deb
sudo dpkg -i lib2.deb
sudo dpkg -i lib3.deb
sudo dpkg -i tmate.deb
tmate 

# Sync
repo sync --no-repo-verify -c --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune -j`nproc`

# Build
. build/envsetup.sh && lunch lineage_m10lte-eng && mka clean && mka api-stubs-docs && mka hiddenapi-lists-docs && mka system-api-stubs-docs && mka test-api-stubs-docs && mka bacon -j`nproc`

TIMEOUT=20160
cd ~/rom
ls out/target/product/m10lte
zip lineage.zip out/error.log
export OUTPUT="lineage.zip"
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
