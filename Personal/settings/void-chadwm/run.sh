#!/bin/sh
# next line changes the keyboard to be-latin1
setxkbmap be

# Check the virtualization environment
result=$(sudo virt-what)

# Check if running on real metal (not kvm)
if [[ $result = "kvm" ]]; then
	xrandr --output Virtual1 --primary --mode 1920x1080 --pos 0x0 --rotate normal
else
	xrandr --output HDMI2 --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VIRTUAL1 --off
fi

sxhkd -c ~/.config/arco-chadwm/sxhkd/sxhkdrc &

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
picom -b  --config ~/.config/arco-chadwm/picom/picom.conf &
variety -n &
numlockx on &
pkill bar.sh &
sh ~/.config/arco-chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
