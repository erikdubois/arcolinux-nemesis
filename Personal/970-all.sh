#!/bin/bash
#set -e
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

echo
echo "Adding nanorc settings"
echo

if [ -f /etc/nanorc ]; then
    sudo cp $installed_dir/settings/nano/nanorc /etc/nanorc
fi

echo
echo "Adding /etc/nsswitch settings"
echo

if [ -f /etc/nsswitch.conf ]; then
    sudo cp $installed_dir/settings/nsswitch/nsswitch.conf /etc/nsswitch.conf
fi

echo
echo "Adding /etc/environment settings"
echo

if [ -f /etc/environment ]; then
    sudo cp $installed_dir/settings/environment/environment /etc/environment
fi

echo
echo "Adding cursor - index.theme"
echo
if [ -f /usr/share/icons/default/index.theme ]; then
    sudo cp $installed_dir/settings/cursor/index.theme /usr/share/icons/default/index.theme
fi

echo
echo "Enable fstrim timer"
sudo systemctl enable fstrim.timer

echo
echo "Testing if qemu agent is still active"
result=$(systemd-detect-virt)
echo "Systemd-detect-virt = "
test=$(systemctl is-enabled qemu-guest-agent.service)
echo "Is qemu guest agent active = "
echo "If one of the parameters is empty you get unary parameter"
echo "Nothing is wrong however"
if [ $test == "enabled" ] && [ $result == "none" ] || [ $result == "oracle" ]; then
	echo
	echo "Disable qemu agent service"
	sudo systemctl disable qemu-guest-agent.service
	echo
fi

# personal /etc/pacman.d/gnupg/gpg.conf for Erik Dubois
if [[ ! -f /etc/pacman.d/gnupg/gpg.conf ]]; then
    echo
    tput setaf 2
    echo "################################################################################"
    echo "Copying gpg.conf to /etc/pacman.d/gnupg/gpg.conf"
    echo "################################################################################"
    tput sgr0
    echo
    sudo cp -v ../gpg.conf /etc/pacman.d/gnupg/gpg.conf
    echo
fi


















echo
echo "Adding Ubuntu keyserver..."

KEYSERVER="hkp://keyserver.ubuntu.com:80"
GPG_CONF="/etc/pacman.d/gnupg/gpg.conf"

if ! grep -q "$KEYSERVER" "$GPG_CONF"; then
    echo "Appending keyserver to $GPG_CONF"
    sudo tee -a "$GPG_CONF" > /dev/null <<EOF

keyserver $KEYSERVER

#keyserver hkp://keys.openpgp.org
#keyserver hkp://keys.openpgp.org:80
#keyserver hkps://keys.openpgp.org
#keyserver hkps://keys.openpgp.org:443
#keyserver hkps://keyserver.ubuntu.com:443
#keyserver hkp://pool.sks-keyservers.net:80
#keyserver hkps://hkps.pool.sks-keyservers.net:443
#keyserver hkp://ipv4.pool.sks-keyservers.net:11371
EOF
else
    echo "Keyserver already present in $GPG_CONF"
fi
echo


echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo