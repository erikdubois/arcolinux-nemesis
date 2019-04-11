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

FIND="use_lvmetad = 1"
REPLACE="use_lvmetad = 0"

echo "#############"
echo "Option 1"
echo "#############"
find /etc/lvm/lvm.conf -type f -exec sudo sed -i "s/$FIND/$REPLACE/g" {} \;
echo "#############"
echo "Option 2"
echo "#############"
sudo systemctl stop lvm2-lvmetad.socket lvm2-lvmetad.service
sudo systemctl disable lvm2-lvmetad.socket lvm2-lvmetad.service
echo "#############"
echo "Option 3"
echo "#############"
sudo systemctl mask lvm2-monitor
sudo systemctl mask lvm2-lvmpolld.socket
sudo systemctl mask lvm2-lvmetad.socket
sudo systemctl mask lvm2-lvmetad.socket
echo "#############"
echo "Option 4"
echo "#############"
FIND="#DefaultTimeoutStopSec=90s"
REPLACE="DefaultTimeoutStopSec=20s"
find /etc/systemd/system.conf -type f -exec sudo sed -i "s/$FIND/$REPLACE/g" {} \;
echo "################################################################"
echo "####                      reboot to 0 seconds             ######"
echo "################################################################"
