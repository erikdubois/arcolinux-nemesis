#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
# Website	: https://www.arcolinux.info
# Website	: https://www.arcolinux.com
# Website	: https://www.arcolinuxd.com
# Website	: https://www.arcolinuxb.com
# Website	: https://www.arcolinuxiso.com
# Website	: https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

echo
tput setaf 2
echo "################################################################"
echo "################### Autostart certain applications"
echo "################################################################"
tput sgr0
echo

[ -d $HOME"/.config/autostart" ] || mkdir -p $HOME"/.config/autostart"

sleep 1

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))


cp -f $installed_dir/settings/autostart/* $HOME"/.config/autostart"

#uncommenting here to know if the ArcoLinuxBs are completely done
#gsettings set org.blueberry use-symbolic-icons false

echo
tput setaf 2
echo "################################################################"
echo "################### Autostart done"
echo "################################################################"
tput sgr0
echo