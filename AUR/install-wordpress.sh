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

if [ -f /tmp/latest.tar.gz ];then
  rm /tmp/latest.tar.gz
fi

if [ -d /tmp/wordpress ];then
  rm -r /tmp/wordpress
fi

wget http://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz

cd /tmp
tar -xzvf /tmp/latest.tar.gz

sudo mv /tmp/wordpress/* /srv/http/

sudo cp /srv/http/wp-config-sample.php /srv/http/wp-config.php

echo "change the user password and the database"

exit 1

#sudo touch /srv/http/.htaccess

sudo chown -v http:http /srv/http/.htaccess


sudo chown -Rv http:http /srv/http/

sudo find /srv/http/ -type d -exec chmod -v 775 {} \;

sudo find /srv/http/ -type f -exec chmod -v 644 {} \;


sudo systemctl restart httpd

firefox http://localhost &
firefox --new-tab http://localhost/phpMyAdmin &