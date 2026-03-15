#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. && pwd)/common/common.sh"

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

readonly PERSONAL_SETTINGS_DIR="${PROJECT_DIR}/personal/settings"

get_virtualization_type() {
    systemd-detect-virt 2>/dev/null || echo none
}

copy_skel_to_home() {
    cp -arf /etc/skel/. "${HOME}/"
}

append_line_if_missing() {
    local line="$1"
    local file="$2"

    [[ -f "${file}" ]] || return 0

    if ! grep -Fqx "${line}" "${file}"; then
        echo "${line}" >> "${file}"
    fi
}

append_line_if_missing_sudo() {
    local line="$1"
    local file="$2"

    [[ -f "${file}" ]] || return 0

    if ! sudo grep -Fqx "${line}" "${file}"; then
        echo "${line}" | sudo tee -a "${file}" >/dev/null
    fi
}

set_env_defaults() {
    if [[ -f /etc/environment ]]; then
        sudo tee /etc/environment >/dev/null <<'EOF'
QT_QPA_PLATFORMTHEME=qt5ct
QT_STYLE_OVERRIDE=kvantum
EDITOR=nano
BROWSER=firefox
EOF
    fi
}

set_loader_timeout_to_one() {
    if [[ -f /boot/loader/loader.conf ]]; then
        sudo sed -i 's/^timeout 5$/timeout 1/g' /boot/loader/loader.conf
    fi
}

apply_xfce_theme_changes() {
    local whisker_source="$1"

    [[ -f /usr/share/xsessions/xfce.desktop ]] || return 0

    log_subsection "Applying XFCE changes"

    copy_skel_to_home

    mkdir -p "${HOME}/.config/xfce4/panel"
    sudo mkdir -p /etc/skel/.config/xfce4/panel

    if [[ -f "${whisker_source}" ]]; then
        cp "${whisker_source}" "${HOME}/.config/xfce4/panel/whiskermenu-7.rc"
        sudo cp "${whisker_source}" /etc/skel/.config/xfce4/panel/whiskermenu-7.rc
    fi

    local home_xsettings="${HOME}/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
    local skel_xsettings="/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"

    if [[ -f "${home_xsettings}" ]]; then
        sed -i 's/Arc-Dark/Arc-Dawn-Dark/g' "${home_xsettings}"
        sed -i 's/Sardi-Arc/neo-candy-icons/g' "${home_xsettings}"
    fi

    if [[ -f "${skel_xsettings}" ]]; then
        sudo sed -i 's/Arc-Dark/Arc-Dawn-Dark/g' "${skel_xsettings}"
        sudo sed -i 's/Sardi-Arc/neo-candy-icons/g' "${skel_xsettings}"
    fi
}

install_edu_packages() {
    install_packages edu-skel-git edu-xfce-git edu-system-git
}

handle_common_arch() {
    log_section "For any Arch Linux system"

    if [[ -f /etc/vconsole.conf ]] && ! grep -q '^FONT=' /etc/vconsole.conf; then
        echo 'FONT=lat4-19' | sudo tee -a /etc/vconsole.conf >/dev/null
    fi

    if [[ ! -f /etc/nanorc-nemesis && -f /etc/nanorc ]]; then
        sudo mv -v /etc/nanorc /etc/nanorc-nemesis
        copy_file "${PERSONAL_SETTINGS_DIR}/nano/nanorc" /etc/nanorc
    fi

    if [[ ! -f /etc/nsswitch.conf-nemesis && -f /etc/nsswitch.conf ]]; then
        sudo mv -v /etc/nsswitch.conf /etc/nsswitch.conf-nemesis
        copy_file "${PERSONAL_SETTINGS_DIR}/nsswitch/nsswitch.conf" /etc/nsswitch.conf
    fi

    if [[ ! -f /etc/environment-nemesis && -f /etc/environment ]]; then
        sudo mv -v /etc/environment /etc/environment-nemesis
        copy_file "${PERSONAL_SETTINGS_DIR}/environment/environment" /etc/environment
    fi

    if [[ -f /usr/share/icons/default/index.theme ]]; then
        copy_file "${PERSONAL_SETTINGS_DIR}/cursor/index.theme" /usr/share/icons/default/index.theme
    fi

    enable_service fstrim.timer

    if [[ ! -f /etc/pacman.d/gnupg/gpg.conf-nemesis && -f /etc/pacman.d/gnupg/gpg.conf ]]; then
        sudo mv -v /etc/pacman.d/gnupg/gpg.conf /etc/pacman.d/gnupg/gpg.conf-nemesis
        copy_file "${PERSONAL_SETTINGS_DIR}/gnupg/gpg.conf" /etc/pacman.d/gnupg/gpg.conf
    fi
}

handle_arch() {
    [[ ! -f /etc/dev-rel ]] || return 0
    grep -q "Arch Linux" /etc/os-release || return 0

    log_section "We are on Arch Linux"
    sudo cp -arf /etc/skel/. /root
}

handle_archbang() {
    grep -q "ArchBang" /etc/os-release || return 0

    log_section "We are on ArchBang"

    install_packages sddm edu-sddm-simplicity-git
    sudo systemctl enable -f sddm
    [[ -x /usr/local/bin/fix-sddm-conf ]] && /usr/local/bin/fix-sddm-conf

    local file="/etc/vconsole.conf"

    if [[ -f "${file}" ]]; then
        sudo cp "${file}" "${file}.nemesis"
    fi

    if [[ -f "${file}" ]] && grep -q '^KEYMAP=' "${file}"; then
        sudo sed -i 's|^KEYMAP=.*|KEYMAP=be-latin1|' "${file}"
    else
        echo 'KEYMAP=be-latin1' | sudo tee -a "${file}" >/dev/null
    fi

    if [[ -f /etc/X11/xorg.conf.d/01-keyboard-layout.conf ]]; then
        sudo tee /etc/X11/xorg.conf.d/01-keyboard-layout.conf >/dev/null <<'EOF'
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "be"
        Option "XkbVariant" ""
EndSection
EOF
    fi

    mkdir -p "${HOME}/.config/openbox"
    touch "${HOME}/.config/openbox/environment"
    append_line_if_missing "XDG_CURRENT_DESKTOP=openbox" "${HOME}/.config/openbox/environment"
    append_line_if_missing "XDG_SESSION_DESKTOP=openbox" "${HOME}/.config/openbox/environment"
    append_line_if_missing_sudo "XDG_CURRENT_DESKTOP=openbox" /etc/environment
    append_line_if_missing_sudo "XDG_SESSION_DESKTOP=openbox" /etc/environment

    if [[ -f /usr/share/xsessions/openbox.desktop && -f "${HOME}/.config/openbox/autostart" ]]; then
        append_line_if_missing "picom &" "${HOME}/.config/openbox/autostart"
    fi
}

handle_archcraft() {
    grep -q "archcraft" /etc/os-release || return 0
    log_section "We are on Archcraft"
    log_warn "Nothing to do"
}

handle_archman() {
    grep -q "Archman" /etc/os-release || return 0

    log_section "We are on Archman"

    sudo rm -f /etc/skel/.zshrc
    sudo rm -rf /etc/skel/.config/Thunar

    install_edu_packages

    sudo sed -i 's/^#ParallelDownloads = 5$/ParallelDownloads = 5/g' /etc/pacman.conf

    set_loader_timeout_to_one
    [[ -f /etc/nanorc ]] && copy_file "${PERSONAL_SETTINGS_DIR}/nano/nanorc" /etc/nanorc

    if [[ -f /usr/share/xsessions/xfce.desktop ]]; then
        copy_skel_to_home
        cp -arf /etc/skel/.config "${HOME}/"
    fi

    apply_xfce_theme_changes "${PERSONAL_SETTINGS_DIR}/archlinux/whiskermenu-7.rc"
}

handle_artix() {
    grep -q "artix" /etc/os-release || return 0

    log_section "We are on an Artix ISO"

    local result
    result="$(get_virtualization_type)"

    if [[ "${result}" == "none" ]]; then
        log_section "Installing VirtualBox"
        bash "${PROJECT_DIR}/install/install-virtualbox-for-linux.sh"
    else
        log_warn "You are on a virtual machine - skipping VirtualBox"
    fi
}

handle_berserk() {
    grep -q "Berserk" /etc/os-release || return 0
    log_section "We are on a Berserk ISO"
}

handle_biglinux() {
    grep -q "BigLinux" /etc/os-release || return 0

    log_section "We are on BigLinux"

    sudo rm -f /etc/skel/.config/variety/variety.conf

    log_subsection "Installing edu packages"
    install_edu_packages

    log_subsection "Checking if neofetch lolcat is in .bashrc"

    if [[ -f "${HOME}/.bashrc" ]] && ! grep -q "neofetch | lolcat" "${HOME}/.bashrc"; then
        sed -i '391s/neofetch/neofetch | lolcat/g' "${HOME}/.bashrc"
    fi

    if [[ -f /etc/skel/.bashrc ]] && ! grep -q "neofetch | lolcat" /etc/skel/.bashrc; then
        sudo sed -i '391s/neofetch/neofetch | lolcat/g' /etc/skel/.bashrc
    fi

    log_subsection "Setting journald storage to auto"

    if [[ -f /etc/systemd/journald.conf ]]; then
        sudo sed -i 's/^#Storage=auto$/Storage=auto/g' /etc/systemd/journald.conf
    fi
}

handle_blendos() {
    grep -q "blendos" /etc/os-release || return 0
    log_section "We are on a BlendOS ISO"
}

handle_eos() {
    grep -q "EndeavourOS" /etc/os-release || return 0

    log_section "We are on an EOS ISO"

    set_env_defaults

    if [[ -f /etc/nsswitch.conf ]]; then
        sudo cp /etc/nsswitch.conf /etc/nsswitch.conf.bak
        copy_file "${PERSONAL_SETTINGS_DIR}/nsswitch/nsswitch.conf" /etc/nsswitch.conf
    fi
}

handle_garuda() {
    grep -q "Garuda" /etc/os-release || return 0

    log_section "We are on a GARUDA ISO"

    if lsblk -f | grep -q ext4; then
        log_warn "Removing btrfs-related packages on EXT4"
        sudo pacman -Rns --noconfirm garuda-system-maintenance || true
        sudo pacman -Rns --noconfirm snapper-support snapper-tools || true
        sudo pacman -Rns --noconfirm btrfsmaintenance garuda-common-systems || true
        sudo pacman -Rns --noconfirm btrfs-assistant btrfs-progs grub-btrfs || true
    fi
}

handle_linuxhubprime() {
    grep -q "LinuxHub" /etc/os-release || return 0
    log_section "We are on a LinuxHub Prime ISO"
}

handle_liya() {
    grep -q "Liya" /etc/os-release || return 0
    log_section "We are on a Liya ISO"
}

handle_manjaro() {
    grep -q "Manjaro" /etc/os-release || return 0
    log_section "We are on a Manjaro ISO"
    log_warn "Nothing to do"
}

handle_nyarch() {
    grep -q "Nyarch" /etc/os-release || return 0
    log_section "We are on a Nyarch ISO"
}

handle_omarchy() {
    [[ -f /etc/plymouth/plymouthd.conf ]] || return 0
    grep -q "omarchy" /etc/plymouth/plymouthd.conf || return 0

    log_section "We are on an OMARCHY ISO"

    local folder="/tmp/omarchy"
    [[ -d "${folder}" ]] && sudo rm -rf "${folder}"

    git clone https://github.com/erikdubois/omarchy "${folder}"

    mkdir -p "${HOME}/.config/hypr"

    cp -v "${folder}/config/hypr/bindings.conf" "${HOME}/.config/hypr/bindings.conf"
    cp -v "${folder}/config/hypr/input.conf" "${HOME}/.config/hypr/input.conf"
    cp -v "${folder}/config/hypr/looknfeel.conf" "${HOME}/.config/hypr/looknfeel.conf"
    cp -v "${folder}/config/hypr/hyprland.conf" "${HOME}/.config/hypr/hyprland.conf"
}

handle_prismlinux() {
    grep -q "Prism" /etc/os-release || return 0
    log_section "We are on a PrismLinux ISO"
}

handle_rebornos() {
    grep -q "RebornOS" /etc/os-release || return 0

    log_section "We are on RebornOS"

    if [[ -f /etc/vconsole.conf ]] && ! grep -q "FONT=lat4-19" /etc/vconsole.conf; then
        echo 'FONT=lat4-19' | sudo tee -a /etc/vconsole.conf >/dev/null
    fi
}

handle_common_arch

handle_arch
handle_archbang
handle_archcraft
handle_archman
handle_artix
handle_berserk
handle_biglinux
handle_blendos
handle_eos
handle_garuda
handle_linuxhubprime
handle_liya
handle_manjaro
handle_nyarch
handle_omarchy
handle_prismlinux
handle_rebornos

log_subsection "$(script_name) done"