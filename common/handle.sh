#!/usr/bin/env bash

# Only load once
[[ -n "${HANDLE_SH_LOADED:-}" ]] && return 0
readonly HANDLE_SH_LOADED=1

# shellcheck disable=SC2154

is_os_release_match() {
    local pattern="$1"
    grep -qi -- "$pattern" /etc/os-release 2>/dev/null
}

is_omarchy() {
    [[ -f /etc/plymouth/plymouthd.conf ]] && grep -qi "omarchy" /etc/plymouth/plymouthd.conf
}

handle_archbang() {
    log_section "We are on ArchBang"
    echo "Making backups of important files to start openbox"

    if [[ -f "${HOME}/.bash_profile" && ! -f "${HOME}/.bash_profile_nemesis" ]]; then
        cp -vf "${HOME}/.bash_profile" "${HOME}/.bash_profile_nemesis"
    fi

    if [[ -f "${HOME}/.xinitrc" && ! -f "${HOME}/.xinitrc-nemesis" ]]; then
        cp -vf "${HOME}/.xinitrc" "${HOME}/.xinitrc-nemesis"
    fi

    mkdir -p "${HOME}/.bin"

    if [[ -f "/home/${USER}/AB_Scripts/startpanel" ]]; then
        cp "/home/${USER}/AB_Scripts/startpanel" "${HOME}/.bin/startpanel"
    else
        log_warn "File not found: /home/${USER}/AB_Scripts/startpanel"
    fi

    echo "Getting our mirrorlist in"
    copy_file "${SCRIPT_DIR}/mirrorlist" /etc/pacman.d/mirrorlist

    echo
    echo "Change from xz to zstd in mkinitcpio"
    echo

    sudo sed -i 's/COMPRESSION="xz"/COMPRESSION="zstd"/g' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
}

