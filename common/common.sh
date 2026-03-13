#!/usr/bin/env bash

# Only load once
[[ -n "${COMMON_SH_LOADED:-}" ]] && return 0
readonly COMMON_SH_LOADED=1

set -Euo pipefail
shopt -s nullglob

#--------------------------------------------------------------------------------------------------
# Paths
#--------------------------------------------------------------------------------------------------
readonly COMMON_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly PROJECT_DIR="$(cd -- "${COMMON_DIR}/.." && pwd)"

#--------------------------------------------------------------------------------------------------
# Colors
#--------------------------------------------------------------------------------------------------
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

#--------------------------------------------------------------------------------------------------
# Logging
#--------------------------------------------------------------------------------------------------
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

#--------------------------------------------------------------------------------------------------
# Error handler
#--------------------------------------------------------------------------------------------------
on_error() {
    local lineno="$1"
    local cmd="$2"
    log_error "${lineno}" "${cmd}"
    sleep 10
}

trap 'on_error "$LINENO" "$BASH_COMMAND"' ERR

#--------------------------------------------------------------------------------------------------
# Helpers
#--------------------------------------------------------------------------------------------------
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

enable_service() {
    local service="$1"
    log_subsection "Enabling service: ${service}"
    sudo systemctl enable "${service}"
}

start_service() {
    local service="$1"
    log_subsection "Starting service: ${service}"
    sudo systemctl start "${service}"
}

enable_now_service() {
    local service="$1"
    log_subsection "Enabling and starting service: ${service}"
    sudo systemctl enable --now "${service}"
}

backup_file_once() {
    local src="$1"
    local dst="$2"

    if [[ ! -f "${src}" ]]; then
        log_warn "Source file does not exist: ${src}"
        return 1
    fi

    if [[ -f "${dst}" ]]; then
        log_subsection "Backup already exists: ${dst}"
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

run_glob() {
    local pattern="$1"
    local files=( ${pattern} )
    local file

    (( ${#files[@]} == 0 )) && return 0

    for file in "${files[@]}"; do
        [[ -f "${file}" ]] && bash "${file}"
    done
}

confirm_yes_no() {
    local prompt="$1"
    local reply

    while true; do
        echo
        echo "${YELLOW}########################################################################${RESET}"
        echo "${prompt}"
        echo "Answer with Y/y or N/n"
        echo "${YELLOW}########################################################################${RESET}"
        echo
        read -r reply

        case "${reply}" in
            [yY]) return 0 ;;
            [nN]) return 1 ;;
            *) echo "Invalid answer. Please use Y/y or N/n." ;;
        esac
    done
}

remove_matching_packages() {
    local pkg
    local installed=()

    for pkg in "$@"; do
        installed=()

        if pacman -Qq | grep -Fxq "${pkg}"; then
            installed+=("${pkg}")
        fi

        if (( ${#installed[@]} > 0 )); then
            log_subsection "Removing package: ${pkg}"
            echo "Removing package: ${pkg}"
            sudo pacman -R --noconfirm "${pkg}"
        else
            echo "Package '${pkg}' is not installed."
        fi
    done
}

remove_matching_packages_deps() {
    local pattern
    local matches=()
    local pkg

    for pattern in "$@"; do
        matches=()
        while IFS= read -r pkg; do
            [[ -n "${pkg}" ]] && matches+=("${pkg}")
        done < <(pacman -Qq | grep -Fx -- "${pattern}" || true)

        if (( ${#matches[@]} > 0 )); then
            log_subsection "Removing package with dependencies: ${pattern}"
            for pkg in "${matches[@]}"; do
                echo "Removing package: ${pkg}"
                sudo pacman -Rns --noconfirm "${pkg}"
            done
        else
            echo "No package named '${pattern}' is installed."
        fi
    done
}

remove_file_if_exists() {
    local target="$1"
    if [[ -f "${target}" ]]; then
        rm -f "${target}"
        echo "Removed: ${target}"
    else
        echo "Already removed: ${target}"
    fi
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

install_local_packages() {
    local packages=( "${SCRIPT_DIR}"/packages/*.pkg.tar.zst )

    if (( ${#packages[@]} == 0 )); then
        log_warn "No local packages found in ${SCRIPT_DIR}/packages"
        return 0
    fi

    local pkg
    for pkg in "${packages[@]}"; do
        sudo pacman -U --noconfirm "${pkg}"
    done
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
        log_warn "nemesis_repo already present in /etc/pacman.conf"
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
        log_warn "chaotic-aur already present in /etc/pacman.conf"
    fi
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
    pause_if_debug
    log_section "Chadwm installation choice - installation will follow later on"
   
    if confirm_yes_no "Do you want to install Chadwm on your system?"; then
        log_warn "User chose to install Chadwm"

        touch /tmp/install-chadwm
    else
        log_warn "User chose not to install Chadwm"

        if [[ -f /tmp/install-chadwm ]]; then
            rm -f /tmp/install-chadwm
        fi
    fi
}

