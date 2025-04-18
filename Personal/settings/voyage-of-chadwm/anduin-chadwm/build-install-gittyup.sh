#!/bin/bash
# set -e
##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
# Website   : https://www.ariser.eu
# Website   : https://www.arcolinux.info
# Website   : https://www.arcolinux.com
# Website   : https://www.arcolinuxd.com
# Website   : https://www.arcolinuxb.com
# Website   : https://www.arcolinuxiso.com
# Website   : https://www.arcolinuxforum.com
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
sudo apt install -y ninja-build
sudo apt install -y qtbase5-dev
sudo apt install -y qtdeclarative5-dev
sudo apt install -y qttools5-dev
sudo apt install -y qt6-tools-dev-tools
sudo apt install -y libqt6core5compat6-dev


# building from source
git clone https://github.com/Murmele/Gittyup.git  /tmp/gittyup
cd /tmp/gittyup
git submodule init
git submodule update --depth 1

# Start from root of gittyup repo.
cd dep/openssl/openssl
./config -fPIC
make

cd /tmp/gittyup

# Start from root of gittyup repo.
mkdir -p build/release
cd build/release
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release ../..
ninja
sudo cp -v gittyup /usr/bin

cd /tmp/gittyup
sudo cp -v rsrc/linux/com.github.Murmele.Gittyup.desktop /usr/share/applications/
sudo cp -v rsrc/linux/com.github.Murmele.Gittyup.appdata.xml.in /usr/share/metainfo/com.github.Murmele.Gittyup.appdata.xml
sudo cp -v rsrc/Gittyup.iconset/gittyup_logo.svg /usr/share/icons/hicolor/scalable/apps/gittyup.svg
for s in 16x16 32x32 64x64 128x128 256x256 512x512; do
    sudo cp -v rsrc/Gittyup.iconset/icon_$s.png /usr/share/icons/hicolor/$s/apps/gittyup.png
done


echo
tput setaf 6
echo "########################################################################"
echo "###### Build and installed"
echo "########################################################################"
tput sgr0
echo
