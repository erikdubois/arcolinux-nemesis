#!/bin/bash
set -e
##################################################################################################################
# Author 	: 	Erik Dubois
# Website 	: 	https://www.erikdubois.be
# Website	:	https://www.archmerge.info
# Website	:	https://www.archmerge.com
# Website	:	https://www.archmerged.com
# Website	:	https://www.archmergeforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################


########################################
########        C O N K Y      #########
########################################


echo "################################################################"
echo "Downloading the files from github to tmp directory"

rm -rf /tmp/aureola

git clone https://github.com/erikdubois/Aureola /tmp/aureola

# if there is already a folder in tmp, delete or else do nothing
[ -d ~/.aureola ] && rm -rf ~/.aureola
mv -f /tmp/aureola ~/.aureola

rm -rf /tmp/aureola

echo "################################################################"
echo "###################    aureola installed  ######################"
echo "################################################################"
