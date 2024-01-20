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

sudo mkdir /tmp/wordpress
sudo tar -xzvf /tmp/latest.tar.gz --strip-components 1 -C /tmp/wordpress
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

tput setaf 2
echo "###################################################################################################"
echo "Changing permissions to the user"
echo "###################################################################################################"
tput sgr0

sudo chown $USER:$USER -R /opt/lampp/htdocs/wordpress

tput setaf 2
echo "###################################################################################################"
echo "Done"
echo "Steps to take now"
echo "Your wordpress website is here - /opt/lampp/htdocs/wordpress"
echo "Open your browser and surf to http://localhost"
echo "1. Create a new database in phpmyadmin - see menu"
echo "2. with collation - name = wp"
echo "3. Surf to http://localhost/wordpress - Let's go button"
echo "4. Fill in Database Name = wp"
echo "5. Fill in Username = root"
echo "6. Keep Password empty"
echo "7. Press Submit"
echo "8. Copy paste code into a new file wp-config.php - save it - 644 permissions !!!"
echo "9. Click button - Run the installation"
echo "9. Welcome screen"
echo "10. Fill in all the blancs"
echo "11. Press install Wordpress - wp-admin - to login"
echo "12. FTP credentials are localhost - your username and your userpassword and FTP"
echo "###################################################################################################"
tput sgr0


tput setaf 2
echo "###################################################################################################"
echo "Starting Xampp"
echo "sudo xampp start"
echo "###################################################################################################"
tput sgr0

sudo xampp start

sleep 5

firefox --new-tab http://localhost/wordpress &
firefox --new-tab http://localhost/phpmyadmin/ &

