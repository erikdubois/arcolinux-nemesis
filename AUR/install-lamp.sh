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

# url : https://www.linuxshelltips.com/install-lamp-archlinux/

#sudo pacman -S x --noconfirm --needed 

sudo pacman -S apache --noconfirm --needed
sudo pacman -S php --noconfirm --needed 
sudo pacman -S php-apache --noconfirm --needed 
sudo pacman -S mariadb --noconfirm --needed
sudo pacman -S phpmyadmin --noconfirm --needed

sudo systemctl enable --now httpd
sudo systemctl enable --now mysqld

#sudo rm -r /var/lib/mysql

#mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
#mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# you need to run this as su
#sudo mysql_secure_installation

#mysql -u root -p

FIND="#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so"
REPLACE="LoadModule mpm_prefork_module modules/mod_mpm_prefork.so"
sudo sed -i "s|$FIND|$REPLACE|g" /etc/httpd/conf/httpd.conf

if grep -q "Include conf/extra/php_module.conf" /etc/httpd/conf/httpd.conf ; then
	echo "nothing to do"
else
	echo "
LoadModule php_module modules/libphp.so
AddHandler php-script php
Include conf/extra/php_module.conf" | sudo tee -a /etc/httpd/conf/httpd.conf
fi

sudo systemctl restart httpd

sudo touch /srv/http/index.php

echo "<!DOCTYPE html>
<html>

<head>
  <title>Welcome</title>
</head>

<body>

  <h1>Welcome to LinuxShellTips</h1>
   <p>Linux Command Line Tips, Tricks, Hacks, Tutorials, and Ideas in Blog</p>
<?php
phpinfo()
?>
</body>
</html>" | sudo tee /srv/http/index.php


#phpadmin

FIND=";extension=mysqli"
REPLACE="extension=mysqli"
sudo sed -i "s|$FIND|$REPLACE|g" /etc/php/php.ini

FIND=";extension=pdo_mysql"
REPLACE="extension=pdo_mysql"
sudo sed -i "s|$FIND|$REPLACE|g" /etc/php/php.ini

FIND=";extension=iconv"
REPLACE="extension=iconv"
sudo sed -i "s|$FIND|$REPLACE|g" /etc/php/php.ini

sudo touch sudo nano /etc/httpd/conf/extra/phpmyadmin.conf

echo "Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
	DirectoryIndex  index.php
    AllowOverride All
    Options FollowSymlinks
    Require all granted
</Directory>" | sudo tee /etc/httpd/conf/extra/phpmyadmin.conf

if grep -q "Include conf/extra/phpmyadmin.conf" /etc/httpd/conf/httpd.conf ; then
	echo "nothing to do"
else
echo "Include conf/extra/phpmyadmin.conf" | sudo tee -a /etc/httpd/conf/httpd.conf
fi

sudo systemctl restart httpd