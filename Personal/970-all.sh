#!/bin/bash
#set -e
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
tput setaf 3
echo "################################################################"
echo "################### FOR ALL"
echo "################################################################"
tput sgr0
echo

echo
echo "copying cursor file"
if [ -d /usr/share/icons/default/cursors ]; then
	sudo rm /usr/share/icons/default/cursors
fi
sudo cp -f $installed_dir/settings/cursor/* /usr/share/icons/default
echo

echo
echo "Copying sddm files"
sudo pacman -S --noconfirm --needed arcolinux-sddm-simplicity-git
sudo cp -f /usr/share/archlinux-tweak-tool/data/arco/sddm/sddm.conf /etc/sddm.conf

[ -d /etc/sddm.conf.d ] || sudo mkdir /etc/sddm.conf.d
sudo cp -f /usr/share/archlinux-tweak-tool/data/arco/sddm.conf.d/kde_settings.conf /etc/sddm.conf.d/kde_settings.conf
echo

echo
echo "Enable fstrim timer"
sudo systemctl enable fstrim.timer
echo

# echo
# echo "Testing if qemu agent is still active"
# result=$(systemd-detect-virt)
# test=$(systemctl is-enabled qemu-guest-agent.service)
# if [ $test == "enabled" ] &  [ $result == "none" ]; then
# 	sudo systemctl disable qemu-guest-agent.service
# fi

if [ -f /etc/nanorc ]; then
	sudo cp $installed_dir/settings/nano/nanorc /etc/nanorc
fi

echo
echo "Adding ubuntu keyserver"

if ! grep -q "hkp://keyserver.ubuntu.com:80" /etc/pacman.d/gnupg/gpg.conf; then
echo '
keyserver hkp://keyserver.ubuntu.com:80' | sudo tee --append /etc/pacman.d/gnupg/gpg.conf
fi
echo

echo
tput setaf 2
echo "################################################################"
echo "################### Done"
echo "################################################################"
tput sgr0
echo