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

tput setaf 1
echo "###################################################################################################"
echo "WORK IN PROGRESS"
echo "THIS IS NOT WORKING YET"
echo "###################################################################################################"
tput sgr0

sudo pacman -S wget --noconfirm --needed

# if [ -f /srv/http/wordpress/wp-config-sample.php ];then
#   sudo rm -r /srv/http/wordpress/*
# fi

if [ -f /srv/http/wp-config-sample.php ];then
  sudo rm -r /srv/http/*
fi

sudo wget http://wordpress.org/latest.tar.gz -O /srv/http/latest.tar.gz
#sudo wget http://wordpress.org/latest.tar.gz -O /srv/http/wordpress/latest.tar.gz

cd /srv/http/
sudo tar -xzvf /srv/http/latest.tar.gz --strip-components 1

sudo rm /srv/http/latest.tar.gz

sudo cp /srv/http/wp-config-sample.php /srv/http/wp-config.php
#sudo cp /srv/http/wordpress/wp-config-sample.php /srv/http/wp-config.php

echo "Now create a database - type these commands"
echo "Start the shell with this command"
echo "mariadb -u root -p"
echo
echo "create database wordpress;"
echo "grant all on wordpress.* to wordpress@localhost identified by 'wordpress';"
echo "flush privileges;"
echo
echo "Now quit the shell"

echo "change the user password and the database in /srv/http/wp-config.php"

echo "Press ENTER if you are finished"

read

#sudo touch /srv/http/.htaccess

#sudo chown -v http:http /srv/http/.htaccess


#sudo chown -Rv http:http /srv/http/

#sudo find /srv/http/ -type d -exec chmod -v 775 {} \;

#sudo find /srv/http/ -type f -exec chmod -v 644 {} \;


sudo systemctl restart httpd
sudo systemctl restart mariadb

#firefox http://localhost &
#firefox --new-tab http://localhost/phpMyAdmin &
