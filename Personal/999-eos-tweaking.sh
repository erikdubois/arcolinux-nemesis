#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
# Website   : https://www.alci.online
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

# when on EOS

###############################################################################
#
#   DECLARATION OF FUNCTIONS
#
###############################################################################

installed_dir=$(dirname $(readlink -f $(basename `pwd`)))

func_install() {
    if pacman -Qi $1 &> /dev/null; then
        tput setaf 2
        echo "###############################################################################"
        echo "################## The package "$1" is already installed"
        echo "###############################################################################"
        echo
        tput sgr0
    else
        tput setaf 3
        echo "###############################################################################"
        echo "##################  Installing package "  $1
        echo "###############################################################################"
        echo
        tput sgr0
        sudo pacman -S --noconfirm --needed $1
    fi
}

#if grep -q "EndeavourOS" /etc/os-release; then
    echo
    tput setaf 2
    echo "################################################################"
    echo "############### Installing/removing software for EOS"
    echo "################################################################"
    tput sgr0
    sudo pacman -R --noconfirm arc-gtk-theme-eos
    sudo pacman -R --noconfirm endeavouros-skel-default endeavouros-skel-xfce4
    sudo pacman -R --noconfirm firewalld

    sudo pacman -S --noconfirm --needed arc-gtk-theme
    sudo pacman -S --noconfirm --needed arcolinux-root-git


    sudo pacman -S --noconfirm --needed alacritty
    sudo pacman -S --noconfirm --needed arcolinux-alacritty-git
    sudo pacman -S --noconfirm --needed arcolinux-hblock-git
    sudo pacman -S --noconfirm --needed arcolinux-logout-git
    sudo pacman -S --noconfirm --needed arcolinux-paru-git
    sudo pacman -S --noconfirm --needed arcolinux-root-git
    #sudo pacman -S --noconfirm --needed arcolinux-system-config-dev-git  
    sudo pacman -S --noconfirm --needed arcolinux-tweak-tool-git
    sudo pacman -S --noconfirm --needed arcolinux-variety-git
    sudo pacman -S --noconfirm --needed arcolinux-wallpapers-git
    sudo pacman -S --noconfirm --needed arcolinux-zsh-git
    sudo pacman -S --noconfirm --needed avahi
    sudo systemctl enable avahi-daemon.service
    sudo pacman -S --noconfirm --needed bat
    sudo pacman -S --noconfirm --needed dmenu
    sudo pacman -S --noconfirm --needed expac
    sudo pacman -S --noconfirm --needed feh
    sudo pacman -S --noconfirm --needed gvfs-smb
    sudo pacman -S --noconfirm --needed hardcode-fixer-git
    sudo pacman -S --noconfirm --needed hw-probe
    sudo pacman -S --noconfirm --needed man-db
    sudo pacman -S --noconfirm --needed man-pages  
    sudo pacman -S --noconfirm --needed meld
    sudo pacman -S --noconfirm --needed mkinitcpio-firmware
    sudo pacman -S --noconfirm --needed neofetch
    sudo pacman -S --noconfirm --needed nss-mdns
    sudo pacman -S --noconfirm --needed oh-my-zsh-git
    sudo pacman -S --noconfirm --needed ripgrep
    sudo pacman -S --noconfirm --needed variety
    sudo pacman -S --noconfirm --needed zsh
    sudo pacman -S --noconfirm --needed zsh-completions
    sudo pacman -S --noconfirm --needed zsh-syntax-highlighting

    sudo pacman -S --noconfirm --needed adobe-source-sans-fonts
    sudo pacman -S --noconfirm --needed awesome-terminal-fonts
    sudo pacman -S --noconfirm --needed noto-fonts
    sudo pacman -S --noconfirm --needed ttf-bitstream-vera
    sudo pacman -S --noconfirm --needed ttf-dejavu
    sudo pacman -S --noconfirm --needed ttf-droid
    sudo pacman -S --noconfirm --needed ttf-hack
    sudo pacman -S --noconfirm --needed ttf-inconsolata
    sudo pacman -S --noconfirm --needed ttf-liberation
    sudo pacman -S --noconfirm --needed ttf-roboto
    sudo pacman -S --noconfirm --needed ttf-roboto-mono
    sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family

  echo
  echo "################################################################"
  echo "Getting latest /etc/nsswitch.conf from ArcoLinux"
  echo "################################################################"
  echo
  sudo cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
  sudo wget https://raw.githubusercontent.com/arcolinux/arcolinuxl-iso/master/archiso/airootfs/etc/nsswitch.conf -O $workdir/etc/nsswitch.conf

  # when on Plasma

  if [ -f /usr/bin/startplasma-x11 ]; then

    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Installing software for Arch Linux - Plasma"
    echo "################################################################"
    tput sgr0
    echo    
    sudo pacman -S --noconfirm --needed arcolinux-plasma-nordic-darker-candy-git
    sudo pacman -S --noconfirm --needed arcolinux-plasma-arc-dark-candy-git
    sudo pacman -S --noconfirm --needed surfn-plasma-dark-icons-git
    sudo pacman -S --noconfirm --needed surfn-plasma-light-icons-git

  fi

  # when on Xfce4

  if [ -f /usr/share/xsessions/xfce.desktop ]; then

    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Installing software for Arch Linux - Xfce4"
    echo "################################################################"
    tput sgr0
    echo

    sudo pacman -S --noconfirm --needed arcolinux-local-xfce4-git
    sudo pacman -S --noconfirm --needed sardi-icons
    sudo pacman -S --noconfirm --needed arcolinux-xfce-git
  fi

  # when on i3

  if [ -f /usr/share/xsessions/i3.desktop ]; then

    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Installing software for Arch Linux - i3wm"
    echo "################################################################"
    tput sgr0
    echo

    sudo pacman -S --noconfirm --needed arcolinux-i3wm-git
    sudo pacman -S --noconfirm --needed arcolinux-local-xfce4-git
    sudo pacman -S --noconfirm --needed autotiling
    sudo pacman -S --noconfirm --needed lxappearance
    sudo pacman -S --noconfirm --needed nitrogen
    sudo pacman -S --noconfirm --needed picom
    sudo pacman -S --noconfirm --needed sardi-icons
    sudo pacman -S --noconfirm --needed thunar
    sudo pacman -S --noconfirm --needed thunar-archive-plugin
    sudo pacman -S --noconfirm --needed thunar-volman

  fi

  # when on Cinnamon

  if [ -f /usr/bin/cinnamon ]; then

    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Cinnamon related applications"
    echo "################################################################"
    tput sgr0
    echo

    sudo pacman -S --noconfirm --needed cinnamon-translations
    sudo pacman -S --noconfirm --needed gnome-terminal
    sudo pacman -S --noconfirm --needed gnome-system-monitor
    sudo pacman -S --noconfirm --needed gnome-screenshot
    sudo pacman -S --noconfirm --needed iso-flag-png
    sudo pacman -S --noconfirm --needed mintlocale
    sudo pacman -S --noconfirm --needed nemo-fileroller

  fi

    echo
    tput setaf 2
    echo "################################################################"
    echo "################### SKEL !!!"
    echo "################################################################"
    tput sgr0
    echo

    cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)
    cp -arf /etc/skel/. ~

    source ~/.bashrc

    echo
    tput setaf 2
    echo "################################################################"
    echo "################### Software installed"
    echo "################################################################"
    tput sgr0
    echo

