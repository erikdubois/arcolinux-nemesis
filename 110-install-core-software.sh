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
        unifetch
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

# Execution order matters here: Sddm handling first
# then display-manager handling, then packages, then services.
replace_sddm_with_sddm_git_if_needed
reinstall_simplescreenrecorder_git
install_non_plasma_packages
install_core_packages
enable_core_services

log_subsection "$(script_name) done"
