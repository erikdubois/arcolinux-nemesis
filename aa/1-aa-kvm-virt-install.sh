#!/bin/bash
#set -e
##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
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

# build your own personal AA iso
# https://www.arcolinuxiso.com/aa/
# create your own arcolinux-nemesis scripts
# install qemu with arcolinux-nemesis script

echo
tput setaf 3
echo "################################################################"
echo "################### Start"
echo "################################################################"
tput sgr0
echo

DISK_DIRECTORY="/opt/aa/qemu"
ISO_DIRECTORY="/opt/aa/iso/"
OUT_DIRECTORY="$HOME/AA-Out"

[ -d /opt/aa/qemu ] || sudo mkdir -p /opt/aa/qemu
[ -d /opt/aa/iso ] || sudo mkdir -p /opt/aa/iso

sudo chown -R erik:erik /opt/aa

ISO_LABEL='archlinux-'$(date +%Y.%m.%d)'-x86_64.iso'
sudo cp $OUT_DIRECTORY/$ISO_LABEL $ISO_DIRECTORY

virt-install \
    --connect=qemu:///system \
    --name=archlinux-alis \
    --os-variant=archlinux \
    --vcpu=8 \
    --memory=8096 \
    --boot uefi \
    --disk path="$DISK_DIRECTORY/archlinux-alis.qcow2,format=qcow2,size=40,sparse=yes" \
    --cdrom "$ISO_DIRECTORY/archlinux-2022.03.19-x86_64.iso" \
    --check all=off

echo
tput setaf 3
echo "################################################################"
echo "################### End"
echo "################################################################"
tput sgr0
echo