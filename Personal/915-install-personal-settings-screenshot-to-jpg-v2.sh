#!/bin/bash
set -e
##################################################################################################################
# Author 	: 	Erik Dubois
# Website : https://www.erikdubois.be
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
echo "#########       Screenshot settings             ################"
echo "################################################################"

#echo "Making sure gnome-screenshot saves in jpg - smaller in kb"

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

cd $installed_dir/settings/gnome-screenshot
sh set-gnome-screenshot-to-save-as-jpg.sh


echo "################################################################"
echo "#########    screenshot settings  installed     ################"
echo "################################################################"
