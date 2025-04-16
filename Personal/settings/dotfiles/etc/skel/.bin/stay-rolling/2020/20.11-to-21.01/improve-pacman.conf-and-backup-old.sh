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

echo
echo "###############################################################################"
echo "IN ORDER FOR THE PACKAGES OF ARCOLINUX TO TAKE PRECEDENCE OVER ARCH LINUX"
echo "PACKAGES WE WILL MOVE OUR ARCOLINUX REPOS TO THE TOP"
echo "###############################################################################"
echo

sudo cp /etc/pacman.conf /etc/pacman.conf.backup
sudo cp -f pacman.conf /etc/pacman.conf

echo
echo "###############################################################################"
echo "###                               DONE                                     ####"
echo "###############################################################################"
echo
