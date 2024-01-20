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

sudo wget http://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz

cd /tmp
sudo tar -xzvf /tmp/latest.tar.gz --strip-components 1 -O /tmp/latest

sudo rm /tmp/latest.tar.gz

# sudo cp /srv/http/wp-config-sample.php /srv/http/wp-config.php
# #sudo cp /srv/http/wordpress/wp-config-sample.php /srv/http/wp-config.php


# #sudo chown -Rv http:http /srv/http/

# #sudo find /srv/http/ -type d -exec chmod -v 775 {} \;

# #sudo find /srv/http/ -type f -exec chmod -v 644 {} \;


sudo xampp start

firefox http://localhost &
firefox --new-tab http://localhost/wp &
firefox --new-tab http://localhost/phpMyAdmin &