#fi


echo
tput setaf 2
echo "################################################################"
echo "################### Install leftwm"
echo "################################################################"
tput sgr0
echo


list=(
sxhkd
leftwm-dev-git
leftwm-theme-git
arcolinux-leftwm-git
arcolinux-volumeicon-git
polybar
lxappearance
nerd-fonts-source-code-pro
volumeicon
picom
ttf-fantasque-sans-mono
ttf-iosevka-nerd
ttf-material-design-iconic-font
ttf-meslo-nerd-font-powerlevel10k
rofi-theme-fonts
)

count=0

for name in "${list[@]}" ; do
    count=$[count+1]
    tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
    func_install $name
done

###############################################################################

echo
tput setaf 2
echo "################################################################"
echo "################### Install pamac"
echo "################################################################"
tput sgr0
echo

[ -d /etc/pacman.d/hooks ] || sudo mkdir -p /etc/pacman.d/hooks

sudo cp $installed_dir/settings/pacman-hook/archlinux-appstream-data-fix /usr/local/bin/archlinux-appstream-data-fix
sudo cp $installed_dir/settings/pacman-hook/archlinux-appstream-data.hook /etc/pacman.d/hooks/archlinux-appstream-data.hook

sudo pacman -S --noconfirm --needed arcolinux-pamac-all

###############################################################################

tput setaf 6
echo "################################################################"
echo "Copying all files and folders from /etc/skel to ~"
echo "################################################################"
echo;tput sgr0
cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S)
cp -arf /etc/skel/. ~

tput setaf 2
echo "################################################################"
echo "Done"
echo "################################################################"
echo;tput sgr0