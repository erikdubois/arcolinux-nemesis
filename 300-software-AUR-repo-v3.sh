30#!/bin/bash
set -e
##################################################################################################################
# Author 	: Erik Dubois
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

# software from AUR (Arch User Repositories)
# https://aur.archlinux.org/packages/

sh AUR/install-discord-v*.sh
sh AUR/install-dropbox-v*.sh
sh AUR/install-hardcode-fixer-git-v*.sh
sh AUR/install-insync-v*.sh
sh AUR/install-mpd-ncmpcpp-v1.sh
sh AUR/install-radiotray-v*.sh
sh AUR/install-sardi-extra-icons-v*.sh
sh AUR/install-spotify-v*.sh
sh AUR/install-virtualbox-for-linux-kernel-v*.sh

# these come last always
echo "Checking if icons from applications have a hardcoded path"
echo "and fixing them"
echo "Wait for it ..."
sudo hardcode-fixer

echo "################################################################"
echo "####        Software from AUR Repository installed        ######"
echo "################################################################"
