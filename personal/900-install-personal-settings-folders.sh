#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. && pwd)/common/common.sh"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
echo $SCRIPT_DIR
SETTINGS_DIR="${SCRIPT_DIR}/settings"
echo $SETTINGS_DIR

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

    if [[ ! -d /etc/skel/.config ]]; then
        sudo mkdir -p /etc/skel/.config
    fi

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
    cp -v "${SETTINGS_DIR}/brave/brave-browser.desktop" \
      "${HOME}/.local/share/applications/" || \
      log_warn "Failed to copy Brave desktop file"

    log_subsection "Sublime Text settings"
    cp -v "${SETTINGS_DIR}/sublimetext/Preferences.sublime-settings" \
          "${HOME}/.config/sublime-text/Packages/User/" || \
          log_warn "Failed to copy Sublime Text settings"

    log_subsection "Flameshot settings"
    cp -v "${SETTINGS_DIR}/flameshot/flameshot.ini" \
          "${HOME}/.config/flameshot/" || \
          log_warn "Failed to copy Flameshot settings"
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

set_default_cursor_theme() {
    local file="/usr/share/icons/default/index.theme"
    local theme="Bibata-Modern-Ice"

    if [[ -f "$file" ]]; then
        sudo sed -i "s/^Inherits=.*/Inherits=$theme/" "$file"
        echo "Cursor theme set to $theme in $file"
    else
        echo "File not found: $file"
    fi
}
create_personal_directories
install_personal_settings
configure_desktop_preferences
change_shell_to_fish
set_default_cursor_theme

log_subsection "$(script_name) done"

##################################################################################################################################
# Debug verification section
##################################################################################################################################

if [[ "${debug}" == "true" ]]; then

    log_section "Debug verification - checking applied changes"

    log_subsection "Checking personal directories"

    local check_dirs=(
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

    for dir in "${check_dirs[@]}"; do
        [[ -d "$dir" ]] && echo "OK   - $dir" || echo "MISS - $dir"
    done


    log_subsection "Checking installed configuration files"

    check_files=(
        "${HOME}/.local/share/applications/brave-browser.desktop"
        "${HOME}/.config/sublime-text/Packages/User/Preferences.sublime-settings"
        "${HOME}/.config/flameshot/flameshot.ini"
    )

    for file in "${check_files[@]}"; do
        [[ -f "$file" ]] && echo "OK   - $file" || echo "MISS - $file"
    done


    log_subsection "Checking shell"

    current_shell="$(getent passwd "$USER" | cut -d: -f7)"
    echo "Current shell: $current_shell"


    log_subsection "Checking cursor theme"

    theme_file="/usr/share/icons/default/index.theme"
    if [[ -f "$theme_file" ]]; then
        grep "^Inherits=" "$theme_file"
    else
        echo "MISS - $theme_file"
    fi

fi