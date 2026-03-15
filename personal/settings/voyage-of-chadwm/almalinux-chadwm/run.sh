#!/bin/sh

# Check if we are running inside VirtualBox
if lspci | grep -q "VirtualBox"; then
    echo "Running on VirtualBox. Setting resolution to 1920x1080..."

    # Check connected display name (often 'Virtual1' in VirtualBox, but can vary)
    display=$(xrandr | grep " connected" | awk '{ print $1 }')

    # Check if the 1920x1080 resolution is available
    if ! xrandr | grep -q "1920x1080"; then
        # Add the 1920x1080 mode if it's not available
        xrandr --newmode "1920x1080" 173.00 1920 2048 2248 2576 1080 1083 1088 1120 -hsync +vsync
        xrandr --addmode "$display" 1920x1080
    fi

    # Set the display to 1920x1080 resolution
    xrandr --output "$display" --mode 1920x1080
    echo "Resolution set to 1920x1080."
else
    echo "Not running in VirtualBox. No changes made."
fi

sxhkd -c ~/.config/arco-chadwm/sxhkd/sxhkdrc &

/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &
#picom -b  --config ~/.config/arco-chadwm/picom/picom.conf &
picom &
variety -n &
feh --bg-fill /usr/share/backgrounds/Alma-light-2560x1600.jpg &
numlockx on &
pkill bar.sh &
sh ~/.config/arco-chadwm/scripts/bar.sh &
while type chadwm >/dev/null; do chadwm && continue || break; done
