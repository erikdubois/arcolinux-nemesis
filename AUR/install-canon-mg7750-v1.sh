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


package="cnijfilter2-mg7700"

#----------------------------------------------------------------------------------

#checking which helper is installed
if pacman -Qi yaourt &> /dev/null; then

	echo "Installing with yaourt"
	yaourt -S --noconfirm $package
	
elif pacman -Qi pacaur &> /dev/null; then

	echo "Installing with pacaur"
	pacaur -S --noconfirm --noedit  $package

elif pacman -Qi packer &> /dev/null; then

	echo "Installing with packer"
	packer -S --noconfirm --noedit  $package

fi






program="scangearmp2-mg7700"

if which pacaur > /dev/null; then

	echo "Installing with pacaur"
	pacaur -S --noconfirm --noedit  $program

elif which packer > /dev/null; then

	echo "Installing with packer"
	packer -S --noconfirm --noedit  $program

elif which yaourt > /dev/null; then

	echo "Installing with yaourt"
	yaourt -S --noconfirm $program

fi



############################################################################

echo "################################################################"
echo "###################    canon installed    ######################"
echo "################################################################"
