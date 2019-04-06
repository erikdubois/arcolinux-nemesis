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

#echo "This script will silence the audit log messages in dmesg "
#echo "The intention is here to have a readable dmesg again"
#echo "You can use journalctl as well"

sudo sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="audit=0"/g' /etc/default/grub

sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "################################################################"
echo "####        grub audit messages done                      ######"
echo "################################################################"
