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

create_personal_directories() {
    log_section "Personal directories to create"

    sudo mkdir -p /etc/skel/.config

    local dirs=(
        "${HOME}/.bin"
        "${HOME}/.fonts"
        "${HOME}/.icons"
        "${HOME}/.themes"
        "${HOME}/.local/share/icons"
        "${HOME}/.local/share/themes"
        "${HOME}/.local/share/applications"
        "${HOME}/.config"
        "${HOME}/.config/xfce4"
        "${HOME}/.config/autostart"
        "${HOME}/.config/xfce4/xfconf"
        "${HOME}/.config/gtk-3.0"
        "${HOME}/.config/gtk-4.0"
        "${HOME}/.config/variety"
        "${HOME}/.config/fish"
        "${HOME}/.config/obs-studio"
        "${HOME}/.config/neofetch"
        "${HOME}/.config/flameshot"
        "${HOME}/DATA"
        "${HOME}/Insync"
        "${HOME}/Projects"
        "${HOME}/SHARED"
        "${HOME}/.config/sublime-text/Packages/User"
    )

    local dir
    for dir in "${dirs[@]}"; do
        mkdir -p "${dir}"
    done
}

install_personal_settings() {
    log_section "Personal settings to install - any OS"

    log_subsection "Brave no gnome-keyring popup"
    cp -v \
        "${PROJECT_DIR}/personal/settings/brave/brave-browser.desktop" \
        "${HOME}/.local/share/applications/brave-browser.desktop"

    log_subsection "Sublime Text settings"
    cp -v \
        "${PROJECT_DIR}/personal/settings/sublimetext/Preferences.sublime-settings" \
        "${HOME}/.config/sublime-text/Packages/User/Preferences.sublime-settings"

    log_subsection "Flameshot settings"
    cp -v \
        "${PROJECT_DIR}/personal/settings/flameshot/flameshot.ini" \
        "${HOME}/.config/flameshot/flameshot.ini"
}

configure_desktop_preferences() {
    log_subsection "Blueberry symbolic icon setting"

    if command -v gsettings >/dev/null 2>&1; then
        gsettings set org.blueberry use-symbolic-icons false
    else
        log_warn "gsettings not found - skipping Blueberry symbolic icon setting"
    fi
}

change_shell_to_fish() {
    log_subsection "Changing shell to fish"

    if command -v fish >/dev/null 2>&1; then
        sudo chsh "${USER}" -s /bin/fish
    else
        log_warn "fish is not installed - skipping shell change"
    fi
}

create_personal_directories
install_personal_settings
configure_desktop_preferences
change_shell_to_fish

log_subsection "$(script_name) done"