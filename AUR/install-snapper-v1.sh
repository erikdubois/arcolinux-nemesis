#!/bin/bash
#set -e
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


sudo pacman -S --noconfirm --needed btrfs-assistant
sudo pacman -S --noconfirm --needed grub-btrfs
sudo pacman -S --noconfirm --needed snap-pac
sudo pacman -S --noconfirm --needed snapper
sudo pacman -S --noconfirm --needed snapper-gui-git
sudo pacman -S --noconfirm --needed snapper-support

sudo snapper -c root create-config /

echo "first manual snapshot"

snapper -c root create --description "initial snapshot"

sudo chmod a+rx /.snapshots
sudo chown :users /.snapshots