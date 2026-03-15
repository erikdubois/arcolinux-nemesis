#!/bin/bash
# set -e
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
    echo "Debug mode is on. Press Enter to continue..."
    read dummy
    echo
fi

##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "###### Installing packages from PPA"
echo "########################################################################"
tput sgr0
echo

echo "###### Removing the following packages"

sudo snap remove firefox

echo
echo "########################################################################"
echo "###### Sublime-text"
echo "########################################################################"
echo

# https://www.sublimetext.com/docs/linux_repositories.html
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt update
sudo apt install sublime-text

echo
echo "########################################################################"
echo "###### Fastfetch"
echo "########################################################################"
echo

sudo add-apt-repository ppa:zhangsongcui3371/fastfetch -y
sudo apt update
sudo apt install -y fastfetch

echo
echo "########################################################################"
echo "###### Vivaldi"
echo "########################################################################"
echo

wget -qO- https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo dd of=/usr/share/keyrings/vivaldi-browser.gpg
echo "deb [signed-by=/usr/share/keyrings/vivaldi-browser.gpg arch=$(dpkg --print-architecture)] https://repo.vivaldi.com/archive/deb/ stable main" | sudo dd of=/etc/apt/sources.list.d/vivaldi-archive.list
sudo apt update && sudo apt install vivaldi-stable

echo
echo "########################################################################"
echo "###### Brave"
echo "########################################################################"
echo

sudo apt install curl -y

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install brave-browser -y

echo
echo "########################################################################"
echo "###### Code"
echo "########################################################################"
echo

sudo apt-get install wget gpg -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg

sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code # or code-insiders


echo
echo "########################################################################"
echo "###### Firefox"
echo "########################################################################"
echo

wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null
sudo apt update
sudo apt install -y firefox

echo
echo "########################################################################"
echo "###### Chromium"
echo "########################################################################"
echo

sudo add-apt-repository ppa:xtradeb/apps -y
sudo apt update
sudo apt install -y chromium

echo
echo "########################################################################"
echo "###### Discord"
echo "########################################################################"
echo

wget -qO-  https://palfrey.github.io/discord-apt/discord-apt.gpg.asc | sudo tee /etc/apt/trusted.gpg.d/discord-apt.gpg.asc > /dev/null
echo "deb https://palfrey.github.io/discord-apt/debian/ ./" | sudo tee /etc/apt/sources.list.d/discord.list > /dev/null
sudo apt update
sudo apt install -y discord

echo
echo "########################################################################"
echo "###### Anydesk"
echo "########################################################################"
echo
wget -qO-  https://keys.anydesk.com/repos/DEB-GPG-KEY | sudo tee /etc/apt/trusted.gpg.d/anydesk.gpg.asc > /dev/null
sudo sh -c 'echo "deb http://deb.anydesk.com/ all main" > /etc/apt/sources.list.d/anydesk-stable.list'
sudo apt update
sudo apt install -y anydesk

echo
echo "########################################################################"
echo "###### Opera"
echo "########################################################################"
echo
# https://deb.opera.com/manual.html
wget -qO- https://deb.opera.com/archive.key | gpg --dearmor | sudo dd of=/usr/share/keyrings/opera-browser.gpg
echo "deb [signed-by=/usr/share/keyrings/opera-browser.gpg] https://deb.opera.com/opera-stable/ stable non-free" | sudo dd of=/etc/apt/sources.list.d/opera-stable.list
sudo apt update
sudo apt install opera-stable -y

echo
tput setaf 6
echo "########################################################################"
echo "###### Packages local install done"
echo "########################################################################"
tput sgr0
echo
