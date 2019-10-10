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

[ -d $HOME"/.config/autostart" ] || mkdir -p $HOME"/.config/autostart"

sleep 1

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))


cp -f $installed_dir/settings/autostart/* $HOME"/.config/autostart"

echo "################################################################"
echo "####                      autostart added                 ######"
echo "################################################################"
