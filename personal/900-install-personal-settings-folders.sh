#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. && pwd)/common/common.sh"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
#echo $SCRIPT_DIR
SETTINGS_DIR="${SCRIPT_DIR}/settings"
#echo $SETTINGS_DIR

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
        "${HOME}/.local/share/bin"
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

# as User
install_personal_settings_as_user() {
    log_section "Personal settings to install - any OS - as user"

    log_subsection "Brave no gnome-keyring popup"
    copy_file_user "${SETTINGS_DIR}/brave/brave-browser.desktop" \
      "${HOME}/.local/share/applications/" || \
      log_warn "Failed to copy Brave desktop file"

    log_subsection "Sublime Text settings"
    copy_file_user "${SETTINGS_DIR}/sublimetext/Preferences.sublime-settings" \
          "${HOME}/.config/sublime-text/Packages/User/" || \
          log_warn "Failed to copy Sublime Text settings"

    log_subsection "flameshot settings"
    copy_file_user "${SETTINGS_DIR}/flameshot/flameshot.ini" \
          "${HOME}/.config/flameshot/" || \
          log_warn "Failed to copy Flameshot settings"
}

# as Root
install_personal_settings_as_root() {
    log_section "Personal settings to install - any OS - as root"

    log_subsection "nanorc settings"
    copy_file "${SETTINGS_DIR}/nano/nanorc" \
          "/etc/nanorc" || \
          log_warn "Failed to copy nanorc settings"

    log_subsection "nsswitch.conf settings"
    copy_file "${SETTINGS_DIR}/nsswitch/nsswitch.conf" \
          "/etc/nsswitch.conf" || \
          log_warn "Failed to copy nsswitch.conf settings"

    log_subsection "sysctl settings"
    for file in "${SETTINGS_DIR}/sysctl.d/"*; do
        copy_file "$file" "/etc/sysctl.d/" || \
            log_warn "Failed to copy $(basename "$file")"
    done

    log_subsection "systemd coredump settings"
    for file in "${SETTINGS_DIR}/systemd/coredump.conf.d/"*; do
        copy_file "$file" "/etc/systemd/coredump.conf.d/" || \
            log_warn "Failed to copy $(basename "$file")"
    done

    log_subsection "systemd nmb.service.d settings"
    sudo mkdir -p /etc/systemd/system/nmb.service.d
    for file in "${SETTINGS_DIR}/systemd/system/nmb.service.d/"*; do
        copy_file "$file" "/etc/systemd/system/nmb.service.d/" || \
            log_warn "Failed to copy $(basename "$file")"
    done
}

systemd_no_coredump() {
    log_subsection "Disabling systemd coredumps"

    local conf_dir="/etc/systemd/coredump.conf.d"
    local conf_file="${conf_dir}/10-kiro-coredump.conf"

    if [[ -f "$conf_file" ]] &&
       grep -q "Storage=none" "$conf_file" &&
       grep -q "Compress=yes" "$conf_file" &&
       grep -q "MaxUse=0" "$conf_file"; then
        log_info "Coredump config already present: $conf_file"
        return 0
    fi

    sudo mkdir -p "$conf_dir" || {
        log_warn "Failed to create directory: $conf_dir"
        return 1
    }

    sudo tee "$conf_file" >/dev/null <<'EOF'
# ============================================================================
# Kiro-ISO Coredump Configuration
# ============================================================================
# Disable core dumps for performance and storage savings
# Core dumps are rarely needed on desktop systems

[Coredump]

# Storage location for core dumps
# "none" = disabled (recommended for live systems)
Storage=none

# Compression method (if core dumps were enabled)
Compress=yes

# Maximum number of core dumps to keep
MaxUse=0
EOF

    if [[ $? -ne 0 ]]; then
        log_warn "Failed to write: $conf_file"
        return 1
    fi

    log_info "Coredump config written: $conf_file"
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
    log_subsection "Setting default cursor theme to Bibata-Modern-Ice"
    local file="/usr/share/icons/default/index.theme"
    local theme="Bibata-Modern-Ice"

    if [[ -f "$file" ]]; then
        sudo sed -i "s/^Inherits=.*/Inherits=$theme/" "$file"
        echo "Cursor theme set to $theme in $file"
    else
        echo "File not found: $file"
    fi
}

set_environment_defaults() {

    log_subsection "Setting environment defaults in /etc/environment"

    local ENV_FILE="/etc/environment"

    sudo sed -i '/^QT_QPA_PLATFORMTHEME=/d' "$ENV_FILE"
    sudo sed -i '/^QT_STYLE_OVERRIDE=/d' "$ENV_FILE"
    sudo sed -i '/^GTK_THEME=/d' "$ENV_FILE"
    sudo sed -i '/^EDITOR=/d' "$ENV_FILE"
    sudo sed -i '/^BROWSER=/d' "$ENV_FILE"

    sudo bash -c "cat >> $ENV_FILE" <<EOF
QT_QPA_PLATFORMTHEME=qt5ct
QT_STYLE_OVERRIDE=kvantum
GTK_THEME=Arc-Dawn-Dark
EDITOR=nano
BROWSER=firefox
EOF

    echo "Environment variables written to $ENV_FILE"
}

create_personal_directories
install_personal_settings_as_user
install_personal_settings_as_root
systemd_no_coredump
configure_desktop_preferences
change_shell_to_fish
set_default_cursor_theme
set_environment_defaults

log_subsection "$(script_name) done"