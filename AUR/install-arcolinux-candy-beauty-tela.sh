#!/bin/bash
set -e
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

rm -rf /tmp/ArcoLinux-Candy-Beauty-Tela
git clone https://github.com/erikdubois/ArcoLinux-Candy-Beauty-Tela /tmp/ArcoLinux-Candy-Beauty-Tela
cp -r /tmp/ArcoLinux-Candy-Beauty-Tela/.icons/* ~/.icons
rm -rf /tmp/ArcoLinux-Candy-Beauty-Tela