#!/usr/local/bin/bash
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

installed_dir=$(pwd)

##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "################### All in one for GhostBSD"
echo "########################################################################"
tput sgr0
echo

# Check if /bin/bash exists
if [ ! -e /bin/bash ]; then
  # Create the symbolic link
  sudo ln -s /usr/local/bin/bash /bin/bash
  echo "Symbolic link created: /bin/bash -> /usr/local/bin/bash"
else
  echo "/bin/bash already exists. No action taken."
fi

echo
tput setaf 6
echo "########################################################################"
echo "###### Updating"
echo "########################################################################"
tput sgr0
echo

#sudo kldload linux64

sudo pkg update
sudo pkg upgrade

echo
tput setaf 6
echo "########################################################################"
echo "###### Start scripts"
echo "########################################################################"
tput sgr0
echo

./install-chadwm.sh
./install-apps-install.sh
./install-apps-local.sh
./install-apps-ppa.sh
# personal stuff
./install-design.sh
./install-sound.sh
./personal-configs.sh

echo
tput setaf 6
echo "########################################################################"
echo "###### All in one done"
echo "########################################################################"
tput sgr0
echo
