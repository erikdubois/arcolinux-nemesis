#!/bin/sh

setxkbmap be

xrandr --output VGA-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal
xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off

sxhkd -c ~/.config/arco-chadwm/sxhkd/sxhkdrc &

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
picom -b  --config ~/.config/arco-chadwm/picom/picom.conf &
variety -n &
numlockx on &
pkill bar.sh &
sh ~/.config/arco-chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
