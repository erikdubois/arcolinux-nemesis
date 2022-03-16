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
echo "################### Fonts to be installed"
echo "################################################################"
tput sgr0
echo

[ -d $HOME"/.fonts" ] || mkdir -p $HOME"/.fonts"

echo
echo "Copy fonts to .fonts"
echo
installed_dir=$(dirname $(readlink -f $(basename `pwd`)))
cp $installed_dir/settings/fonts/* ~/.fonts/
echo
echo "Building new fonts into the cache files";
echo "Depending on the number of fonts, this may take a while..."
echo
fc-cache -fv ~/.fonts

echo
tput setaf 2
echo "################################################################"
echo "################### Fonts installed"
echo "################################################################"
tput sgr0
echo