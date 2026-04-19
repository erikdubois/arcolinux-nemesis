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
echo "################### Installing Chadwm"
echo "########################################################################"
tput sgr0
echo

echo
tput setaf 2
echo "########################################################################"
echo "###### Installing packages"
echo "########################################################################"
tput sgr0
echo

sudo eopkg upgrade -y

# getting dependencies to be able to build Chadwm
sudo eopkg install -y -c system.devel
sudo eopkg install -y font-awesome-ttf
sudo eopkg install -y imlib2-devel
sudo eopkg install -y libx11-devel
sudo eopkg install -y libxft-devel
sudo eopkg install -y libxinerama-devel

# applications to be used in Chadwm
sudo eopkg install -y alacritty
sudo eopkg install -y arandr
sudo eopkg install -y dmenu
sudo eopkg install -y fastfetch
sudo eopkg install -y feh
sudo eopkg install -y picom
sudo eopkg install -y polkit-gnome
sudo eopkg install -y rofi
sudo eopkg install -y sxhkd
sudo eopkg install -y thunar
sudo eopkg install -y thunar-archive-plugin
sudo eopkg install -y thunar-volman
sudo eopkg install -y variety

# getting the official code
[ -d /tmp/edu-chadwm ] && rm -rf /tmp/edu-chadwm
git clone https://github.com/erikdubois/edu-chadwm  /tmp/edu-chadwm
sudo cp /tmp/edu-chadwm/usr/bin/exec-chadwm /usr/bin
sudo cp /tmp/edu-chadwm/usr/share/xsessions/chadwm.desktop /usr/share/xsessions
cp -rv /tmp/edu-chadwm/etc/skel/.bin ~
cp -rv /tmp/edu-chadwm/etc/skel/.config ~

# building Ohmyhadwm
cd ~/.config/edu-chadwm/chadwm
sudo make install
sudo make clean

# getting the official code
[ -d /tmp/ohmychadwm ] && rm -rf /tmp/ohmychadwm
git clone https://github.com/erikdubois/ohmychadwm  /tmp/ohmychadwm

# getting edu-powermenu
[ -d /tmp/edu-powermenu ] && rm -rf /tmp/edu-powermenu
git clone https://github.com/erikdubois/edu-powermenu  /tmp/edu-powermenu
sudo cp /tmp/edu-powermenu/usr/local/bin/edu-powermenu /usr/local/bin/edu-powermenu
cp -rv /tmp/edu-chadwm/etc/skel/.bin ~
cp -rv /tmp/edu-chadwm/etc/skel/.config ~

# building Chadwm
cd ~/.config/ohmychadwm/chadwm
sudo make install
sudo make clean

# removing this package - it slows down terminals and thunar
sudo eopkg remove -y xdg-desktop-portal-gnome

copy_skel_to_home() {

    echo "Final SKEL configuration"

    echo "Copying all files and folders from /etc/skel to HOME"
    echo "First we make a backup of ~/.config"
    echo "Wait for it ...."

    if [[ -d "${HOME}/.config" ]]; then
        local backup_dir="${HOME}/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)"

        echo "Creating backup: ${backup_dir}"
        cp -Rf "${HOME}/.config" "${backup_dir}"
    fi

    echo "Copying /etc/skel to HOME"
    cp -arf /etc/skel/. "${HOME}/"
}

copy_skel_to_home

echo
tput setaf 6
echo "########################################################################"
echo "###### Chadwm is installed - reboot"
echo "########################################################################"
tput sgr0
echo