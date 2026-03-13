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
#   Purpose:
#   - Install the broad desktop/tooling baseline used by Nemesis.
#   - Apply desktop-manager logic depending on whether Plasma is present.
#   - Enable a few services that should be active on most systems.
#
##################################################################################################################################

# Detect any Plasma session, regardless of X11 or Wayland.
is_plasma_installed() {
    [[ -f /usr/share/wayland-sessions/plasma.desktop || -f /usr/share/xsessions/plasma.desktop ]]
}

# Detect Plasma X11 specifically. This matters for qt5ct/kvantum handling.
is_plasma_x11_installed() {
    [[ -f /usr/share/xsessions/plasmax11.desktop ]]
}

# Archcraft may ship without XFCE by default in the scenario targeted here,
# so install it explicitly when that distro is detected.
install_archcraft_xfce_if_needed() {
    if grep -q "archcraft" /etc/os-release; then
        log_warn "Archcraft detected - installing XFCE packages"
        install_packages xfce4 xfce4-goodies
    fi
}

# Non-Plasma systems use sddm-git here. Plasma keeps the regular sddm
# package because that is the expected display-manager combination.
replace_sddm_with_sddm_git_if_needed() {
    if ! is_plasma_installed; then
        log_warn "Not on Plasma. Replacing sddm with sddm-git"

        if pacman -Qq sddm 2>/dev/null | grep -qx "sddm"; then
            sudo pacman -R --noconfirm sddm &>/dev/null
        fi

        install_packages sddm-git
    else
        log_section "Plasma detected. Keeping sddm."
    fi
}

# Ensure the git build is the installed variant.
# Note: the current logic checks for the plain package name before removal.
# That is consistent with the earlier cleanup direction you took today, but
# this is also one of the first places I would revisit later for refinement.
reinstall_simplescreenrecorder_git() {
    log_section "Ensuring simplescreenrecorder-git is installed"

    for pkg in simplescreenrecorder simplescreenrecorder-git; do
        if pacman -Qq simplescreenrecorder 2>/dev/null | grep -qx "simplescreenrecorder"; then
            echo "Removing ${pkg}..."
            sudo pacman -Rns --noconfirm "${pkg}" &>/dev/null
        fi
    done

    install_packages simplescreenrecorder-git
}

# Extra tools used on non-Plasma desktops.
install_non_plasma_packages() {
    if ! [[ -f /usr/share/wayland-sessions/plasma.desktop ]]; then
        log_section "Installing software for non-Plasma desktops"

        local pkgs=(
            alacritty
            arandr
            catfish
            dmenu
            evince
            galculator
            network-manager-applet
            networkmanager-openvpn
            networkmanager
            numlockx
            pavucontrol
            playerctl
            sardi-icons
            surfn-icons-git
            xcolor
            xorg-xkill
        )

        install_packages "${pkgs[@]}"
    fi
}

# Main cross-desktop package set.
# This list is intentionally broad: shells, fonts, browsers, utilities,
# archive tools, firmware, and desktop helpers all live here.
install_core_packages() {
    log_section "Installing core software"

    local pkgs=(
        fastfetch-git
        chaotic-neofetch-git
        yay-git
        paru-git
        adobe-source-sans-fonts
        aic94xx-firmware
        archlinux-tools
        avahi
        baobab
        bash-completion
        bat
        bibata-cursor-theme
        brave-bin
        btop
        chromium
        curl
        dconf-editor
        debugedit
        devtools
        downgrade
        duf
        expac
        fakeroot
        feh
        file-roller
        firefox
        fish
        font-manager
        gcolor3
        gimp
        git
        gnome-disk-utility
        gparted
        gvfs-smb
        gvfs-dnssd
        hardcode-fixer-git
        hardinfo2
        inetutils
        inkscape
        logrotate
        lolcat
        lsb-release
        lshw
        man-db
        man-pages
        nano
        plocate
        meld
        mintstick
        most
        namcap
        nomacs
        noto-fonts
        ntp
        nss-mdns
        oh-my-zsh-git
        pacmanlogviewer
        polkit-gnome
        python-pylint
        python-pywal
        pv
        qbittorrent
        rate-mirrors
        resources
        ripgrep
        rsync
        scrot
        shortwave
        smartmontools
        speedtest-cli
        squashfs-tools
        sublime-text-4
        system-config-printer
        the_silver_searcher
        time
        thunar
        thunar-archive-plugin
        thunar-volman
        tree
        ttf-dejavu
        ttf-droid
        ttf-hack
        ttf-liberation
        ttf-ms-fonts
        ttf-roboto
        ttf-roboto-mono
        ttf-ubuntu-font-family
        upd72020x-fw
        variety
        vivaldi
        vivaldi-ffmpeg-codecs
        vlc
        vlc-plugins-all
        wd719x-firmware
        wget
        xdg-user-dirs
        yad
        zsh
        zsh-completions
        zsh-syntax-highlighting
        gzip
        p7zip
        unace
        unrar
        unzip
        hw-probe
        insync
        signal-in-tray
        spotify
        telegram-desktop
        visual-studio-code-bin
    )

    install_packages "${pkgs[@]}"
}

# These services are part of the baseline experience expected by this setup.
enable_core_services() {
    log_section "Enabling core services"
    enable_service avahi-daemon.service
    enable_service ntpd.service
}

# qt5ct/kvantum are useful outside Plasma X11, but redundant or undesired
# on Plasma X11 itself.
handle_qt5ct_and_kvantum() {
    if ! is_plasma_x11_installed; then
        log_section "Plasma X11 not detected - installing qt5ct and kvantum-qt5"
        install_packages qt5ct kvantum-qt5
    else
        log_section "Plasma X11 detected - removing qt5ct and kvantum-qt5"
        remove_packages qt5ct kvantum-qt5
    fi
}

# Execution order matters here: distro-specific desktop fixes first,
# then display-manager handling, then packages, then services.
install_archcraft_xfce_if_needed
replace_sddm_with_sddm_git_if_needed
reinstall_simplescreenrecorder_git
install_non_plasma_packages
install_core_packages
enable_core_services
handle_qt5ct_and_kvantum

log_subsection "$(script_name) done"
