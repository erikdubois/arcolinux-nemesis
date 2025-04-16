#!/bin/bash
#set -e
###############################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxforum.com
###############################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
###############################################################################

echo "###############################################################################"
echo "We will remove the current pacman-init.service files and"
echo "replace the files with a package so we can maintain it"
echo "Our keys will be imported but also the key from Chaotic"
echo "Chaotic repo can be activated via ArcoLinux Tweak Tool"
echo "The repo contains around 300 kernels to choose from and more"
echo "If you do not install this package, you will have key issues with"
echo "the chaotic repo"
echo "#################################################################"
echo
echo "Removing files to be able to install the package"
echo
sudo rm /etc/systemd/system/multi-user.target.wants/pacman-init.service
sudo rm /etc/systemd/system/pacman-init.service
echo
sudo pacman -S --noconfirm arcolinux-systemd-services-git
echo
echo "###############################################################################"
echo "###                   STAY-ROLLING DONE                     ####"
echo "###############################################################################"
echo
