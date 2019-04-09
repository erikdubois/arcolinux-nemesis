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

#This is just an example
#add anything to lhe list or delete applications here to keep them
#you need to make your own script you can run after an ArcoLinux installation

#once you get comfortable with linux & scripting take a look at
#ArcoLinuxD = you run the scripts you want (including or excluding software)
#ArcoLinuxB = you add or delete the packages you want on the iso

sudo pacman -R --noconfirm evolution firefox galculator geany gimp guvcview
sudo pacman -R --noconfirm inkscape meld pragha qbittorrent simplescreenrecorder
sudo pacman -R --noconfirm variety vlc
sudo pacman -R --noconfirm baobab gparted gpick plank
sudo pacman -R --noconfirm timeshift powertop nomacs youtube-dl
sudo pacman -R --noconfirm chromium
sudo pacman -R --noconfirm halo-icons-git moka-icon-theme numix-circle-arc-icons-git numix-icon-theme-git numix-circle-icon-theme-git zafiro-icon-theme
sudo pacman -R --noconfirm font-manager grub-customizer peek screenkey temps wttr
#sudo pacman -R --noconfirm

echo "################################################################"
echo "####                      packages uninstalled            ######"
echo "################################################################"
