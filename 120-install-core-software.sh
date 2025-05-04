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

echo
tput setaf 2
echo "########################################################################"
echo "################### Core software"
echo "########################################################################"
tput sgr0
echo

# All the software below will be installed on all desktops except on Plasma
if [ ! -f /usr/share/wayland-sessions/plasma.desktop ]; then
  sudo pacman -S --noconfirm --needed alacritty
  sudo pacman -S --noconfirm --needed arandr
  sudo pacman -S --noconfirm --needed awesome-terminal-fonts
  sudo pacman -S --noconfirm --needed catfish
  sudo pacman -S --noconfirm --needed dmenu
  sudo pacman -S --noconfirm --needed evince
  sudo pacman -S --noconfirm --needed galculator
  sudo pacman -S --noconfirm --needed network-manager-applet
  sudo pacman -S --noconfirm --needed networkmanager-openvpn
  sudo pacman -S --noconfirm --needed nitrogen
  sudo pacman -S --noconfirm --needed numlockx
  sudo pacman -S --noconfirm --needed pamac-aur
  sudo pacman -S --noconfirm --needed pavucontrol
  sudo pacman -S --noconfirm --needed playerctl
  sudo pacman -S --noconfirm --needed sardi-icons
  sudo pacman -S --noconfirm --needed surfn-icons-git
  sudo pacman -S --noconfirm --needed xcolor
  sudo pacman -S --noconfirm --needed xorg-xkill
fi

# All the software below will be installed on all desktops
sudo pacman -S --noconfirm --needed adobe-source-sans-fonts
sudo pacman -S --noconfirm --needed aic94xx-firmware
sudo pacman -S --noconfirm --needed archlinux-tools
sudo pacman -S --noconfirm --needed avahi
sudo pacman -S --noconfirm --needed baobab
sudo pacman -S --noconfirm --needed bash-completion
sudo pacman -S --noconfirm --needed bat
sudo pacman -S --noconfirm --needed bibata-cursor-theme
sudo pacman -S --noconfirm --needed brave-bin
sudo pacman -S --noconfirm --needed breeze-icons
sudo pacman -S --noconfirm --needed btop
sudo pacman -S --noconfirm --needed chromium
sudo pacman -S --noconfirm --needed curl
sudo pacman -S --noconfirm --needed dconf-editor
sudo pacman -S --noconfirm --needed devtools
sudo pacman -S --noconfirm --needed discord
sudo pacman -S --noconfirm --needed downgrade
sudo pacman -S --noconfirm --needed dropbox
if [ ! -f /usr/bin/duf ]; then
  sudo pacman -S --noconfirm --needed duf
