#!/bin/bash
#set -e
##################################################################################################################
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

# https://www.tecmint.com/install-wordpress-in-ubuntu-lamp-stack/
# https://www.howtoforge.com/tutorial/arch-linux-wordpress-install/
# https://computingforgeeks.com/how-setup-wordpress-on-arch-linux/
# https://wiki.archlinux.org/title/Wordpress

tput setaf 2
echo "###################################################################################################"
echo "INSTALLING XAMPP"
echo "###################################################################################################"
tput sgr0

yay -S xampp --noconfirm --needed

tput setaf 2
echo "###################################################################################################"
echo "Cleanup action"
echo "###################################################################################################"
tput sgr0

if [ -f /tmp/latest.tar.gz ]; then
	sudo rm /tmp/latest.tar.gz
fi

if [ -d /tmp/wordpress ]; then
	sudo rm -r /tmp/wordpress
fi

tput setaf 2
echo "###################################################################################################"
echo "Download last wordpress release"
echo "###################################################################################################"
tput sgr0

sudo wget http://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz

tput setaf 2
echo "###################################################################################################"
echo "Extract and copy to /opt/lampp/htdocs/"
echo "###################################################################################################"
tput sgr0

sudo tar -xzvf /tmp/latest.tar.gz --strip-components 1
sudo cp -r /tmp/wordpress /opt/lampp/htdocs/

tput setaf 2
echo "###################################################################################################"
echo "Cleanup action"
echo "###################################################################################################"
tput sgr0

if [ -f /tmp/latest.tar.gz ]; then
	sudo rm /tmp/latest.tar.gz
fi

if [ -d /tmp/wordpress ]; then
	sudo rm -r /tmp/wordpress
fi

sudo xampp start

sleep 5

firefox http://localhost &
firefox --new-tab http://localhost/wordpress &
firefox --new-tab http://localhost/phpMyAdmin &


tput setaf 2
echo "###################################################################################################"
echo "Done"
echo "Steps to take now"
echo "1. "
echo "1. "
echo "1. "
echo "1. "
echo "1. "
echo "1. "
echo "1. "
echo "1. "
echo "1. "
echo "1. "
echo "###################################################################################################"
tput sgr0