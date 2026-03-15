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

echo
tput setaf 2
echo "########################################################################"
echo "################### Building from source"
echo "########################################################################"
tput sgr0
echo

mkdir -p /tmp/deb/gitahead/DEBIAN
mkdir -p /tmp/deb/gitahead/usr/bin
mkdir -p /tmp/deb/gitahead/usr/share/applications

cp -v /tmp/gitahead/build/release/GitAhead /tmp/deb/gitahead/usr/bin
cp -v /tmp/gitahead/gitahead.desktop /tmp/deb/gitahead/usr/share/applications

echo "Package: Gitahead
Version: 2.7.1
Section: utils
Priority: optional
Architecture: all
Maintainer: Erik Dubois
Description: app for git" | tee /tmp/deb/gitahead/DEBIAN/control

cd /tmp/deb/
dpkg-deb --root-owner-group --build /tmp/deb/gitahead

echo
tput setaf 6
echo "########################################################################"
echo "###### Build and installed"
echo "########################################################################"
tput sgr0
echo