fi
sudo pacman -S --noconfirm --needed expac
sudo pacman -S --noconfirm --needed feh
sudo pacman -S --noconfirm --needed fastfetch-git
sudo pacman -S --noconfirm --needed file-roller
sudo pacman -S --noconfirm --needed firefox
sudo pacman -S --noconfirm --needed fish
sudo pacman -S --noconfirm --needed font-manager
sudo pacman -S --noconfirm --needed gimp
sudo pacman -S --noconfirm --needed git
sudo pacman -S --noconfirm --needed gnome-disk-utility
sudo pacman -S --noconfirm --needed gparted
sudo pacman -S --noconfirm --needed gvfs-smb
sudo pacman -S --noconfirm --needed gvfs-dnssd
sudo pacman -S --noconfirm --needed hardcode-fixer-git
sudo pacman -S --noconfirm --needed hardinfo2
sudo pacman -S --noconfirm --needed hddtemp
sudo pacman -S --noconfirm --needed hw-probe
sudo pacman -S --noconfirm --needed hyfetch
sudo pacman -S --noconfirm --needed inkscape
#sudo pacman -S --noconfirm --needed insync
sudo pacman -S --noconfirm --needed linux-firmware-qlogic
sudo pacman -S --noconfirm --needed logrotate
sudo pacman -S --noconfirm --needed lolcat
sudo pacman -S --noconfirm --needed lollypop
sudo pacman -S --noconfirm --needed lsb-release
sudo pacman -S --noconfirm --needed lshw
sudo pacman -S --noconfirm --needed man-db
sudo pacman -S --noconfirm --needed man-pages
sudo pacman -S --noconfirm --needed mkinitcpio-firmware
sudo pacman -S --noconfirm --needed plocate
sudo pacman -S --noconfirm --needed meld
sudo pacman -S --noconfirm --needed mintstick
sudo pacman -S --noconfirm --needed most
sudo pacman -S --noconfirm --needed namcap
sudo pacman -S --noconfirm --needed neofetch
sudo pacman -S --noconfirm --needed nomacs
sudo pacman -S --noconfirm --needed noto-fonts
sudo pacman -S --noconfirm --needed ntp
sudo pacman -S --noconfirm --needed nss-mdns
sudo pacman -S --noconfirm --needed oh-my-zsh-git
sudo pacman -S --noconfirm --needed pacmanlogviewer
sudo pacman -S --noconfirm --needed paru-git
sudo pacman -S --noconfirm --needed polkit-gnome
sudo pacman -S --noconfirm --needed python-pylint
sudo pacman -S --noconfirm --needed python-pywal
sudo pacman -S --noconfirm --needed pv
sudo pacman -S --noconfirm --needed qbittorrent
sudo pacman -S --noconfirm --needed rate-mirrors
sudo pacman -S --noconfirm --needed ripgrep
sudo pacman -S --noconfirm --needed rsync
sudo pacman -S --noconfirm --needed scrot
sudo pacman -S --noconfirm --needed simplescreenrecorder-qt6-git
sudo pacman -S --noconfirm --needed speedtest-cli
sudo pacman -S --noconfirm --needed spotify
sudo pacman -S --noconfirm --needed squashfs-tools
sudo pacman -S --noconfirm --needed sublime-text-4
sudo pacman -S --noconfirm --needed system-config-printer
sudo pacman -S --noconfirm --needed telegram-desktop
sudo pacman -S --noconfirm --needed the_silver_searcher
sudo pacman -S --noconfirm --needed time
sudo pacman -S --noconfirm --needed thunar
sudo pacman -S --noconfirm --needed thunar-archive-plugin
sudo pacman -S --noconfirm --needed thunar-volman
sudo pacman -S --noconfirm --needed tree
sudo pacman -S --noconfirm --needed ttf-bitstream-vera
sudo pacman -S --noconfirm --needed ttf-dejavu
sudo pacman -S --noconfirm --needed ttf-droid
sudo pacman -S --noconfirm --needed ttf-hack
sudo pacman -S --noconfirm --needed ttf-inconsolata
sudo pacman -S --noconfirm --needed ttf-liberation
sudo pacman -S --noconfirm --needed ttf-roboto
sudo pacman -S --noconfirm --needed ttf-roboto-mono
sudo pacman -S --noconfirm --needed ttf-ubuntu-font-family
sudo pacman -S --noconfirm --needed upd72020x-fw
sudo pacman -S --noconfirm --needed variety
sudo pacman -S --noconfirm --needed visual-studio-code-bin
sudo pacman -S --noconfirm --needed vivaldi
sudo pacman -S --noconfirm --needed vivaldi-ffmpeg-codecs
sudo pacman -S --noconfirm --needed vlc
sudo pacman -S --noconfirm --needed wd719x-firmware
sudo pacman -S --noconfirm --needed wget
sudo pacman -S --noconfirm --needed xdg-user-dirs
sudo pacman -S --noconfirm --needed yay-git
sudo pacman -S --noconfirm --needed zsh
sudo pacman -S --noconfirm --needed zsh-completions
sudo pacman -S --noconfirm --needed zsh-syntax-highlighting
sudo systemctl enable avahi-daemon.service
sudo systemctl enable ntpd.service

sudo pacman -S --noconfirm --needed gzip
sudo pacman -S --noconfirm --needed p7zip
sudo pacman -S --noconfirm --needed unace
sudo pacman -S --noconfirm --needed unrar
sudo pacman -S --noconfirm --needed unzip

if [ ! -f /usr/share/xsessions/plasmax11.desktop ]; then
  sudo pacman -S --noconfirm --needed qt5ct
  sudo pacman -S --noconfirm --needed kvantum-qt5
fi

tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo
