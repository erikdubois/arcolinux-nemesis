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
        #remove_matching_packages cachyos-rate-mirrors
        remove_matching_packages cachyos-wallpapers
        remove_matching_packages cachyos-zsh-config
        remove_matching_packages octopi
        remove_matching_packages paru
        remove_matching_packages ufw-extras
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

handle_ml4w() {
    if is_os_release_match "ML4W"; then
        log_section "We are on ML4Wos"
        move_folder_if_exists /etc/skel/.config/btop /etc/skel/.config/btop-nemesis
        move_folder_if_exists /etc/skel/.config/fastfetch /etc/skel/.config/fastfetch-nemesis
        move_folder_if_exists /etc/skel/.config/gtk-3.0 /etc/skel/.config/gtk-3.0-nemesis
        move_folder_if_exists /etc/skel/.config/gtk-4.0 /etc/skel/.config/gtk-4.0-nemesis
        move_folder_if_exists /etc/skel/.config/rofi /etc/skel/.config/rofi-nemesis
        move_folder_if_exists /etc/skel/.config/fish /etc/skel/.config/fish-nemesis
        move_file /etc/skel/.zshrc /etc/skel/.zshrc-nemesis
    fi
}

handle_nyarch() {
    if is_os_release_match "Nyarch"; then
        log_section "We are on Nyarch"
    fi
}

handle_omarchy() {
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

    if is_omarchy; then
        log_section "We are on Omarchy"

        local HYPR_DIR="$USER_HOME/.config/hypr"
        local OMARCHY_DIR="$USER_HOME/.config/omarchy"
        local LOCAL_OMARCHY_DIR="$USER_HOME/.local/share/omarchy"

        create_gtk3_dir
        create_hypr_dir

        backup_folder_as_user "$HYPR_DIR" "${HYPR_DIR}_nemesis"
        backup_folder_as_user "$OMARCHY_DIR" "${OMARCHY_DIR}_nemesis"
        backup_folder_as_user "$LOCAL_OMARCHY_DIR" "${LOCAL_OMARCHY_DIR}_nemesis"

        copy_file_user "$SETTINGS_DIR/hypr-omarchy/bindings-nemesis.conf" "$HYPR_DIR/bindings-nemesis.conf"
        copy_file_user "$SETTINGS_DIR/hypr-omarchy/input-nemesis.conf" "$HYPR_DIR/input-nemesis.conf"
        copy_file_user "$SETTINGS_DIR/hypr-omarchy/gsettings.sh" "$HYPR_DIR/gsettings.sh"

        #add lines if not exist
        CONFIG_FILE="$USER_HOME/.config/hypr/hyprland.conf"

        LINE1='source = ~/.config/hypr/bindings-nemesis.conf'
        LINE2='source = ~/.config/hypr/input-nemesis.conf'

        # Ensure file exists
        if [[ ! -f "$CONFIG_FILE" ]]; then
            echo "Error: $CONFIG_FILE not found!"
            exit 1
        fi

        # Append lines if they are not already present
        grep -qxF "$LINE1" "$CONFIG_FILE" || echo "$LINE1" >> "$CONFIG_FILE"
        grep -qxF "$LINE2" "$CONFIG_FILE" || echo "$LINE2" >> "$CONFIG_FILE"

        echo "Done. Lines added if they were missing."

        bash "$HYPR_DIR/gsettings.sh"
        #set_sddm_session_hyprland

        # removing double keybindings
        CONFIG_FILE="$USER_HOME/.config/hypr/bindings.conf"

        PATTERNS=(
            "Terminal"
            "omarchy-launch-browser"
            "Docker"
            "x.com"
        )

        log_info "Using file: $CONFIG_FILE"

        if [[ ! -f "$CONFIG_FILE" ]]; then
            log_warn "Cannot find $CONFIG_FILE"
            return 1
        fi

        for pattern in "${PATTERNS[@]}"; do
            log_info "Processing pattern: $pattern"

            sed -i "/$pattern/ {/^[[:space:]]*#/! s/^/#/}" "$CONFIG_FILE"
        done

        #add gsettings to autostart
        log_info "Adding line(s) to autostart"
        AUTOSTART_FILE="$USER_HOME/.config/hypr/autostart.conf"
        LINE1='exec = ~/.config/hypr/gsettings.sh'

        # Ensure file exists
        if [[ ! -f "$AUTOSTART_FILE" ]]; then
            echo "Error: $AUTOSTART_FILE not found!"
            return 1
        fi

        # Append lines if they are not already present
        grep -qxF "$LINE1" "$AUTOSTART_FILE" || echo "$LINE1" >> "$AUTOSTART_FILE"

        echo "Done. Lines added if they were missing."

        # add rmc to set wallpaper in thunar
        log_info "Updating wallpaper command in uca.xml for Thunar"

        UCA_FILE="$HOME/.config/Thunar/uca.xml"
        ETC_UCA_FILE="/etc/skel/.config/Thunar/uca.xml"

        OLD_TEXT='feh --bg-fill %f'
        NEW_TEXT='swaybg -i %f'

        replace_wallpaper_cmd() {
            local file="$1"
            local use_sudo="${2:-false}"

            if [[ ! -f "$file" ]]; then
                log_warn "Skipping: file not found: $file"
                return 0
            fi

            if ! grep -qF "$OLD_TEXT" "$file"; then
                log_info "No replacement needed in: $file"
                return 0
            fi

            if [[ "$use_sudo" == "true" ]]; then
                if sudo sed -i "s|$OLD_TEXT|$NEW_TEXT|g" "$file"; then
                    log_info "Updated wallpaper command in: $file"
                else
                    log_warn "Failed to update: $file"
                fi
            else
                if sed -i "s|$OLD_TEXT|$NEW_TEXT|g" "$file"; then
                    log_info "Updated wallpaper command in: $file"
                else
                    log_warn "Failed to update: $file"
                fi
            fi
}

replace_wallpaper_cmd "$UCA_FILE"
replace_wallpaper_cmd "$ETC_UCA_FILE" true
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
    handle_ml4w
    handle_nyarch
    handle_omarchy
    handle_prismlinux
    handle_rebornos
    handle_rengeos
    handle_shanios
    handle_stormos
}