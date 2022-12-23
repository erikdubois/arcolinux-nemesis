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

# url : https://www.linuxshelltips.com/install-lamp-archlinux/
#https://wiki.archlinux.org/title/Wordpress

tput setaf 1
echo "###################################################################################################"
echo "WORK IN PROGRESS"
echo "THIS IS NOT WORKING YET"
echo "###################################################################################################"
tput sgr0

sudo pacman -Rs php apache php-apache phpmyadmin mariadb --noconfirm

sudo systemctl disable httpd
sudo systemctl disable mariadb

if [ -f /srv/http/wordpress/wp-config-sample.php ];then
  sudo rm -r /srv/http/wordpress/*
fi

if [ -f /srv/http/index.html ];then
  sudo rm -r /srv/http/index.html
fi

if [ -f /srv/http/wordpress/index.php ];then
  sudo rm -r /srv/http/wordpress/index.php
fi

if [ -d /srv/http/wordpress ];then
  sudo rm -r /srv/http/wordpress
fi

if [ -f /etc/httpd/conf/httpd.conf ];then
  sudo rm /etc/httpd/conf/httpd.conf
fi

if [ -f /etc/php/php.ini ];then
  sudo rm /etc/php/php.ini
fi

if [ -d /var/lib/mysql ]; then 
  sudo rm -rf /var/lib/mysql/
fi

if [ -f /etc/httpd/conf/extra/phpmyadmin.conf ];then
  sudo rm /etc/httpd/conf/extra/phpmyadmin.conf
fi

if [ -f /etc/httpd/conf/extra/httpd-wordpress.conf ];then
  sudo rm /etc/httpd/conf/extra/httpd-wordpress.conf
fi

########################################################

#sudo pacman -S x --noconfirm --needed 

sudo pacman -S apache --noconfirm --needed
sudo pacman -S php --noconfirm --needed 
sudo pacman -S php-apache --noconfirm --needed 
sudo pacman -S mariadb --noconfirm --needed
sudo pacman -S phpmyadmin --noconfirm --needed

sudo systemctl enable --now httpd
sudo systemctl enable --now mariadb

echo "removing /var/lib/mysql"
if [ -d /var/lib/mysql ]; then 
  sudo rm -rf /var/lib/mysql
  sudo mkdir /var/lib/mysql
fi

sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# you need to run this as su
echo "enter, n, y, password, password, y, y, y, y"

sudo systemctl restart mariadb

sudo mariadb-secure-installation

echo "mpm event out"
FIND="LoadModule mpm_event_module modules/mod_mpm_event.so"
REPLACE="#LoadModule mpm_event_module modules/mod_mpm_event.so"
sudo sed -i "s|$FIND|$REPLACE|g" /etc/httpd/conf/httpd.conf

echo "mpm prefork in"
FIND="#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so"
REPLACE="LoadModule mpm_prefork_module modules/mod_mpm_prefork.so"
sudo sed -i "s|$FIND|$REPLACE|g" /etc/httpd/conf/httpd.conf

echo "support php"
if grep -q "Include conf/extra/php_module.conf" /etc/httpd/conf/httpd.conf ; then
	echo "nothing to do"
else
	echo "LoadModule php_module modules/libphp.so
AddHandler php-script php
Include conf/extra/php_module.conf" | sudo tee -a /etc/httpd/conf/httpd.conf
fi

echo "mod rewrite"
FIND="#LoadModule rewrite_module modules/mod_rewrite.so"
REPLACE="LoadModule rewrite_module modules/mod_rewrite.so"
sudo sed -i "s|$FIND|$REPLACE|g" /etc/httpd/conf/httpd.conf

echo "mod index php etc ..."
FIND="DirectoryIndex index.html"
REPLACE="DirectoryIndex index.php index.html"
sudo sed -i "s|$FIND|$REPLACE|g" /etc/httpd/conf/httpd.conf

# breaks access
# echo "vhosts"
# FIND="#Include conf/extra/httpd-vhosts.conf"
# REPLACE="Include conf/extra/httpd-vhosts.conf"
# sudo sed -i "s|$FIND|$REPLACE|g" /etc/httpd/conf/httpd.conf

echo "phpmyadmin - php.ini - line 927"
FIND=";extension=mysqli"
REPLACE="extension=mysqli"
sudo sed -i "s|$FIND|$REPLACE|g" /etc/php/php.ini

echo "phpmyadmin - php.ini - line 931"
FIND=";extension=pdo_mysql"
REPLACE="extension=pdo_mysql"
sudo sed -i "s|$FIND|$REPLACE|g" /etc/php/php.ini

echo "phpmyadmin - php.ini - line 923"
FIND=";extension=iconv"
REPLACE="extension=iconv"
sudo sed -i "s|$FIND|$REPLACE|g" /etc/php/php.ini

sudo touch sudo nano /etc/httpd/conf/extra/phpmyadmin.conf

echo 'Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
	DirectoryIndex  index.php
    AllowOverride All
    Options FollowSymlinks
    Require all granted
</Directory>' | sudo tee /etc/httpd/conf/extra/phpmyadmin.conf

if grep -q "Include conf/extra/phpmyadmin.conf" /etc/httpd/conf/httpd.conf ; then
  echo "nothing to do"
else
echo "Include conf/extra/phpmyadmin.conf" | sudo tee -a /etc/httpd/conf/httpd.conf
fi

sudo touch sudo nano /etc/httpd/conf/extra/httpd-wordpress.conf

echo "add httpd-wordpress.conf"
echo 'Alias /wordpress "/usr/share/webapps/wordpress"
<Directory "/usr/share/webapps/wordpress">
  AllowOverride All
  Options FollowSymlinks
  Require all granted
</Directory>' | sudo tee /etc/httpd/conf/extra/httpd-wordpress.conf

echo "Include httpd-wordpress in httpd.conf"
if grep -q "Include conf/extra/httpd-wordpress.conf" /etc/httpd/conf/httpd.conf ; then
  echo "nothing to do"
else
  echo "Include conf/extra/httpd-wordpress.conf" | sudo tee -a /etc/httpd/conf/httpd.conf
fi

if [ -d /srv/http/wordpress ]; then
  echo "nothing to do"
else
  sudo mkdir /srv/http/wordpress   
fi

# HTML TEST

sudo touch /srv/http/index.html

echo "<!DOCTYPE html>
<html>

<head>
  <title>Welcome</title>
</head>

<body>

  <h1>Welcome to ArcoLinux</h1>
<?php
phpinfo()
?>
</body>
</html>" | sudo tee /srv/http//index.html


#PHP TEST

sudo touch /srv/http/wordpress/index.php

echo "<!DOCTYPE html>
<html>

<head>
  <title>Welcome</title>
</head>

<body>

  <h1>Welcome to ArcoLinux</h1>
<?php
phpinfo()
?>
</body>
</html>" | sudo tee /srv/http/wordpress/index.php

sudo systemctl restart httpd
sudo systemctl restart mariadb

# firefox http://localhost/
# firefox http://localhost/wordpress &
# firefox --new-tab http://localhost/phpMyAdmin &
