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

echo "Fix for icons not showing up in pamac-aur"

sudo pacman -S appstream --noconfirm --needed
zcat /usr/share/app-info/xmls/community.xml.gz | sed 's|<em>||g;s|<\/em>||g;' | gzip > "new.xml.gz"
sudo mv new.xml.gz /usr/share/app-info/xmls/community.xml.gz
sudo appstreamcli refresh-cache --force

echo "###############################################################################"
echo "###                               DONE                                     ####"
echo "###############################################################################"
