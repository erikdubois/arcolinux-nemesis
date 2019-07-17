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

#settings for a bluetooth headset
#after reboot switch off and on your device to get connected automatically and to the right channel

FIND="#AutoEnable=false"
REPLACE="AutoEnable=true"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/bluetooth/main.conf

echo '
load-module module-switch-on-connect' | sudo tee --append /etc/pulse/default.pa

echo 'options ath9k btcoex_enable = 1' | sudo tee /etc/modprobe.d/bluetooth-clear.conf

echo "################################################################"
echo "#########   reboot to let the settings kick in  ################"
echo "################################################################"
