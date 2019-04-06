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

[ -d $HOME"/.local/share/TelegramDesktop/tdata/ticons" ] || mkdir -p $HOME"/.local/share/TelegramDesktop/tdata/ticons"

rm -rf $HOME/.local/share/TelegramDesktop/tdata/ticons/*
sleep 1

installed_dir="/home/erik/DATA/arcolinux-nemesis/Personal"

cp -f $installed_dir/settings/telegram-icons/ticons/* $HOME/.local/share/TelegramDesktop/tdata/ticons/

echo "################################################################"
echo "####                      telegram fixed                  ######"
echo "################################################################"
