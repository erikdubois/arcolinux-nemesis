#!/bin/bash
set -e
##################################################################################################################
# Author 	: 	Erik Dubois
# Website   :   https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

echo "Installing extra icons, themes, applications not on dvd"

#bookmarks

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))
cp $installed_dir/settings/plasma/bookmarks/user-places.xbel ~/.local/share/user-places.xbel

echo "################################################################"
echo "####                 EXTRA SOFTWARE INSTALLED             ######"
echo "################################################################"
