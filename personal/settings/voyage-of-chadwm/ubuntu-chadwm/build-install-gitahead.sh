#!/bin/bash
# set -e
##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "################### Building from source"
echo "########################################################################"
tput sgr0
echo

# getting dependencies

sudo apt install -y cmake
sudo apt install -y libssl-dev
sudo apt install -y ninja-build
sudo apt install -y qt6-5compat-dev
sudo apt install -y qt6-base-dev
sudo apt install -y qt6-tools-dev
sudo apt install -y qtbase5-dev
sudo apt install -y qtdeclarative5-dev
sudo apt install -y qttools5-dev
sudo apt install -y scite

# building from source
git clone https://github.com/gitahead/gitahead/  /tmp/gitahead
cp -v gitahead.desktop /tmp/gitahead/
cd /tmp/gitahead
git submodule init
git submodule update --depth 1

# Start from root of gitahead repo.
cd dep/openssl/openssl
./config -fPIC
make

cd /tmp/gitahead

# Start from root of gitahead repo.
mkdir -p build/release
cd build/release
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release ../..
ninja
sudo cp -v GitAhead /usr/bin/gitahead
sudo cp -v /tmp/gitahead/gitahead.desktop /usr/share/applications

cd /tmp/gitahead
for s in 16x16 32x32 64x64 128x128 256x256 512x512; do
    sudo cp -v rsrc/GitAhead.iconset/icon_$s.png /usr/share/icons/hicolor/$s/apps/gitahead.png
done

echo
tput setaf 6
echo "########################################################################"
echo "###### Build and installed"
echo "########################################################################"
tput sgr0
echo
