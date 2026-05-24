#!/bin/sh

sxhkd -c ~/.config/chadwm/sxhkd/sxhkdrc &

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
picom -b  --config ~/.config/chadwm/picom/picom.conf &
variety -n &
numlockx on &
pkill bar.sh &
sh ~/.config/chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
