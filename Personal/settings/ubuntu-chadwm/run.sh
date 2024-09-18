#!/bin/sh

#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
picom -b  --config ~/.config/arco-chadwm/picom/picom.conf &
variety -n
run "numlockx on"
sxhkd -c ~/.config/arco-chadwm/sxhkd/sxhkdrc &

pkill bar.sh
~/.config/arco-chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
