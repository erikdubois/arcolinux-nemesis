#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
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
tput setaf 2
echo "################################################################"
echo "################### Bookmarks to install"
echo "################################################################"
tput sgr0
echo
installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

[ -d $HOME"/.config/gtk-3.0" ] || mkdir -p $HOME"/.config/gtk-3.0"
cp $installed_dir/settings/bookmarks/bookmarks* ~/.config/gtk-3.0/

echo
tput setaf 2
echo "################################################################"
echo "################### Bookmarks installed"
echo "################################################################"
tput sgr0
echo