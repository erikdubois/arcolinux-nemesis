#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
echo "#############################"
echo "SPECIALITIES"
echo "#############################"
echo
echo "We have moved to i3-gaps. You decide if you want to switch from i3-gaps-next-git."
echo "November gave us some trouble with codecs - you decide if you want to keep vivaldi-codecs-ffmpeg-extra-bin"
echo "It is working again now"
echo
echo "#############################"
echo "REMOVALS"
echo "#############################"
echo "We have removed these packages from the iso :"
echo
echo "Dependency no longer necessary - package no longer exists"
sudo pacman -R python2-xapp
echo "20/12/2019 - Arch Linux message"
sudo pacman -Rdd libdmx libxxf86dga
echo "20/12/2019 - Xorg cleanup"
sudo pacman -Rdd xf86-input-keyboard xf86-input-mouse
echo
echo "#############################"
echo "INSTALLATIONS"
echo "#############################"
echo "We have installed these packages on the iso :"
echo
echo "correction for the version number - not a downgrade"
sudo pacman -S arcolinux-lightdm-gtk-greeter --noconfirm
echo "lshw is an interesting tool analyzing app"
sudo pacman -S lshw --noconfirm --needed
echo "Installation of cron service for reflector"
sudo pacman -S cronie --noconfirm --needed
sudo pacman -S arcolinux-cron-git --noconfirm
echo "New theme for oblogout"
sudo pacman -S arcolinux-oblogout --noconfirm
echo "hblock"
sudo pacman -S arcolinux-hblock-git --noconfirm --needed
echo

echo "Arch Linux package name changes"
sudo pacman -R pyqt5-common
sudo pacman -R python-sip-pyqt5

#sudo pacman -S python2-pyqt5
#sudo pacman -S python2-sip-pyqt5

echo "##########################################"
echo "CHANGING VERSION IN /ETC/LSB-RELEASE"
echo "##########################################"

sudo sed -i 's/\(^DISTRIB_RELEASE=\).*/\1v19.12.15/' /etc/lsb-release

echo "################################################################"
echo "###                   LSB-RELEASE DONE                       ####"
echo "################################################################"
