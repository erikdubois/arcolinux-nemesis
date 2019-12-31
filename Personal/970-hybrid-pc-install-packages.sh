#!/bin/bash
#set -e
##################################################################################################################
# Author 	: 	Erik Dubois
# Website : https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

tput setaf 1
echo "################################################################"
echo "#####  DO NOT JUST RUN THIS - THIS MIGHT BRICK YOUR SYSTEM  ####"
echo "#####            Hybid pc - nvidia installer                ####"
echo "#####           We install the linux kernel too             ####"
echo "################################################################"
tput sgr0
echo
echo "Do you want Linux or Linux-ùts"
echo
echo "0.  Do nothing"
echo "1.  Linux"
echo "2.  Linux-lts"
echo "Type the number..."

read CHOICE

case $CHOICE in

    0 )
      echo
      echo "########################################"
      echo "We did nothing as per your request"
      echo "########################################"
      echo
      ;;

    1 )
      sudo pacman -S --noconfirm --needed linux
      sudo pacman -S --noconfirm --needed nvidia
      sudo pacman -S --noconfirm --needed nvidia-settings
      sudo pacman -S --noconfirm --needed lib32-nvidia-utils
      sudo pacman -S --noconfirm --needed mesa
      sudo pacman -S --noconfirm --needed xf86-video-intel
      sudo pacman -S --noconfirm --needed virtualgl
      sudo pacman -S --noconfirm --needed lib32-virtualgl
      sudo pacman -S --noconfirm --needed lib32-mesa
      sudo pacman -S --noconfirm --needed bbswitch

      yay -S optimus-manager
      yay -S optimus-manager-qt
      ;;

    2 )
      sudo pacman -S --noconfirm --needed linux-lts
      sudo pacman -S --noconfirm --needed nvidia-lts
      sudo pacman -S --noconfirm --needed nvidia-lts-settings
      sudo pacman -S --noconfirm --needed lib32-nvidia-lts-utils
      sudo pacman -S --noconfirm --needed mesa
      sudo pacman -S --noconfirm --needed xf86-video-intel
      sudo pacman -S --noconfirm --needed virtualgl
      sudo pacman -S --noconfirm --needed lib32-virtualgl
      sudo pacman -S --noconfirm --needed lib32-mesa
      sudo pacman -S --noconfirm --needed bbswitch

      sudo pacman -S --noconfirm --needed qt5-x11extras
      sudo pacman -S --noconfirm --needed qt5-svg
      sudo pacman -S --noconfirm --needed qt5-tools
      yay -S --noconfirm optimus-manager
      yay -S --noconfirm optimus-manager-qt
      ;;

    * )
      echo "#################################"
      echo "Choose the correct number"
      echo "#################################"
      ;;
esac

echo "################################################################"
echo "#########                   REBOOT              ################"
echo "################################################################"
