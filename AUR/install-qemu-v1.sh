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
#tutorial https://www.youtube.com/watch?v=JxSGT_3UU8w

sudo pacman -Rdd iptables --noconfirm

sudo pacman -S --noconfirm --needed qemu bridge-utils virt-manager virt-viewer vde2 libvirt ebtables iptables dnsmasq dmidecode ovmf

sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service


echo -e "options kvm-intel nested=1" | sudo tee -a /etc/modprobe.d/kvm-intel.conf

##Change your username here
read -p "What is your login?
It will be used to add this user to the 2 different groups : " choice
sudo gpasswd -a $choice libvirt
sudo gpasswd -a $choice kvm


echo '
nvram = [
    "/usr/share/ovmf/x64/OVMF_CODE.fd:/usr/share/ovmf/x64/OVMF_VARS.fd"
]' | sudo tee --append /etc/libvirt/qemu.conf

sudo virsh net-define /etc/libvirt/qemu/networks/default.xml

sudo virsh net-autostart default

echo "############################################################################################################"
echo "#####################                        FIRST REBOOT                              #####################"
echo "############################################################################################################"
