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

# https://www.tecmint.com/install-wordpress-in-ubuntu-lamp-stack/
# https://www.howtoforge.com/tutorial/arch-linux-wordpress-install/
# https://computingforgeeks.com/how-setup-wordpress-on-arch-linux/

sudo pacman -S wget --noconfirm --needed

# if [ -f /tmp/latest.tar.gz ];then
#   rm /tmp/latest.tar.gz
# fi

if [ -d /srv/http/ ];then
  sudo rm -r /srv/http/*
fi

wget http://wordpress.org/latest.tar.gz -O /srv/http/latest.tar.gz

cd /srv/http/
tar -xzvf /srv/http/latest.tar.gz

sudo rm /srv/http/latest.tar.gz

sudo cp /srv/http/wp-config-sample.php /srv/http/wp-config.php

echo "Now create a database - type these commands"
echo "Start the shell with this command"
echo "mysql -u root -p"
echo
echo "create database wordpress;"
echo "grant all on wordpress.* to wordpress@localhost identified by 'wordpress';"
echo "flush privileges;"
echo
echo "Now quite the shell"

echo "change the user password and the database in /srv/http/wp-config.php"

echo "Type a letter if you are finished"

read

#sudo touch /srv/http/.htaccess

#sudo chown -v http:http /srv/http/.htaccess


#sudo chown -Rv http:http /srv/http/

#sudo find /srv/http/ -type d -exec chmod -v 775 {} \;

#sudo find /srv/http/ -type f -exec chmod -v 644 {} \;


sudo systemctl restart httpd

firefox http://localhost &
firefox --new-tab http://localhost/phpMyAdmin &