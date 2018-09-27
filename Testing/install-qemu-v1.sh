#!/bin/bash
set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################
#tutorial https://www.youtube.com/watch?v=JxSGT_3UU8w

sudo pacman -S --noconfirm --needed qemu bridge-utils virt-manager virt-viewer

sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service


echo -e “options kvm-intel nested=1″ | sudo tee -a /etc/modprobe.d/kvm-intel.conf


echo "############################################################################################################"
echo "#####################      File kvm-intel.conf has been created                        #####################"
echo "############################################################################################################"
