#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
echo "################################################################"
echo "Disabling services"
echo "################################################################"

sudo systemctl disable smb.service
sudo systemctl disable nmb.service
sudo systemctl disable avahi-daemon.service
sudo systemctl disable winbind.service

echo "################################################################"
echo "Uninstalling packages"
echo "################################################################"

sudo pacman -Rs samba smbclient libwbclient cifs-utils gvfs-smb
sudo pacman -Rs nss-mdns

echo "################################################################"
echo "Renaming ArcoLinux smb.conf file"
echo "################################################################"

if [ -f /etc/samba/smb.conf ]; then
  sudo mv /etc/samba/smb.conf /etc/samba/smb.conf.arcolinux
fi

echo "################################################################"
echo "###  Samba and all related packages and services are gone   ####"
echo "################################################################"
