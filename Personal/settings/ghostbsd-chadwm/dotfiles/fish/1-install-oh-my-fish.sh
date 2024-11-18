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

echo
tput setaf 3
echo "################################################################"
echo "################### Installing oh my fish"
echo "################################################################"
tput sgr0
echo

echo "We assume you have installed these packages"
echo "sudo pacman -S fish arcolinux-fish-git"
echo
echo "Now change to fish with our alias - type it in a terminal"
echo
echo "tofish"
echo
[ -d $HOME"/.local/share/omf-backup" ] && rm -rf $HOME"/.local/share/omf-backup"
[ -d $HOME"/.local/share/omf" ] && mv -f $HOME"/.local/share/omf" $HOME"/.local/share/omf-backup"

curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish

echo
tput setaf 3
echo "################################################################"
echo "################### Oh my fish installed"
echo "################################################################"
tput sgr0
echo
