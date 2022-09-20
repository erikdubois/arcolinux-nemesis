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

#https://github.com/systemd/zram-generator

sudo pacman -S zram-generator --noconfirm --needed

#----------------------------------------------------------------------------------

echo '[zram0]
zram-size = ram / 2' | sudo tee /etc/systemd/zram-generator.conf

#create new devices
sudo systemctl daemon-reload

sudo systemctl start /dev/zram0

echo "check with"
echo "swapon or zramctl or"
echo "with systemdsystemctl status systemd-zram-setup@zram0.service"