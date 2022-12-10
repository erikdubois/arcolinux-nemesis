#!/bin/bash
#set -e
##################################################################################################################
# Author 	: Erik Dubois
# Website   : https://www.erikdubois.be
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
#https://stackoverflow.com/questions/55940206/gpg2-wheres-linus-key

echo
tput setaf 2
echo "################################################################"
echo "################### Search for keys"
echo "################################################################"
tput sgr0
echo

gpg --search-keys ABAF11C65A2970B130ABE3C479BE3E4300411886

gpg --search-keys 647F28654894E3BD457199BE38DBBDC86092693E

echo
tput setaf 2
echo "################################################################"
echo "################### keys found"
echo "################################################################"
tput sgr0
echo