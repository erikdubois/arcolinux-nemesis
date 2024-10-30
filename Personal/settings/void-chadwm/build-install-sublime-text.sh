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
echo "################### Building from source"
echo "################################################################"
tput sgr0
echo

echo "XBPS_ALLOW_RESTRICTED=yes" | sudo tee /etc/xbps.d/00-restricted.conf > /dev/null

wget -qO sublime_text.tar.bz2 "https://download.sublimetext.com/sublime_text_4_build_4126_x64.tar.bz2"
sudo tar -xf sublime_text.tar.bz2 -C /opt
sudo ln -s /opt/sublime_text/sublime_text /usr/local/bin/sublime
sudo tee /usr/share/applications/sublime-text.desktop > /dev/null <<EOF
[Desktop Entry]
Name=Sublime Text
Comment=Text Editor
Exec=/opt/sublime_text/sublime_text %F
Icon=/opt/sublime_text/Icon/256x256/sublime-text.png
Terminal=false
Type=Application
Categories=Utility;TextEditor;Development;
StartupNotify=true
EOF


echo
tput setaf 6
echo "################################################################"
echo "###### Build and installed"
echo "################################################################"
tput sgr0
echo
