#!/bin/bash
#set -e
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


echo "Copy ckb-nxt "

installed_dir="/home/erik/DATA/arcolinux-nemesis/Personal"
#copy over folder with contents
cp -r $installed_dir/settings/ckb-next/ ~/.config/

echo "################################################################"
echo "#########   ckb-next config has been copied     ################"
echo "################################################################"
