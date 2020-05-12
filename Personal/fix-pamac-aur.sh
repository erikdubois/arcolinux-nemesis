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

# https://aur.archlinux.org/packages/pamac-aur/

echo "Fix to show icons and applications in pamac-aur"
echo "Downgrading is another solution - see forum for that one"

zcat /usr/share/app-info/xmls/community.xml.gz | sed 's|<em>||g;s|<\/em>||g;' | gzip > "/tmp/new.xml.gz"
sudo cp /tmp/new.xml.gz /usr/share/app-info/xmls/community.xml.gz
sudo pacman -S appstream --noconfirm --needed
sudo appstreamcli refresh-cache --force

echo "###############################################################################"
echo "###                               DONE                                     ####"
echo "###############################################################################"
