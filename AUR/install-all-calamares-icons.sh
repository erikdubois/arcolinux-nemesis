#!/bin/bash
#set -e
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

###############################################################################
#
#   DECLARATION OF FUNCTIONS
#
###############################################################################


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

###############################################################################
echo "Installation of the core software"
###############################################################################

list=(
arc-icon-theme
a-candy-beauty-icon-theme-git
breeze
faba-icon-theme-git
faba-mono-icons-git
flat-remix-git
halo-icons-git
la-capitaine-icon-theme-git
moka-icon-theme-git
numix-circle-arc-icons-git
numix-circle-icon-theme-git
obsidian-icon-theme
oranchelo-icon-theme-git
paper-icon-theme
papirus-icon-theme
qogir-icon-theme
tela-circle-icon-theme-git
vimix-icon-theme-git
we10x-icon-theme-git
whitesur-icon-theme-git
zafiro-icon-theme
)

count=0

for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

# onliner
# sudo pacman -S arc-icon-theme a-candy-beauty-icon-theme-git breeze faba-icon-theme-git faba-mono-icons-git flat-remix-git halo-icons-git la-capitaine-icon-theme-git moka-icon-theme-git numix-circle-arc-icons-git numix-circle-icon-theme-git obsidian-icon-theme oranchelo-icon-theme-git paper-icon-theme papirus-icon-theme qogir-icon-theme surfn-mint-y-icons-git tela-circle-icon-theme-git vimix-icon-theme-git we10x-icon-theme-git whitesur-icon-theme-git zafiro-icon-theme
# 166MB to download
# 1,985 GB to install