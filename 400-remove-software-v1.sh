#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
# Website	: https://www.arcolinux.info
# Website	: https://www.arcolinux.com
# Website	: https://www.arcolinuxd.com
# Website	: https://www.arcolinuxb.com
# Website	: https://www.arcolinuxiso.com
# Website	: https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

# Here we remove applications we do not want

sudo systemctl disable tlp.service

sudo pacman -Rs tlp --noconfirm

sudo pacman -Rs broadcom-wl-dkms --noconfirm

sudo pacman -Rs r8168-dkms --noconfirm

sudo pacman -Rs xf86-video-amdgpu --noconfirm
sudo pacman -Rs xf86-video-fbdev --noconfirm
sudo pacman -Rs xf86-video-openchrome --noconfirm
sudo pacman -Rs xf86-video-vmware --noconfirm
sudo pacman -Rs xf86-video-ati --noconfirm
sudo pacman -Rs xf86-video-nouveau --noconfirm
sudo pacman -Rs xf86-video-vesa --noconfirm

echo "################################################################"
echo "################### software removed"
echo "################################################################"