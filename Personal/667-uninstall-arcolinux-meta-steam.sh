#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxiso.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

sudo pacman -Rs steam lib32-libvdpau lib32-libva lib32-nvidia-utils lib32-libxtst lib32-libxrandr lib32-libpulse lib32-gdk-pixbuf2 \
lib32-gtk2 lib32-openal lib32-mesa lib32-gcc-libs lib32-libx11 lib32-libxss lib32-alsa-plugins lsof lib32-libgpg-error \
lib32-libindicator-gtk2 lib32-libdbusmenu-glib lib32-libdbusmenu-gtk2 lib32-nss 
echo "################################################################"
echo "####                      packages uninstalled            ######"
echo "################################################################"
