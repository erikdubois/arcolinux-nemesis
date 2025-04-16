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

#Erik key
sudo pacman-key --recv-keys 74F5DE85A506BF64
sudo pacman-key --lsign-key 74F5DE85A506BF64

#Marco key
sudo pacman-key --recv-keys F1ABB772CE9F7FC0
sudo pacman-key --lsign-key F1ABB772CE9F7FC0

#John key
sudo pacman-key --recv-keys 4B1B49F7186D8731
sudo pacman-key --lsign-key 4B1B49F7186D8731

#Stephen key
sudo pacman-key --recv-keys 02D507C6EFB8CEAA
sudo pacman-key --lsign-key 02D507C6EFB8CEAA

#Brad Heffernan
sudo pacman-key --recv-keys 18064BF445855549
sudo pacman-key --lsign-key 18064BF445855549

#Raniel Laguna
sudo pacman-key --recv-keys 7EC1A5550718AB89
sudo pacman-key --lsign-key 7EC1A5550718AB89

echo "################################################################"
echo "#########   the signing keys should now be in   ################"
echo "################################################################"

echo "If you get an error -- Remote key not fetched correctly from keyserver"
echo
echo "Add this line to /etc/pacman.d/gnupg/gpg.conf"
echo "keyserver hkp://ipv4.pool.sks-keyservers.net:11371"
echo "alternatives"
echo "keyserver hkps://hkps.pool.sks-keyservers.net:443"
echo "keyserver hkp://pool.sks-keyservers.net:80"
echo "keyserver hkp://keys.gnupg.net:11371"
