#!/bin/bash
#set -e
echo
green=$(printf '\033[32m')
reset=$(printf '\033[0m')

cat << EOF
${green}=====================================
    ██╗  ██╗██╗██████╗  ██████╗ 
    ██║ ██╔╝██║██╔══██╗██╔═══██╗
    █████╔╝ ██║██████╔╝██║   ██║
    ██╔═██╗ ██║██╔══██╗██║   ██║
    ██║  ██╗██║██║  ██║╚██████╔╝
    ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝ 
         TESTED ON K I R O
=====================================${reset}
EOF
echo
##################################################################################################################################
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
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################################

#tutorials https://www.youtube.com/playlist?list=PLlloYVGq5pS6WhIdpcrgoj_XszquIyKCQ
#https://wiki.archlinux.org/title/QEMU
#https://computingforgeeks.com/install-kvm-qemu-virt-manager-arch-manjar/

# 108 packages nov 2025
sudo pacman -S --noconfirm --needed qemu-full
# alternative for virt-manager is gnome-boxes (that is less complex - so also less flexible)
sudo pacman -S --noconfirm --needed virt-manager

#starting service

sudo systemctl enable libvirtd.service
sudo systemctl start libvirtd.service

sudo pacman -S --noconfirm --needed dmidecode

echo -e "options kvm-intel nested=1" | sudo tee -a /etc/modprobe.d/kvm-intel.conf

echo "############################################################################################################################"
echo "#####################                        FIRST REBOOT                              #####################"
echo "############################################################################################################################"

exit 1






sudo pacman -Rdd iptables --noconfirm
sudo pacman -S --noconfirm --needed iptables-nft
sudo pacman -S --noconfirm --needed ebtables 



sudo pacman -S --noconfirm --needed virt-viewer
sudo pacman -S --noconfirm --needed dnsmasq
sudo pacman -S --noconfirm --needed vde2
sudo pacman -S --noconfirm --needed bridge-utils
#ovmf
sudo pacman -S --noconfirm --needed edk2-ovmf



user=$(whoami)
sudo gpasswd -a $user libvirt
sudo gpasswd -a $user kvm

sudo virsh net-define /etc/libvirt/qemu/networks/default.xml

sudo virsh net-autostart default

sudo systemctl restart libvirtd.service

