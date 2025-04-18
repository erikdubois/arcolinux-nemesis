#!/bin/bash
#set -e
#######################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxb.com
# Website	:	https://www.arcolinuxiso.com
# Website	:	https://www.arcolinuxforum.com
#######################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
#######################################################################################


#######################################################################################
#
#   DECLARATION OF FUNCTIONS
#
#######################################################################################


func_install() {
	if pacman -Qi $1 &> /dev/null; then
		tput setaf 2
  		echo "#######################################################################################"
  		echo "################## The package "$1" is already installed"
      	echo "#######################################################################################"
      	echo
		tput sgr0
	else
    	tput setaf 3
    	echo "#######################################################################################"
    	echo "##################  Installing package "  $1
    	echo "#######################################################################################"
    	echo
    	tput sgr0
    	sudo pacman -S --noconfirm --needed $1 
    fi
}

#######################################################################################
echo "Installation of samba software"
#######################################################################################

list=(
samba
gvfs-smb
gvfs-dnssd
)

count=0

for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

#######################################################################################

tput setaf 5;echo "########################################################################"
echo "Getting the ArcoLinux Samba config"
echo "########################################################################"
echo;tput sgr0

sudo cp /etc/samba/smb.conf.nemesis /etc/samba/smb.conf

tput setaf 5;echo "########################################################################"
echo "Give your username for samba"
echo "########################################################################"
echo;tput sgr0

read -p "What is your login? It will be used to add this user to smb : " choice
sudo smbpasswd -a $choice

tput setaf 5;echo "########################################################################"
echo "Enabling services"
echo "########################################################################"
echo;tput sgr0

sudo systemctl enable smb.service
sudo systemctl enable nmb.service

tput setaf 11;
echo "########################################################################"
echo "Software has been installed"
echo "########################################################################"
echo;tput sgr0
