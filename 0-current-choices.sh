#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
# Website	: https://www.arcolinux.info
# Website	: https://www.arcolinux.com
# Website	: https://www.arcolinuxd.com
# Website	: https://www.arcolinuxb.com
# Website	: https://www.arcolinuxiso.com
# Website	: https://www.arcolinuxforum.com
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

echo
tput setaf 3
echo "################################################################"
echo "################### Start current choices"
echo "################################################################"
tput sgr0
echo

sh 400-remove-software*

sh 100-install-core-software*
sh 200-software-AUR-repo*
#sh 300-sardi-extra-icons-AUR-repo*
#sh 310-sardi-mint-y-icons-AUR-repo*
#sh 320-surfn-mint-y-icons-git-AUR-repo*

echo
tput setaf 2
echo "################################################################"
echo "################### Going to the Personal folder"
echo "################################################################"
tput sgr0
echo 

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))
cd $installed_dir/Personal

sh 900-install-personal-settings-folders*
sh 905-install-personal-settings-bookmarks*
#sh 910-firefox-fix-unreadable-text-for-dark-themes-settings*
#sh 915-install-personal-settings-screenshot-to-jpg*
#sh 920-fix-simplescreenrecorder*
sh 921-fix-dropbox*
#sh 922-fix-sublime-text-icons*
sh 923-fix-telegram*
sh 930-autostart-applications*
sh 935-plasma-specific-applications-and-setttings*
sh 940-btrfs-setup*
#sh 950-install-all-fonts-needed-for-conkys-of-arcolinux*
#sh 955-install-settings-autoconnect-to-bluetooth-headset*
sh 960-ckb-next*
sh 970-alci*
sh 970-aa*
sh 970-carli*

tput setaf 3
echo "################################################################"
echo "End current choices"
echo "################################################################"
tput sgr0
