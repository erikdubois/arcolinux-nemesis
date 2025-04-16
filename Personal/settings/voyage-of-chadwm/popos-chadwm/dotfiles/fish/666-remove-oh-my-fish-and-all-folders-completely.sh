#!/bin/fish
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

# from script 2

omf remove gitstatus
omf remove lambda

# from script 3

omf remove git
omf remove fzf
omf remove colored-man-pages
omf remove pj

# from script 4

omf remove tide

# remove omf
curl -L http://get.oh-my.fish > install
fish install --uninstall --yes
rm ~/.config/fish/install

rm -rf ~/.config/omf
rm -rf ~/.local/share/omf
rm -rf ~/.cache/omf

echo
tput setaf 3
echo "################################################################"
echo "################### Oh my fish removed"
echo "################### Remove the fish_variables file if need be"
echo "################################################################"
tput sgr0
echo
