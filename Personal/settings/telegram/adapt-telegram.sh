#!/bin/bash
#set -e
##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
# Website   : https://www.ariser.eu
# Website   : https://www.arcolinux.info
# Website   : https://www.arcolinux.com
# Website   : https://www.arcolinuxd.com
# Website   : https://www.arcolinuxb.com
# Website   : https://www.arcolinuxiso.com
# Website   : https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################


echo
tput setaf 3
echo "################################################################"
echo "Changing panel icon telegram"
echo "################################################################"
tput sgr0
echo

sudo cp -v /home/erik/DATA/arcolinux-nemesis/Personal/settings/telegram/telegram.png /usr/share/icons/hicolor/16x16/apps/telegram.png
sudo cp -v /home/erik/DATA/arcolinux-nemesis/Personal/settings/telegram/telegram.png /usr/share/icons/hicolor/128x128/apps/telegram.png
sudo cp -v /home/erik/DATA/arcolinux-nemesis/Personal/settings/telegram/telegram.png /usr/share/icons/hicolor/16x16/apps/telegram.png
sudo cp -v /home/erik/DATA/arcolinux-nemesis/Personal/settings/telegram/telegram.png /usr/share/icons/hicolor/256x256/apps/telegram.png
sudo cp -v /home/erik/DATA/arcolinux-nemesis/Personal/settings/telegram/telegram.png /usr/share/icons/hicolor/32x32/apps/telegram.png
sudo cp -v /home/erik/DATA/arcolinux-nemesis/Personal/settings/telegram/telegram.png /usr/share/icons/hicolor/48x48/apps/telegram.png
sudo cp -v /home/erik/DATA/arcolinux-nemesis/Personal/settings/telegram/telegram.png /usr/share/icons/hicolor/512x512/apps/telegram.png
sudo cp -v /home/erik/DATA/arcolinux-nemesis/Personal/settings/telegram/telegram.png /usr/share/icons/hicolor/64x64/apps/telegram.png
sudo cp -v /usr/share/icons/hicolor/symbolic/apps/telegram-symbolic.svg /usr/share/icons/hicolor/symbolic/apps/telegram-symbolic.svg

echo
tput setaf 6
echo "################################################################"
echo "################### Done"
echo "################################################################"
tput sgr0
echo
