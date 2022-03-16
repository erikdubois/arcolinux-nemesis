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
echo "################### Corsair keyboard to be installed"
echo "################################################################"
tput sgr0
echo

installed_dir=$(dirname `pwd`)
sh $installed_dir/AUR/install-ckb-next-git-v*
cp -r $installed_dir/Personal/settings/ckb-next/ ~/.config/
sudo systemctl enable ckb-next-daemon
sudo systemctl start ckb-next-daemon

echo
tput setaf 2
echo "################################################################"
echo "################### Corsair keyboard installed"
echo "################################################################"
tput sgr0
echo