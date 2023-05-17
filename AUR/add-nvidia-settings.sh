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

# https://wiki.hyprland.org/Nvidia/
# https://community.kde.org/Plasma/Wayland/Nvidia

echo
tput setaf 2
echo "################################################################"
echo "################### Making sure nvidia-dkms is installed or else exit"
echo "################################################################"
tput sgr0
echo

# Just checking if nvidia-dkms is installed else stop
if pacman -Qi nvidia-dkms &> /dev/null; then

	tput setaf 2
	echo "################################################################"
	echo "#########  Checking ..."$package" is installed... we can continue"
	echo "################################################################"
	tput sgr0

else

	tput setaf 1
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	echo "!!!!!!!!!  Nvidia-dkms has NOT been installed"
	echo "!!!!!!!!!  Know what you are doing"
	echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
	tput sgr0

fi

echo
tput setaf 2
echo "################################################################"
echo "################### Adding nvidia modules for Wayland and Nvidia"
echo "################### MODULES= nvidia nvidia_modeset nvidia_uvm nvidia_drm"
echo "################### in /etc/mkinitcpio.conf"
echo "################### and rebuilding /boot files"
echo "################################################################"
tput sgr0
echo

FIND='MODULES=""'
REPLACE='MODULES="nvidia nvidia_modeset nvidia_uvm nvidia_drm"'
sudo sed -i "s/$FIND/$REPLACE/g" /etc/mkinitcpio.conf

echo
tput setaf 2
echo "################################################################"
echo "################### Adding option nvidia-drm.modeset=1"
echo "################### to the kernel"
echo "################################################################"
tput sgr0
echo

echo "options nvidia-drm modeset=1" | sudo tee  /etc/modprobe.d/nvidia-wayland-nemesis.conf

echo
tput setaf 2
echo "################################################################"
echo "################### Mkinitcpio and update-grub"
echo "################################################################"
tput sgr0
echo

sudo mkinitcpio -P

sudo grub-mkconfig -o /boot/grub/grub.cfg

echo
tput setaf 6
echo "################################################################"
echo "################### Done"
echo "################################################################"
tput sgr0
echo