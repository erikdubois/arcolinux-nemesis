#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/common.sh"

log_section "Running $(script_name)"

pause_if_debug

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################

add_nemesis_repo() {
    if grep -q "nemesis_repo" /etc/pacman.conf; then
        log_section "nemesis_repo is already in /etc/pacman.conf"
    else
        log_section "nemesis_repo added to /etc/pacman.conf"

        sudo tee -a /etc/pacman.conf >/dev/null <<'EOF'

[nemesis_repo]
SigLevel = Optional TrustedOnly
Server = https://erikdubois.github.io/$repo/$arch
EOF
    fi
}

ensure_vconsole_font() {
    echo "Adding font to /etc/vconsole.conf"
    if ! grep -q "^FONT=" /etc/vconsole.conf 2>/dev/null; then
        echo "FONT=lat4-19" | sudo tee --append /etc/vconsole.conf >/dev/null
    fi
}

remove_plasma_arco_packages_if_needed() {
    if [[ -f /usr/share/wayland-sessions/plasma.desktop ]]; then
        remove_packages \
            arcolinux-plasma-keybindings-git \
            arcolinux-plasma-servicemenus-git \
            arcolinux-plasma-theme-candy-beauty-arc-dark-git \
            arcolinux-plasma-theme-candy-beauty-nordic-git \
            arcolinux-gtk-surfn-plasma-dark-git
    fi
}

install_xfce_extras_if_needed() {
    if [[ -f /usr/share/xsessions/xfce.desktop ]]; then
        install_packages \
            menulibre \
            mugshot
    fi
}

install_nemesis_software() {
    install_packages \
        mkinitcpio-firmware \
        upd72020x-fw \
        archlinux-tweak-tool-git \
        edu-dot-files-git \
        arc-gtk-theme \
        archlinux-logout-git \
        edu-arc-dawn-git \
        edu-arc-kde \
        edu-hblock-git \
        edu-rofi-git \
        edu-rofi-themes-git \
        edu-sddm-simplicity-git \
        edu-shells-git \
        edu-variety-config-git \
        edu-xfce-git \
        flameshot-git \
        gittyup \
        hardcode-fixer-git \
        lastpass \
        neo-candy-icons-git \
        rofi \
        sparklines-git \
        surfn-icons-git \
        wttr

    if ! grep -q "Manjaro" /etc/os-release; then
        install_packages pamac-aur
    fi
}

add_nemesis_repo

sudo pacman -Sy

log_section "Installing software from nemesis_repo"

install_xfce_extras_if_needed
ensure_vconsole_font
remove_plasma_arco_packages_if_needed
install_nemesis_software

log_subsection "$(script_name) done"