handle_archcraft() {
    if is_os_release_match "archcraft"; then
        log_section "We are on Archcraft"

        sudo rm -rf /etc/skel/.config/*
        sudo rm -f /etc/skel/.dmrc
        sudo rm -f /etc/skel/.face
        sudo rm -f /etc/skel/.gtkrc-2.0

        remove_matching_packages archcraft-skeleton
        remove_matching_packages archcraft-omz
        remove_matching_packages archcraft-openbox
        remove_matching_packages archcraft-bspwm
        remove_matching_packages archcraft-gtk-theme-arc
        remove_matching_packages archcraft-config-qt
        remove_matching_packages archcraft-neofetch
        remove_matching_packages archcraft-arandr
        remove_matching_packages simplescreenrecorder

        log_warn "Software removed for Archcraft"
    fi
}

handle_archman() {
    if is_os_release_match "Archman"; then
        log_section "We are on Archman"
        sudo systemctl disable firewalld || true
        remove_matching_packages firewalld
        remove_matching_packages imagewriter
        remove_matching_packages surfn-icons
        remove_matching_packages grml-zsh-config

        sudo rm -rf /etc/skel/.config/Thunar
        sudo rm -rf /etc/skel/.config/xfce4
        sudo rm -f /etc/skel/.config/mimeapps.list
        sudo rm -f /etc/skel/.face
        sudo rm -f /etc/skel/.xinitrc
        sudo rm -f /etc/X11/xorg.conf.d/99-killX.conf
        sudo rm -f /etc/modprobe.d/disable-evbug.conf
        sudo rm -f /etc/modprobe.d/nobeep.conf

        log_warn "Software removed for Archman"
    fi
}

handle_artix() {
    if is_os_release_match "artix"; then
        log_section "We are on Artix"
        remove_matching_packages artix-qt-presets
        remove_matching_packages artix-gtk-presets
        remove_matching_packages artix-desktop-presets
        log_warn "Software removed for Artix"
    fi
}

handle_berserk() {
    if is_os_release_match "Berserk"; then
        log_section "We are on Berserk"
    fi
}

handle_biglinux() {
    if is_os_release_match "BigLinux"; then
        log_section "We are on BigLinux"
        remove_matching_packages big-skel
        log_warn "Software removed for BigLinux"
    fi
}

handle_blendos() {
    if is_os_release_match "BlendOS"; then
        log_section "We are on BlendOS"
    fi
}

handle_cachyos() {
    if is_os_release_match "CachyOS|cachyos"; then
        log_section "We are on CachyOS"

        remove_matching_packages cachyos-kernel-manager
        remove_matching_packages cachyos-kde-settings
        remove_matching_packages cachyos-fish-config
        remove_matching_packages btrfs-progs
        remove_matching_packages cachy-browser
        remove_matching_packages fastfetch
        remove_matching_packages cachyos-alacritty-config
        remove_matching_packages cachyos-hello
        remove_matching_packages cachyos-micro-settings
        remove_matching_packages cachyos-packageinstaller
        remove_matching_packages cachyos-rate-mirrors
        remove_matching_packages cachyos-wallpapers
        remove_matching_packages cachyos-zsh-config
        remove_matching_packages octopi
        remove_matching_packages paru
        remove_matching_packages ufw
        remove_matching_packages cachyos-emerald-kde-theme-git
        remove_matching_packages cachyos-iridescent-kde
        remove_matching_packages cachyos-nord-kde-theme-git
        remove_matching_packages cachyos-themes-sddm
        remove_matching_packages noto-color-emoji-fontconfig
        remove_matching_packages noto-fonts-cjk
        remove_matching_packages ttf-meslo-nerd

        log_warn "Software removed for CachyOS"
    fi
}

handle_endeavouros() {
    if is_os_release_match "EndeavourOS"; then
        log_section "We are on EndeavourOS"

        sudo systemctl disable firewalld || true
        remove_matching_packages firewall-applet
        remove_matching_packages firewall-config
        remove_matching_packages firewalld
        remove_matching_packages arc-gtk-theme-eos
        remove_matching_packages eos-settings-xfce4
        remove_matching_packages yay

        sudo rm -f /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml

        log_warn "Software removed for EndeavourOS"
    fi
}

handle_ezarch() {
    if is_os_release_match "ezarch"; then
        log_section "We are on Ezarch"
        sudo systemctl disable firewalld || true
        remove_matching_packages firewalld
        remove_matching_packages abiword
        log_warn "Software removed for Ezarch"
    fi
}

handle_garuda() {
    if is_os_release_match "Garuda"; then
        log_section "We are on Garuda"
        # unchanged body
    fi
}

handle_liya() {
    if is_os_release_match "Liya"; then
        log_section "We are on Liya"
        # unchanged body
    fi
}

handle_linuxhub() {
    if is_os_release_match "LinuxHub"; then
        log_section "We are on LinuxHub"
        remove_matching_packages_deps waybar
        remove_matching_packages_deps gpsd
        remove_matching_packages_deps pika-backup
        log_warn "Software removed for LinuxHub"
    fi
}

handle_manjaro() {
    if is_os_release_match "Manjaro"; then
        log_section "We are on Manjaro"
        remove_matching_packages manjaro-xfce-settings
        log_warn "Software removed for Manjaro"
    fi
}

handle_omarch() {
    if is_omarchy; then
        log_section "We are on Omarchy"
    fi
}

handle_prism() {
    if is_os_release_match "Prism"; then
        log_section "We are on Prism"
    fi
}

handle_rebornos() {
    if is_os_release_match "rebornos"; then
        log_section "We are on RebornOS"
        configure_repos "RebornOS" "true"
        sudo pacman -Rdd --noconfirm v4l-utils || true
        log_warn "Software removed for RebornOS"
    fi
}

run_all_distro_handlers() {
    handle_archbang
    handle_archcraft
    handle_archman
    handle_artix
    handle_berserk
    handle_biglinux
    handle_blendos
    handle_cachyos
    handle_endeavouros
    handle_ezarch
    handle_garuda
    handle_liya
    handle_linuxhub
    handle_manjaro
    handle_omarch
    handle_prism
    handle_rebornos
}