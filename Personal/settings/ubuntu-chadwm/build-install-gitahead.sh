#!/bin/bash
# set -e
##################################################################################################################
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
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################

echo
tput setaf 2
echo "################################################################"
echo "################### Building from source"
echo "################################################################"
tput sgr0
echo

sudo apt install -y build-essential
sudo apt install -y cmake
sudo apt install -y ninja-build
sudo apt install -y qt6-5compat-dev libssh2-1-dev libgit2-dev
sudo apt install -y cmark
#sudo rm -r /tmp/gitahead
git clone https://github.com/gitahead/gitahead  /tmp/gitahead
cd /tmp/gitahead

git submodule init
git submodule update

cd dep/openssl/openssl
./config -fPIC
make

cd ..

# Start from root of gitahead repo.
mkdir -p build/release
cd build/release
cmake -G Ninja -DCMAKE_BUILD_TYPE=Release

ninja

echo
tput setaf 6
echo "################################################################"
echo "###### Build and installed"
echo "################################################################"
tput sgr0
echo
