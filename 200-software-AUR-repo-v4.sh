#!/bin/bash
#set -e
##################################################################################################################
# Author 	: 	Erik Dubois
# Website	: 	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

# software from AUR (Arch User Repositories)
# https://aur.archlinux.org/packages/

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

sh $installed_dir/AUR/install-gitfiend-v*.sh
sh $installed_dir/AUR/install-insync-v*.sh
#sh $installed_dir/AUR/install-openbox-themes-pambudi-git-v*.sh
#sh $installed_dir/AUR/install-mpd-ncmpcpp-v*.sh
#sh $installed_dir/AUR/install-radiotray-v*.sh
#sh $installed_dir/AUR/install-virtualbox-for-linux-v*.sh
sh $installed_dir/AUR/install-virtualbox-for-linux-dkms*

# these come last always
echo "Checking if icons from applications have a hardcoded path"
echo "and fixing them"
echo "Wait for it ..."
sudo hardcode-fixer

echo "################################################################"
echo "####        Software from AUR Repository installed        ######"
echo "################################################################"
