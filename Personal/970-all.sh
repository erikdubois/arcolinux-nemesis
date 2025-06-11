#!/bin/bash
#set -e
##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
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

if [ "$DEBUG" = true ]; then
    echo
    echo "------------------------------------------------------------"
    echo "Running $(basename $0)"
    echo "------------------------------------------------------------"
    echo
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################################

echo
tput setaf 3
echo "########################################################################"
echo "################### FOR ANY ARCH LINUX SYSTEM"
echo "########################################################################"
tput sgr0
echo

echo "Adding font to /etc/vconsole.conf"
if ! grep -q "FONT=" /etc/vconsole.conf; then
echo '
FONT=lat4-19' | sudo tee --append /etc/vconsole.conf
fi

echo
echo "Overwriting /etc/nanorc settings"
echo

if [ -f /etc/nanorc-nemesis ]; then
  # Do nothing because backup already exists
  :
elif [ -f /etc/nanorc ]; then
  sudo mv -v /etc/nanorc /etc/nanorc-nemesis
  sudo cp -v $installed_dir/settings/nano/nanorc /etc/nanorc
fi

echo
echo "Overwriting /etc/nsswitch settings"
echo

if [ -f /etc/nsswitch.conf-nemesis ]; then
  # Do nothing because backup already exists
  :
elif [ -f /etc/nsswitch.conf ]; then
  sudo mv -v /etc/nsswitch.conf /etc/nsswitch.conf-nemesis
  sudo cp $installed_dir/settings/nsswitch/nsswitch.conf /etc/nsswitch.conf
fi

echo
echo "Overwriting /etc/environment settings"
echo

if [ -f /etc/environment-nemesis ]; then
  # Do nothing because backup already exists
  :
elif [ -f /etc/environment ]; then
  sudo mv -v /etc/environment /etc/environment-nemesis
  sudo cp $installed_dir/settings/environment/environment /etc/environment
fi

echo
echo "Overwriting cursor - index.theme - bibata cursor"
echo "/usr/share/icons/default/index.theme"
echo
if [ -f /usr/share/icons/default/index.theme ]; then
    sudo cp $installed_dir/settings/cursor/index.theme /usr/share/icons/default/index.theme
fi

echo
echo "Enable fstrim timer for SSD"
sudo systemctl enable fstrim.timer


echo
echo "Testing if qemu agent is still active"
result=$(systemd-detect-virt)
echo "Systemd-detect-virt = $result"

if systemctl list-unit-files | grep -q '^qemu-guest-agent.service'; then
    test=$(systemctl is-enabled qemu-guest-agent.service 2>/dev/null)
    echo "Is qemu guest agent active = $test"

    if { [ "$test" = "enabled" ] && [ "$result" = "none" ]; } || [ "$result" = "oracle" ]; then
        echo
        echo "Disable qemu agent service"
        sudo systemctl disable qemu-guest-agent.service
        echo
    fi
else
    echo "qemu-guest-agent.service not installed – nothing to disable."
fi

# personal /etc/pacman.d/gnupg/gpg.conf for Erik Dubois

echo
tput setaf 2
echo "################################################################################"
echo "Copying gpg.conf to /etc/pacman.d/gnupg/gpg.conf"
echo "################################################################################"
tput sgr0
echo

if [ -f /etc/pacman.d/gnupg/gpg.conf-nemesis ]; then
  # Do nothing because backup already exists
  :
elif [ -f /etc/pacman.d/gnupg/gpg.conf ]; then
  sudo mv -v /etc/pacman.d/gnupg/gpg.conf /etc/pacman.d/gnupg/gpg.conf-nemesis
  sudo cp $installed_dir/settings/gnupg/gpg.conf /etc/pacman.d/gnupg/gpg.conf
fi

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo