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
echo "################### Installing Niri"
echo "################################################################"
tput sgr0
echo

echo
tput setaf 2
echo "################################################################"
echo "###### Installing packages"
echo "################################################################"
tput sgr0
echo

# getting dependencies to be able to build Niri

sudo apt-get install -y gcc 
sudo apt-get install -y clang
sudo apt-get install -y libudev-dev
sudo apt-get install -y libgbm-dev
sudo apt-get install -y libxkbcommon-dev
sudo apt-get install -y libegl1-mesa-dev
sudo apt-get install -y libwayland-dev
sudo apt-get install -y libinput-dev
sudo apt-get install -y libdbus-1-dev
sudo apt-get install -y libsystemd-dev
sudo apt-get install -y libseat-dev
sudo apt-get install -y libpipewire-0.3-dev
sudo apt-get install -y libpango1.0-dev
sudo apt-get install -y libdisplay-info-dev

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

sudo apt autoremove -y

cd /tmp

rm -rf /tmp/niri

git clone https://github.com/YaLTeR/niri.git

cd /tmp/niri

cargo build --release
#cargo install --path .

#https://github.com/YaLTeR/niri/wiki/Packaging-niri
sudo cp target/release/niri /usr/bin/
sudo cp resources/niri-session /usr/bin/
#resources/niri.desktop 	/usr/share/wayland-sessions/
sudo cp resources/niri-portals.conf /usr/share/xdg-desktop-portal/
sudo cp resources/niri.service /usr/lib/systemd/user/
sudo cp resources/niri-shutdown.target /usr/lib/systemd/user/
#sudo cp resources/dinit/niri (dinit) 	/usr/lib/dinit.d/user/
#sudo cp resources/dinit/niri-shutdown (dinit) 	/usr/lib/dinit.d/user/

echo
tput setaf 6
echo "################################################################"
echo "###### Niri is installed - reboot"
echo "################################################################"
tput sgr0
echo
