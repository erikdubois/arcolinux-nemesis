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

if 	lsblk -f | grep btrfs > /dev/null 2>&1 ; then
	echo "You are using BTRFS. Installing the software ..."
	sudo pacman -S --needed --noconfirm timeshift
	sudo pacman -S --needed --noconfirm grub-btrfs
	sudo pacman -S --needed --noconfirm timeshift-autosnap
	sudo systemctl enable grub-btrfs.path

	#sudo sed -i "s/PathModified=\/.snaphots/PathModified=\/run\/timeshift\/backup\/timeshift-btrfs\/snapshots/g" /etc/systemd/system/grub-btrfs.path
	sudo sed -i 's/Requires=\\x2esnapshots.mount/Requires=run-timeshift-backup.mount/g' /usr/lib/systemd/system/grub-btrfs.path
	sudo sed -i 's/After=\\x2esnapshots.mount/After=run-timeshift-backup.mount/g' /usr/lib/systemd/system/grub-btrfs.path
	sudo sed -i 's/BindsTo=\\x2esnapshots.mount/BindsTo=run-timeshift-backup.mount/g' /usr/lib/systemd/system/grub-btrfs.path
	sudo sed -i "s/PathModified=\/.snapshots/PathModified=\/run\/timeshift\/backup\/timeshift-btrfs\/snapshots/g" /usr/lib/systemd/system/grub-btrfs.path
	sudo sed -i "s/WantedBy=[\]x2esnapshots.mount/WantedBy=run-timeshift-backup.mount/g" /usr/lib/systemd/system/grub-btrfs.path
	
else
	echo "Your harddisk/ssd/nvme is not formatted as BTRFS."
	echo "Packages will not be installed"
fi

echo "################################################################"
echo "#########   Packages installed - Reboot now     ################"
echo "################################################################"
