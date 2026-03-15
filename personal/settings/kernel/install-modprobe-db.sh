#!/bin/bash
#set -e
##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "################### modprobed-db to install"
echo "########################################################################"
tput sgr0
echo

#https://wiki.archlinux.org/title/Modprobed-db

yay -S modprobed-db --noconfirm --needed
modprobed-db
modprobed-db store
systemctl --user enable --now modprobed-db.service

echo
tput setaf 2
echo "########################################################################"
echo "################### modprobed-db installed"
echo "########################################################################"
tput sgr0
echo