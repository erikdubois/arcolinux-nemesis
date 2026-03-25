#!/usr/bin/env bash

# Only load once
[[ -n "${COMMON_SH_LOADED:-}" ]] && return 0
readonly COMMON_SH_LOADED=1

set -Euo pipefail
shopt -s nullglob

#--------------------------------------------------------------------------------------------------
# Index
#--------------------------------------------------------------------------------------------------
# 1. Paths
# 2. Colors
# 3. Logging
# 4. Error handling
# 5. Generic helpers
# 6. Package helpers
# 7. Service helpers
# 8. File helpers
# 9. User and group helpers
# 10. Download and AUR helpers
# 11. Repo and pacman helpers
# 12. Project-specific helpers

##################################################################################################################################
# 1. Paths
##################################################################################################################################
TARGET_USER="${SUDO_USER:-$USER}"

##################################################################################################################################
# 2. Colors
##################################################################################################################################
if command -v tput >/dev/null 2>&1 && [[ -t 1 ]]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    PURPLE="$(tput setaf 5)"
    CYAN="$(tput setaf 6)"
    RESET="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    PURPLE=""
    CYAN=""
    RESET=""
fi

##################################################################################################################################
# 3. Logging
##################################################################################################################################
log_section() {
    echo
    echo "${GREEN}################################################################################${RESET}"
    echo "$1"
    echo "${GREEN}################################################################################${RESET}"
    echo
}

log_subsection() {
    echo
    echo "${CYAN}########################################################################${RESET}"
    echo "$1"
    echo "${CYAN}########################################################################${RESET}"
    echo
}

log_warn() {
    echo
    echo "${YELLOW}########################################################################${RESET}"
    echo "$1"
    echo "${YELLOW}########################################################################${RESET}"
    echo
}

log_error() {
    local lineno="$1"
    local cmd="$2"

    echo
    echo "${RED}⚠️ ERROR DETECTED${RESET}"
    echo "${YELLOW}✳️  Line: ${lineno}${RESET}"
    echo "${YELLOW}📌  Command: '${cmd}'${RESET}"
    echo "${YELLOW}⏳  Waiting 10 seconds before continuing...${RESET}"
    echo
}

log_info() {
    echo
    echo "${BLUE}########################################################################${RESET}"
    echo "$1"
    echo "${BLUE}########################################################################${RESET}"
    echo
}

log_success() {
    echo
    echo "${GREEN}########################################################################${RESET}"
    echo "$1"
    echo "${GREEN}########################################################################${RESET}"
    echo
}

##################################################################################################################################
# 4. Error handling
##################################################################################################################################
on_error() {
    local lineno="$1"
    local cmd="$2"
    log_error "${lineno}" "${cmd}"
    sleep 10
}

trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

##################################################################################################################################
# 5. Generic helpers
##################################################################################################################################
script_name() {
    basename "${BASH_SOURCE[1]}"
}

require_root_tools() {
    local cmd
    for cmd in "$@"; do
        if ! command -v "${cmd}" >/dev/null 2>&1; then
            log_warn "Required command not found: ${cmd}"
            return 1
        fi
    done
}

pause_if_debug() {
    if [[ "${DEBUG:-false}" == true ]]; then
        echo
        echo "------------------------------------------------------------"
        echo "Waiting for user input to continue. Debug mode is on."
        echo "------------------------------------------------------------"
        echo
        read -r -n 1 -s -p "Debug mode is on. Press any key to continue..."
        echo
    fi
}

replace_text_in_file() {
    local file="$1"
    local old_text="$2"
    local new_text="$3"
    local use_sudo="${4:-false}"

    if [[ ! -f "$file" ]]; then
        log_warn "Skipping: file not found: $file"
        return 0
    fi

    if ! grep -qF "$old_text" "$file"; then
        log_info "No replacement needed in: $file"
        return 0
    fi

    if [[ "$use_sudo" == "true" ]]; then
        sudo sed -i "s|$old_text|$new_text|g" "$file" \
            && log_info "Updated: $file" \
            || log_warn "Failed to update: $file"
    else
        sed -i "s|$old_text|$new_text|g" "$file" \
            && log_info "Updated: $file" \
            || log_warn "Failed to update: $file"
    fi
}

