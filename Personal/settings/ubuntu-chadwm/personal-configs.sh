#!/bin/bash
# set -e
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

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################

echo
tput setaf 2
echo "################################################################"
echo "################### Personal choices"
echo "################################################################"
tput sgr0
echo

if [ -f ~/.bashrc ]; then
	echo '
alias update="sudo apt update && sudo apt upgrade"
alias sr="reboot"' | tee -a ~/.bashrc
fi

if [ -f ~/.config/fish/config.fish ]; then
	echo '
alias update="sudo apt update && sudo apt upgrade"
alias sr="reboot"' | tee -a ~/.config/fish/config.fish
fi

echo
echo "To fish we go"
echo
FIND="bash"
REPLACE="fish"
sudo sed -i "s/$FIND/$REPLACE/g" /etc/passwd
echo
tput setaf 6
echo "################################################################"
echo "###### Done"
echo "################################################################"
tput sgr0
echo
