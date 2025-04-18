#!/bin/bash
# set -e
##################################################################################################################################
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
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue
##################################################################################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

##################################################################################################################################

# https://github.com/void-linux/void-packages

echo
tput setaf 2
echo "########################################################################"
echo "###### Installing packages local install - void packages"
echo "###### https://github.com/void-linux/void-packages"
echo "###### https://github.com/void-linux/void-packages/tree/master/srcpkgs"
echo "########################################################################"
tput sgr0
echo

if [ ! -d ~/DATA ]; then
	mkdir ~/DATA
fi

cd ~/DATA
if [ ! -d "void-packages" ]; then
    git clone --depth 1 https://github.com/void-linux/void-packages.git
    cd void-packages
    #echo "XBPS_ALLOW_RESTRICTED=yes" | tee ./etc/xbps.d/00-restricted.conf > /dev/null
    echo "XBPS_ALLOW_RESTRICTED=yes" | tee ./etc/conf > /dev/null
    ./xbps-src binary-bootstrap
else
	cd void-packages
    echo "XBPS_ALLOW_RESTRICTED=yes" | tee ./etc/conf > /dev/null
    git pull
fi

# Function to build and install a package if not already installed
build_and_install() {
    PACKAGE_NAME=$1
    if ! xbps-query $PACKAGE_NAME > /dev/null 2>&1; then
        ./xbps-src pkg $PACKAGE_NAME
        sudo xbps-install --repository hostdir/binpkgs/nonfree/ $PACKAGE_NAME --yes
    else
        echo "$PACKAGE_NAME is already installed. Skipping build."
    fi
}

# Call the function for each package
build_and_install "vivaldi"
build_and_install "sublime-text4"
build_and_install "telegram-desktop"
build_and_install "opera"
build_and_install "spotify"

echo
tput setaf 6
echo "########################################################################"
echo "###### Packages local build done"
echo "########################################################################"
tput sgr0
echo