#!/bin/bash

# install package.
sudo apt update -y
sudo apt install git-core gnupg flex bison gperf build-essential zip curl zlib1g-dev gcc-multilib g++-multilib libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev lib32z-dev libgl1-mesa-dev libxml2-utils xsltproc libncurses5 unzip python -y
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
repo init --depth=1 -u https://github.com/crdroidandroid/android.git -b cr-9.0

# Clone my local repo
git clone https://github.com/youssefnone/android_manifest_samsung_m10lte.git -b cr-9.0 .repo/local_manifests

# Sync
repo sync --no-repo-verify -c --force-sync --no-clone-bundle --no-tags --optimized-fetch --prune -j`nproc`

# Build
. build/envsetup.sh && lunch carbon_m10lte-eng && mka clean && mka bacon -j`nproc`

TIMEOUT=20160
ls out/target/product/m10lte
zip lineage.zip out/error.log
export OUTPUT="lineage.zip"
FILENAME=$(echo $OUTPUT)

# Mirror to oshi.at
curl -T $FILENAME https://oshi.at/${FILENAME}/${OUTPUT} > mirror.txt || { echo "WARNING: Failed to Mirror the Build!"; }

MIRROR_LINK=$(cat mirror.txt | grep Download | cut -d\  -f1)

# Show the Download Link
echo "=============================================="
echo "Mirror: ${MIRROR_LINK}" || { echo "WARNING: Failed to Mirror the Build!"; }
echo "=============================================="

exit 0
