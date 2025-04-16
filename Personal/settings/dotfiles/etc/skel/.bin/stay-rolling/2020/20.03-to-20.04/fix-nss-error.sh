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
echo "fix for nss: /usr/lib/p11-kit-trust.so exists in filesystem"
echo "###############################################################################"
echo
sudo rm /usr/lib/p11-kit-trust.so
sudo pacman -S --noconfirm nss
echo
echo "###############################################################################"
echo "###                            nss fix done"
echo "###############################################################################"
