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

# Extra tools used on non-Plasma desktops.
install_non_plasma_packages() {
    if ! [[ -f /usr/share/wayland-sessions/plasma.desktop ]]; then
        log_section "Installing software for non-Plasma desktops"

        local pkgs=(
            alacritty
            catfish
            evince
            galculator
            network-manager-applet
            networkmanager-openvpn
            networkmanager
            pavucontrol
            playerctl
            surfn-icons-git
        )

        install_packages "${pkgs[@]}"
    fi
}

# X11-only tools - useless on a Wayland-only system, so skipped when there is no X session.
install_x11_only_packages() {
    if ! has_x11_session; then
        log_warn "No X11 session found - skipping X11-only tools"
        return 0
    fi

    install_packages scrot

    if ! [[ -f /usr/share/wayland-sessions/plasma.desktop ]]; then
        install_packages arandr dmenu numlockx xcolor xorg-xkill
    fi
}

# Install XFCE tools if XFCE session exists
install_xfce_extras_if_needed() {
    if [[ -f /usr/share/xsessions/xfce.desktop ]]; then
        install_packages \
            menulibre \
            mugshot
    fi
}

# Main cross-desktop package set.
# This list is intentionally broad: shells, fonts, browsers, utilities,
# archive tools, firmware, and desktop helpers all live here.
install_core_packages() {
    log_section "Installing core software"

    # Swap stock fastfetch -> fastfetch-git as its own step first.
    # fastfetch-git Conflicts/Provides fastfetch, but pacman --noconfirm answers
    # "N" to the replace prompt and would abort the whole batch. Force-remove
    # fastfetch (-Rdd, ignoring alacritty-tweak-tool-gtk4-git's hard dep), then
    # install fastfetch-git, which immediately re-provides fastfetch so the
    # dependency is satisfied again. The helper is a no-op if fastfetch is absent.
    remove_matching_packages_deps_dd fastfetch
    install_packages fastfetch-git

    local pkgs=(
        unifetch
        yay-git
        paru-git
        adobe-source-sans-fonts
        aic94xx-firmware
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
        python-flake8
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
        ruff
        rsync
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
        zapzap
        zsh
        zsh-completions
        zsh-syntax-highlighting
        gzip
        unace
        unrar
        unzip
        hw-probe
        insync
        signal-in-tray
        spotify
        visual-studio-code-bin
    )

    install_packages "${pkgs[@]}"
}

# These services are part of the baseline experience expected by this setup.
enable_core_services() {
    log_section "Enabling core services"
    enable_now_service avahi-daemon.service
    enable_now_service man-db.timer
    if ! systemctl show plocate-updatedb.timer -p UnitFileState --value 2>/dev/null | grep -q static; then
        enable_now_service plocate-updatedb.timer
    fi
    enable_now_service logrotate.timer
}

# Execution order matters here: Sddm handling first
# then display-manager handling, then packages, then services.
install_non_plasma_packages
install_x11_only_packages
install_xfce_extras_if_needed
install_core_packages
enable_core_services

log_subsection "$(script_name) done"