comment_out_patterns_in_file() {
    local file="$1"
    shift
    local patterns=("$@")

    if [[ ! -f "$file" ]]; then
        log_warn "Skipping: file not found: $file"
        return 0
    fi

    local pattern
    for pattern in "${patterns[@]}"; do
        log_info "Processing pattern: $pattern"
        sed -i "/$pattern/ {/^[[:space:]]*#/! s/^/#/}" "$file"
    done
}

##################################################################################################################################
# 6. Package helpers
##################################################################################################################################
pkg_installed() {
    pacman -Q "$1" &>/dev/null
}

install_packages() {
    local pkgs=("$@")
    (( ${#pkgs[@]} == 0 )) && return 0

    log_subsection "Installing packages"
    sudo pacman -S --noconfirm --needed "${pkgs[@]}"
}

remove_packages() {
    local pkgs=()
    local pkg

    for pkg in "$@"; do
        if pkg_installed "${pkg}"; then
            pkgs+=("${pkg}")
        fi
    done

    if (( ${#pkgs[@]} > 0 )); then
        log_subsection "Removing packages"
        sudo pacman -R --noconfirm "${pkgs[@]}"
    else
        log_subsection "No packages to remove"
    fi
}

remove_matching_packages() {
    local pkg
    local output

    for pkg in "$@"; do
        [[ -n "$pkg" ]] || continue

        if pacman -Q -- "$pkg" &>/dev/null; then
            log_subsection "Removing package: $pkg"

            if output=$(sudo pacman -Rs --noconfirm -- "$pkg" 2>&1); then
                log_info "Removed package: $pkg"
            else
                log_warn "Could not remove package: $pkg"
                log_info "$output"
            fi
        else
            log_info "Package '$pkg' is not installed"
        fi
    done
}

remove_matching_packages_deps() {
    local pkg

    for pkg in "$@"; do
        if pacman -Qq | grep -Fxq -- "${pkg}"; then
            log_subsection "Removing package with dependencies: ${pkg}"
            sudo pacman -Rns --noconfirm "${pkg}"
        else
            log_info "No package named '${pkg}' is installed"
        fi
    done
}

remove_matching_packages_deps_dd() {
    local pkg

    for pkg in "$@"; do
        if pacman -Qq | grep -Fxq -- "${pkg}"; then
            log_subsection "Force removing package: ${pkg}"
            sudo pacman -Rdd --noconfirm "${pkg}"
        else
            log_info "No package named '${pkg}' is installed"
        fi
    done
}

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

reinstall_simplescreenrecorder_git() {
    log_section "Ensuring simplescreenrecorder-git is installed"

    for pkg in simplescreenrecorder; do
        if pacman -Qq "${pkg}" 2>/dev/null | grep -qx "${pkg}"; then
            sudo pacman -Rns --noconfirm "${pkg}" &>/dev/null
        fi
    done

    install_packages simplescreenrecorder-git
}

is_plasma_installed() {
    [[ -f /usr/share/wayland-sessions/plasma.desktop || -f /usr/share/xsessions/plasma.desktop ]]
}

is_plasma_x11_installed() {
    [[ -f /usr/share/xsessions/plasmax11.desktop ]]
}

##################################################################################################################################
# Install local packages from directory
##################################################################################################################################
install_local_packages_from_dir() {
    local dir="$1"
    local -a pkgs=()

    if [[ -z "${dir}" ]]; then
        log_warn "No package directory provided"
        return 1
    fi

    if [[ ! -d "${dir}" ]]; then
        log_warn "Directory not found: ${dir}"
        return 1
    fi

    if ! command -v pacman >/dev/null 2>&1; then
        log_warn "pacman not found"
        return 1
    fi

    pkgs=( "${dir}"/*.pkg.tar.* )

    if (( ${#pkgs[@]} == 0 )); then
        log_warn "No local packages found in ${dir}"
        return 1
    fi

    log_subsection "Installing local packages from ${dir}"
    sudo pacman -U --noconfirm "${pkgs[@]}"
}

##################################################################################################################################
# Install local packages from default project packages directory
##################################################################################################################################
install_local_packages() {
    local dir="${PACKAGES_DIR}"
    install_local_packages_from_dir "${dir}"
}

##################################################################################################################################
# 7. Service helpers
##################################################################################################################################
enable_service() {
    local service="$1"
    log_subsection "Enabling service: ${service}"
    sudo systemctl enable "${service}"
}

enable_now_service() {
    local service="$1"
    log_subsection "Enabling and starting service: ${service}"
    sudo systemctl enable --now "${service}"
}

disable_service() {
    local service="$1"

    if systemctl list-unit-files | grep -q "^${service}\.service"; then
        if systemctl is-enabled --quiet "${service}" || systemctl is-active --quiet "${service}"; then
            log_subsection "Disabling service: ${service}"
            sudo systemctl disable --now "${service}"
        else
            log_info "Service ${service} already disabled"
        fi
    else
        log_warn "Service ${service} not installed"
    fi
}

start_service() {
    local service="$1"
    log_subsection "Starting service: ${service}"
    sudo systemctl start "${service}"
}

restart_service() {
    local service="$1"

    if systemctl list-unit-files | grep -q "^${service}\.service"; then
        log_subsection "Restarting service: ${service}"
        sudo systemctl restart "${service}"
    else
        log_warn "Service ${service} not found"
    fi
}

##################################################################################################################################
# 8. File helpers
##################################################################################################################################
backup_folder_as_root() {
    local src="$1"
    local dst="$2"

    # If destination already exists, skip
    if [[ -d "${dst}" ]]; then
        log_info "Backup already exists: ${dst}"
        return 0
    fi

    # If source does not exist, warn but do not fail
    if [[ ! -d "${src}" ]]; then
        log_warn "Source folder does not exist: ${src}"
        return 0
    fi

    log_subsection "Creating folder backup: ${src} -> ${dst}"
    sudo cp -a -- "${src}" "${dst}"
}

backup_folder_as_user() {
    local src="$1"
    local dst="$2"

    # If destination already exists, skip
    if [[ -d "${dst}" ]]; then
        log_info "Backup already exists: ${dst}"
        return 0
    fi

    # If source does not exist, warn but do not fail
    if [[ ! -d "${src}" ]]; then
        log_warn "Source folder does not exist: ${src}"
        return 0
    fi

    log_subsection "Creating folder backup: ${src} -> ${dst}"
    cp -a -- "${src}" "${dst}"
}

backup_file_once() {
    local src="$1"
    local dst="$2"

    if [[ ! -f "${src}" ]]; then
        log_warn "Source file does not exist: ${src}"
        return 0
    fi

    if [[ -f "${dst}" ]]; then
        log_info "Backup already exists: ${dst}"
    else
        log_subsection "Creating backup: ${dst}"
        sudo cp -v "${src}" "${dst}"
    fi
}

copy_file() {
    local src="$1"
    local dst="$2"

    if [[ ! -f "${src}" ]]; then
        log_warn "Source file missing: ${src}"
        return 1
    fi

    log_subsection "Copying ${src} -> ${dst}"
    sudo cp -v "${src}" "${dst}"
}

copy_file_user() {
    local src="$1"
    local dst="$2"

    [[ -f "$src" ]] || {
        log_warn "Source file missing: $src"
        return 1
    }

    log_subsection "Copying (user: $TARGET_USER) $src -> $dst"
    sudo -u "$TARGET_USER" cp -v -- "$src" "$dst"
}

move_file() {
    local src="$1"
    local dst="$2"

    [[ -f "${src}" ]] || return 0

    log_subsection "Moving ${src} -> ${dst}"
    sudo mv -v "${src}" "${dst}"
}

move_file_user() {
    local src="$1"
    local dst="$2"

    [[ -f "$src" ]] || {
        log_warn "Source file missing: $src"
        return 1
    }

    log_subsection "Moving (user: $TARGET_USER) $src -> $dst"
    sudo -u "$TARGET_USER" mv -v -- "$src" "$dst"
}

write_file_as_root() {
    local target="$1"

    log_subsection "Writing ${target}"
    sudo tee "${target}" >/dev/null
}

append_line_if_missing() {
    local file="$1"
    local line="$2"

    if [[ ! -f "$file" ]]; then
        log_warn "Skipping: file not found: $file"
        return 0
    fi

    if grep -qxF "$line" "$file"; then
        log_info "Line already present in $file"
    else
        printf '%s\n' "$line" >> "$file"
        log_info "Added line to $file: $line"
    fi
}

remove_file_if_exists() {
    local target="$1"

    if [[ -f "${target}" ]]; then
        sudo rm -f "${target}"
        log_info "Removed: ${target}"
    else
        log_info "Already removed: ${target}"
    fi
}

remove_folder_if_exists() {
    local target="$1"

    if [[ -d "${target}" ]]; then
        sudo rm -rf "${target}"
        log_info "Removed folder: ${target}"
    else
        log_info "Folder already removed: ${target}"
    fi
}

move_folder_if_exists() {
    local source="$1"
    local destination="$2"

    if [[ ! -d "${source}" ]]; then
        log_info "Source folder does not exist: ${source}"
        return
    fi

    if [[ -e "${destination}" ]]; then
        log_info "Destination already exists: ${destination}"
        return
    fi

    sudo mv "${source}" "${destination}"
    log_info "Moved folder: ${source} -> ${destination}"
}

append_text_as_root() {
    local target="$1"
    sudo tee -a "$target" >/dev/null
}

set_parallel_downloads() {
    local file="/etc/pacman.conf"

    echo "Setting ParallelDownloads to 25"

    [[ -f "$file" ]] || { echo "File not found: $file"; return 1; }

    sudo sed -i '/ParallelDownloads/c\ParallelDownloads = 25' "$file"
}

create_gtk3_dir() {
  local GTK3_DIR="$USER_HOME/.config/gtk-3.0"
  mkdir -p "$GTK3_DIR"
}

create_hypr_dir() {
  local HYPR_DIR="$USER_HOME/.config/hypr"
  mkdir -p "$HYPR_DIR"
}

##################################################################################################################################
# 9. User and group helpers
##################################################################################################################################
add_user_to_group() {
    local user="$1"
    local group="$2"

    if id -nG "${user}" | grep -qw "${group}"; then
        log_info "User ${user} already in group ${group}"
    else
        log_subsection "Adding ${user} to group ${group}"
        sudo gpasswd -a "${user}" "${group}"
    fi
}

confirm_yes_no() {
    local prompt="$1"
    local reply

    while true; do
        echo
        echo "${YELLOW}########################################################################${RESET}"
        echo "${prompt}"
        echo "Answer with Y/y or N/n (default: Y)"
        echo "${YELLOW}########################################################################${RESET}"
        echo
        read -r reply

        case "${reply}" in
            ""|[yY]) return 0 ;;
            [nN]) return 1 ;;
            *) echo "Invalid answer. Please use Y/y or N/n." ;;
        esac
    done
}

##################################################################################################################################
# 10. Download and AUR helpers
##################################################################################################################################
install_aur_package() {
    local pkg="$1"

    if pkg_installed "${pkg}"; then
        log_info "AUR package ${pkg} already installed"
        return 0
    fi

    if command -v yay >/dev/null 2>&1; then
        log_subsection "Installing AUR package ${pkg} with yay"
        yay -S --noconfirm "${pkg}"
    elif command -v paru >/dev/null 2>&1; then
        log_subsection "Installing AUR package ${pkg} with paru"
        paru -S --noconfirm "${pkg}"
    else
        log_warn "No AUR helper found (yay/paru)"
        return 1
    fi
}

##################################################################################################################################
# Download file
##################################################################################################################################
download_file() {
    local url="$1"
    local dest="$2"

    log_subsection "Downloading $(basename "${dest}")"
    curl -L --fail --output "${dest}" "${url}"
}

##################################################################################################################################
# 11. Repo and pacman helpers
##################################################################################################################################
write_arch_mirrorlist() {
    log_section "Replacing content of current /etc/pacman.d/mirrorlist
Backup exists here: /etc/pacman.d/mirrorlist-nemesis"

    sudo tee /etc/pacman.d/mirrorlist >/dev/null <<'EOF'
## Best Arch Linux servers worldwide from arcolinux-nemesis

Server = https://mirror.osbeck.com/archlinux/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = http://mirror.osbeck.com/archlinux/$repo/os/$arch
Server = http://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch
EOF

    log_section "Arch Linux servers have been written to /etc/pacman.d/mirrorlist
Use nmirrorlist when on ArcoLinux to inspect
Use nano /etc/pacman.d/mirrorlist to inspect on others"
}

restore_pacman_conf() {
    if [[ -f /etc/pacman.conf.nemesis ]]; then
        copy_file /etc/pacman.conf.nemesis /etc/pacman.conf
    else
        log_warn "/etc/pacman.conf.nemesis not found - cannot restore pacman.conf"
    fi
}

append_nemesis_repo() {
    if ! grep -q "^\[nemesis_repo\]" /etc/pacman.conf; then
        log_warn "Adding nemesis_repo to /etc/pacman.conf"

        sudo tee -a /etc/pacman.conf >/dev/null <<'EOF_NEMESIS'

[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/$repo/$arch
EOF_NEMESIS
    else
        log_info "nemesis_repo already present in /etc/pacman.conf"
    fi
}

append_chaotic_repo() {
    if ! grep -q "^\[chaotic-aur\]" /etc/pacman.conf; then
        log_warn "Adding chaotic-aur repo to /etc/pacman.conf"

        sudo tee -a /etc/pacman.conf >/dev/null <<'EOF_CHAOTIC'

[chaotic-aur]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/chaotic-mirrorlist
EOF_CHAOTIC
    else
        log_info "chaotic-aur already present in /etc/pacman.conf"
    fi
}

##################################################################################################################################
# 12. Project-specific helpers
##################################################################################################################################
run_glob() {
    local pattern="$1"
    local files=( ${pattern} )
    local file

    (( ${#files[@]} == 0 )) && return 0

    for file in "${files[@]}"; do
        [[ -f "${file}" ]] && bash "${file}"
    done
}

run_non_arch_distro_script() {
    local distro_key="$1"
    local target_dir="${PERSONAL_DIR}/settings/voyage-of-chadwm/${distro_key}-chadwm"
    local target_script="${target_dir}/1-all-in-one.sh"

    if [[ -d "${target_dir}" && -f "${target_script}" ]]; then
        log_section "Detected ${distro_key}. Launching distro-specific Chadwm script."
        (
            cd "${target_dir}" || exit 1
            bash "./1-all-in-one.sh"
        )
        exit 0
    fi
}

run_chadwm_choice() {
    local flag="/tmp/install-chadwm"

    pause_if_debug
    log_section "Chadwm installation choice - installation will follow later on"

    if confirm_yes_no "Do you want to install Chadwm on your system?"; then
        log_warn "User chose to install Chadwm"
        touch "$flag"
    else
        log_warn "User chose not to install Chadwm"
        rm -f "$flag"
    fi
}

disable_firewalld_stack() {
    log_subsection "Removing firewalld stack"

    disable_service firewalld
    remove_matching_packages firewall-applet firewall-config firewalld
}

install_sddm_git() {
    log_subsection "Installing sddm-git"
    install_aur_package sddm-git
    enable_service sddm.service

    echo
    echo "SDDM has been installed and enabled."
    echo "Please reboot later to start using the display manager."
    echo
}

remove_gpsd() {
    if pacman -Qi gpsd &>/dev/null; then
        log_subsection "Removing gpsd"
        remove_matching_packages_deps waybar gpsd
    else
        log_info "gpsd is not installed"
    fi
}

# Ensure a readable console font exists
ensure_vconsole_font() {
    echo "Adding font to /etc/vconsole.conf"

    # Add font only if not already defined
    if ! grep -q "^FONT=" /etc/vconsole.conf 2>/dev/null; then
        echo "FONT=lat4-19" | sudo tee --append /etc/vconsole.conf >/dev/null
    fi
}

set_sddm_session() {
    local session_name="$1"
    local file="/etc/sddm.conf.d/kde_settings.conf"

    log_subsection "Setting SDDM session to ${session_name}"

    if [[ -z "$session_name" ]]; then
        log_warn "No SDDM session name provided"
        return 1
    fi

    if [[ ! -f "$file" ]]; then
        log_warn "File not found: $file"
        return 0
    fi

    if grep -q '^Session=' "$file"; then
        sudo sed -i "s/^Session=.*/Session=${session_name}/" "$file"
    else
        echo "Session=${session_name}" | sudo tee -a "$file" >/dev/null
    fi
}