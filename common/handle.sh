#!/usr/bin/env bash


# Only load once
[[ -n "${HANDLE_SH_LOADED:-}" ]] && return 0
readonly HANDLE_SH_LOADED=1

is_os_release_match() {
    local pattern="$1"
    local os_release="/etc/os-release"

    [[ -z "$pattern" ]] && return 1
    [[ -r "$os_release" ]] || return 1

    grep -qiE -- "$pattern" "$os_release"
}

is_omarchy() {
    [[ -f /etc/plymouth/plymouthd.conf ]] && grep -qi "omarchy" /etc/plymouth/plymouthd.conf
}

handle_aerynos() {
    if is_os_release_match "Aerynos"; then
        log_section "We are on Aerynos"
    fi
}

handle_archbang() {
    #2026-03-14
    #after installation pacman-key --init and pacman-key --populate archlinux
    if is_os_release_match "archbang"; then

        log_section "We are on ArchBang"
        echo "Making backups of important files to start openbox"

        backup_file_once "${HOME}/.bash_profile" "${HOME}/.bash_profile_nemesis"

        backup_file_once "${HOME}/.bashrc"  "${HOME}/.bashrc_nemesis"
        
        mkdir -p "${HOME}/.bin"

        log_warn "Change from xz to zstd in mkinitcpio"
        sudo sed -i \
            -e 's/^#COMPRESSION="zstd"/COMPRESSION="zstd"/' \
            -e 's/^COMPRESSION="xz"/COMPRESSION="zstd"/' \
            /etc/mkinitcpio.conf

        sudo mkinitcpio -P

        install_sddm_git
        remove_gpsd
    fi
}

handle_archcraft() {
    if is_os_release_match "archcraft"; then
        log_section "We are on Archcraft"

        remove_folder_if_exists /etc/skel/.config
        remove_file_if_exists /etc/skel/.dmrc
        remove_file_if_exists /etc/skel/.face
        remove_file_if_exists /etc/skel/.gtkrc-2.0

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

handle_archlinux() {
    if is_os_release_match "Arch|arch|Arch Linux|archlinux"; then
        log_section "We are on Arch Linux"
    fi
}

handle_arcris() {
    if is_os_release_match "Arcris"; then
        log_section "We are on Arcris"
    fi
}

handle_archman() {
    if is_os_release_match "Archman"; then
        log_section "We are on Archman"
        disable_service firewalld
        remove_matching_packages firewalld
        remove_matching_packages imagewriter
        remove_matching_packages surfn-icons
        remove_matching_packages grml-zsh-config

        remove_folder_if_exists /etc/skel/.config/Thunar
        remove_folder_if_exists /etc/skel/.config/xfce4
        remove_file_if_exists /etc/skel/.config/mimeapps.list
        remove_file_if_exists /etc/skel/.face
        remove_file_if_exists /etc/skel/.xinitrc
        remove_file_if_exists /etc/X11/xorg.conf.d/99-killX.conf
        remove_file_if_exists /etc/modprobe.d/disable-evbug.conf
        remove_file_if_exists /etc/modprobe.d/nobeep.conf

        log_warn "Software removed for Archman"
    fi
}

handle_artix() {
    if is_os_release_match "artix"; then
        log_section "We are on Artix"
        remove_matching_packages artix-qt-presets artix-gtk-presets artix-desktop-presets
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

handle_bluestarlinux() {
    if is_os_release_match "Bluestar|BluestarLinux"; then
        log_section "We are on BluestarLinux"
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

handle_calamares_arch_installer() {
    if is_os_release_match "Calamares-arch-installer|calamares-arch-installer"; then
        log_section "We are on Calamares Arch Installer"
    fi
}

handle_endeavouros() {
    if is_os_release_match "EndeavourOS"; then
        log_section "We are on EndeavourOS"

        disable_firewalld_stack
        remove_matching_packages arc-gtk-theme-eos eos-settings-xfce4 yay

        remove_file_if_exists /etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml

        log_warn "Software removed for EndeavourOS"
    fi
}

handle_ezarch() {
    if is_os_release_match "ezarch"; then
        log_section "We are on Ezarch"
        disable_firewalld_stack
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

handle_kaos() {
    if is_os_release_match "KaOS|Kaos"; then
        log_section "We are on KaOS"
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

handle_mabox() {
    if is_os_release_match "Mabox"; then
        log_section "We are on Mabox"
    fi
}

handle_manjaro() {
    if is_os_release_match "Manjaro"; then
        log_section "We are on Manjaro"
        remove_matching_packages manjaro-xfce-settings
        log_warn "Software removed for Manjaro"
    fi
}

handle_nyarch() {
    if is_os_release_match "Nyarch"; then
        log_section "We are on Nyarch"
    fi
}

handle_omarchy() {
    if is_omarchy; then
        log_section "We are on Omarchy"

        HYPR_DIR="$USER_HOME/.config/hypr"

        move_file_user "$HYPR_DIR/bindings.conf" "$HYPR_DIR/bindings.conf_backup"
        copy_file_user "$SETTINGS_DIR/hypr-omarchy/bindings.conf" "$HYPR_DIR/bindings.conf"
        copy_file_user "$SETTINGS_DIR/hypr-omarchy/input.conf" "$HYPR_DIR/input.conf"
        copy_file_user "$SETTINGS_DIR/hypr-omarchy/gsettings.sh" "$HYPR_DIR/gsettings.sh"
        bash "$HYPR_DIR/gsettings.sh"
    fi

    set_sddm_session_hyprland() {

        local file="/etc/sddm.conf.d/kde_settings.conf"

        log_subsection "Setting SDDM session to Hyprland"

        if [[ ! -f "$file" ]]; then
            log_warn "File not found: $file"
            return 0
        fi

        if grep -q '^Session=' "$file"; then
            sudo sed -i 's/^Session=.*/Session=hyprland-uwsm/' "$file"
        else
            echo "Session=hyprland-uwsm" | sudo tee -a "$file" >/dev/null
        fi
    }

    set_sddm_session_hyprland
}

handle_prismlinux() {
    if is_os_release_match "Prism"; then
        log_section "We are on Prism"
    fi
}

handle_rebornos() {
    if is_os_release_match "rebornos"; then
        log_section "We are on RebornOS"
        sudo pacman -Rdd --noconfirm v4l-utils || true
        log_warn "Software removed for RebornOS"
    fi
}

handle_rengeos() {
    if is_os_release_match "RengeOS|rengeos"; then
        log_section "We are on RengeOS"
    fi
}

handle_shanios() {
    if is_os_release_match "Shanios"; then
        log_section "We are on Shanios"
    fi
}

handle_stormos() {
    if is_os_release_match "StormOS|stormos"; then
        log_section "We are on StormOS"
    fi
}

run_all_distro_handlers() {
    log_section "Running distro-specific handlers from common/handle.sh"
    handle_aerynos
    handle_archbang
    handle_archcraft
    handle_archlinux
    handle_archman
    handle_arcris
    handle_artix
    handle_berserk
    handle_biglinux
    handle_blendos
    handle_bluestarlinux
    handle_cachyos
    handle_calamares_arch_installer
    handle_endeavouros
    handle_ezarch
    handle_garuda
    handle_kaos
    handle_liya
    handle_linuxhub
    handle_mabox
    handle_manjaro
    handle_nyarch
    handle_omarchy
    handle_prismlinux
    handle_rebornos
    handle_rengeos
    handle_shanios
    handle_stormos
}