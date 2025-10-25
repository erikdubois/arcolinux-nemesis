#!/bin/bash
#set -e
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
    read -n 1 -s -r -p "Debug mode is on. Press any key to continue..."
    echo
fi

##################################################################################################################################

echo
tput setaf 2
echo "########################################################################"
echo "################### Changing icons - hardcode-fixer"
echo "########################################################################"
tput sgr0
echo
echo "Checking if icons from applications have a hardcoded path"
echo "and fixing them"
echo "Wait for it ..."

sudo hardcode-fixer

##################################################################################################################################

hyprland="/usr/share/wayland-sessions/hyprland.desktop"
wayfire="/usr/share/wayland-sessions/wayfire.desktop"
sway="/usr/share/wayland-sessions/sway.desktop"

# common to all desktops

if [[ -f $hyprland || -f $wayfire || -f $sway ]]; then

  echo
  echo "We found one or more of these three: sway, wayfire or hyprland"
  echo

  echo "Adding thunar settings"
  echo "Adding gtk3 settings"
  echo

  # wayfire code
  
  config="${XDG_CONFIG_HOME:-$HOME/.config}/gtk-3.0/settings.ini"
  if [ ! -f "$config" ]; then exit 1; fi

  gnome_schema="org.gnome.desktop.interface"
  gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
  icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
  cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
  font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
  gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
  gsettings set "$gnome_schema" icon-theme "$icon_theme"
  gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
  gsettings set "$gnome_schema" font-name "$font_name"

fi

# each desktop is unique

if [ -f /usr/share/wayland-sessions/sway.desktop ]; then
  echo
  tput setaf 2
  echo "########################################################################"
  echo "################### We are on Sway"
  echo "########################################################################"
  tput sgr0
  echo
  
  give-me-azerty-be-sway

fi

if [ -f /usr/share/wayland-sessions/wayfire.desktop ]; then
  echo
  tput setaf 2
  echo "########################################################################"
  echo "################### We are on Wayfire"
  echo "########################################################################"
  tput sgr0
  echo

  give-me-azerty-be-wayfire

fi

if [ -f /usr/share/wayland-sessions/hyprland.desktop ]; then
  echo
  tput setaf 2
  echo "########################################################################"
  echo "################### We are on Hyprland"
  echo "########################################################################"
  tput sgr0
  echo

  give-me-azerty-be-hyprland
  
fi

if grep -q "ArchBang" /etc/os-release; then
  result=$(systemd-detect-virt)
  if [ $result = "oracle" ];then
    echo
    tput setaf 2
    echo "########################################################################"
    echo "################### We are on ArchBang in Virtualbox"
    echo "########################################################################"
    tput sgr0
    echo

    if ! grep -q "xrandr --output Virtual-1" $HOME/.config/openbox/autostart; then
      echo -e ${NEWLINEVAR} | sudo tee -a $HOME/.config/openbox/autostart;
      echo "xrandr --output Virtual-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal &" | sudo tee -a $HOME/.config/openbox/autostart;
    fi

    if [ -f /usr/share/xsessions/chadwm.desktop ]; then
      if ! grep -q "xrandr --output Virtual-1" $HOME/.config/arco-chadwm/scripts/run.sh; then
        echo -e ${NEWLINEVAR} | sudo tee -a $HOME/.config/arco-chadwm/scripts/run.sh
        sed -i '1s/^/xrandr --output Virtual-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal &/' $HOME/.config/arco-chadwm/scripts/run.sh
      fi
    fi
  fi
fi

echo
tput setaf 6
echo "##############################################################"
echo "###################  $(basename $0) done"
echo "##############################################################"
tput sgr0
echo