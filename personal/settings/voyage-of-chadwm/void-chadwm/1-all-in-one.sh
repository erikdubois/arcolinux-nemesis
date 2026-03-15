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
echo "################### All in one for Void"
echo "########################################################################"
tput sgr0
echo

# allow non-free repos
echo "XBPS_ALLOW_RESTRICTED=yes" | sudo tee /etc/xbps.d/00-restricted.conf > /dev/null

sudo xbps-install -S void-repo-nonfree --yes

sudo xbps-install -Su --yes

./install-chadwm.sh
./install-apps-install.sh
./install-apps-local.sh

#./install-apps-ppa.sh
#./install-apps-snap.sh
# personal stuff
./install-design.sh
./personal-configs.sh

# after installing everything rebuilding
cd ~/.config/arco-chadwm/chadwm
./rebuild.sh

echo
tput setaf 6
echo "########################################################################"
echo "###### All in one done"
echo "########################################################################"
tput sgr0
echo
