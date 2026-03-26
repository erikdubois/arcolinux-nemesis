#!/usr/bin/env bash

##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
# Github    : https://github.com/erikdubois
# Github    : https://github.com/kirodubes
# Github    : https://github.com/buildra
# SF        : https://sourceforge.net/projects/kiro/files/
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
#   Purpose:
#   - This is the main orchestration script for a Nemesis setup.
#   - It detects the current operating system, prepares repositories,
#     runs distro-specific handlers, and then launches the numbered
#     installation stages in sequence.
#
##################################################################################################################

export DEBUG=false

# Path setup
WORKING_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
echo "Working directory             : ${WORKING_DIR}"

# Source shared helper functions and handlers.
source "${WORKING_DIR}/common/common.sh"
source "${WORKING_DIR}/common/handle.sh"

COMMON_DIR="${WORKING_DIR}/common"
echo "Common directory              : ${COMMON_DIR}"

PERSONAL_DIR="${WORKING_DIR}/personal"
echo "Personal directory            : ${PERSONAL_DIR}"

PACKAGES_DIR="${WORKING_DIR}/packages"
echo "Packages directory            : ${PACKAGES_DIR}"

SETTINGS_DIR="${WORKING_DIR}/personal/settings"
echo "Settings directory            : ${SETTINGS_DIR}"

# Determine the username and home directory of the user running the script.
USERNAME="${SUDO_USER:-$USER}"
USER_HOME="$(getent passwd "$USERNAME" | cut -d: -f6)"

# Files used for OS detection.
OS_RELEASE="/etc/os-release"
LSB_RELEASE="/etc/lsb-release"

# Keep the discovered OS metadata in dedicated variables.
OS_ID=""
OS_ID_LIKE=""
OS_NAME=""
OS_PRETTY_NAME=""

detect_os() {
    if [[ -f "${OS_RELEASE}" ]]; then
        # shellcheck disable=SC1091
        source "${OS_RELEASE}"

        OS_ID="${ID:-}"
        OS_ID_LIKE="${ID_LIKE:-}"
        OS_NAME="${NAME:-}"
        OS_PRETTY_NAME="${PRETTY_NAME:-}"
    fi
}

print_os_summary() {
    printf "\n"
    printf "========================================\n"
    printf "        Operating System Details        \n"
    printf "========================================\n"
    printf "%-20s : %s\n" "OS_ID"          "${OS_ID}"
    printf "%-20s : %s\n" "OS_ID_LIKE"     "${OS_ID_LIKE}"
    printf "%-20s : %s\n" "OS_NAME"        "${OS_NAME}"
    printf "%-20s : %s\n" "OS_PRETTY_NAME" "${OS_PRETTY_NAME}"
    printf "========================================\n"
    printf "\n"
    printf "Use the script give-me-pacman.conf.sh to only get the new /etc/pacman.conf\n"
    printf "Stop this script with CTRL + C then and run give-me-pacman.conf.sh\n"
}

route_non_arch_if_needed() {
    # Optional Chadwm decision point controlled elsewhere in the project.
    run_chadwm_choice

    # First check if we are on something else than Arch based, then run the script for that distro.
    if [[ -f "${LSB_RELEASE}" ]] && grep -q "MX 23.4" "${LSB_RELEASE}"; then
        run_non_arch_distro_script "mxlinux"
    fi

    # Non-Arch routing.
    case "${OS_ID,,}:${OS_NAME,,}:${OS_PRETTY_NAME,,}" in
        *bunsenlabs* ) run_non_arch_distro_script "bunsenlabs" ;;
        *freebsd* )    run_non_arch_distro_script "freebsd" ;;
        *ghostbsd* )   run_non_arch_distro_script "ghostbsd" ;;
        *debian* )     run_non_arch_distro_script "debian" ;;
        *peppermint* ) run_non_arch_distro_script "peppermint" ;;
        *pop* )        run_non_arch_distro_script "popos" ;;
        *lmde* )       run_non_arch_distro_script "lmde6" ;;
        *linuxmint* )  run_non_arch_distro_script "mint" ;;
        *almalinux* )  run_non_arch_distro_script "almalinux" ;;
        *anduinos* )   run_non_arch_distro_script "anduin" ;;
        *ubuntu* )     run_non_arch_distro_script "ubuntu" ;;
        *void* )       run_non_arch_distro_script "void" ;;
        *nobara* )     run_non_arch_distro_script "nobara" ;;
        *fedora* )     run_non_arch_distro_script "fedora" ;;
        *solus* )      run_non_arch_distro_script "solus" ;;
    esac
}

run_backup_operations() {
    pause_if_debug
    log_section "Running backup operations"

    log_warn "Creating backups of important configuration files"

    backup_file_once /etc/skel/.bashrc /etc/skel/.bashrc-nemesis
    backup_file_once /etc/skel/.zshrc /etc/skel/.zshrc-nemesis
    backup_file_once /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-nemesis
    backup_file_once /etc/pacman.conf /etc/pacman.conf.nemesis
    backup_file_once /etc/pacman.conf /etc/pacman.conf.edu
    backup_file_once /etc/environment /etc/environment.nemesis
    backup_file_once /etc/nanorc /etc/nanorc.nemesis
    backup_file_once /etc/nsswitch.conf /etc/nsswitch.conf.nemesis
    backup_folder_as_root /etc/sysctl.d/ /etc/sysctl.d.nemesis

    log_warn "Backup operations completed"
}

run_remove_anywhere_software() {
    pause_if_debug
    log_section "Running removal of software on any Arch based distro"

    log_warn "Move configs for all - backup"
    log_warn "Removing the driver for xf86-video-vmware if possible"

    if command -v systemd-detect-virt >/dev/null 2>&1; then
        if ! systemd-detect-virt | grep -q "oracle"; then
            if pacman -Qi xf86-video-vmware >/dev/null 2>&1; then
                remove_matching_packages xf86-video-vmware
            fi
        fi
    fi

    remove_matching_packages archinstall
    remove_matching_packages neofetch
    remove_matching_packages fastfetch
    remove_matching_packages yay
    remove_matching_packages yay-bin
    remove_matching_packages paru
    remove_matching_packages picom
    remove_matching_packages mkinitcpio-nfs-utils
    remove_matching_packages xfburn
    remove_matching_packages parole
    remove_matching_packages_deps pamac
    remove_matching_packages_deps pamac-git
    remove_matching_packages mpv
    remove_matching_packages clapper

    log_warn "Partition formatting software - we check the root filesystem"
    log_warn "and remove the software for the filesystems that are not used on the system"

    root_fs="$(findmnt -no FSTYPE /)"

    case "${root_fs}" in
        xfs)
            remove_matching_packages btrfs-progs
            remove_matching_packages jfsutils
            ;;
        btrfs)
            remove_matching_packages xfsprogs
            remove_matching_packages jfsutils
            ;;
        jfs)
            remove_matching_packages xfsprogs
            remove_matching_packages btrfs-progs
            ;;
        *)
            remove_matching_packages xfsprogs
            remove_matching_packages btrfs-progs
            remove_matching_packages jfsutils
            ;;
    esac
}

setup_repositories_and_update() {
    log_section "Installing Chaotic keyring and Chaotic mirrorlist"
    install_local_packages

    append_chaotic_repo
    append_nemesis_repo
    set_parallel_downloads

    log_section "Updating the system - sudo pacman -Syyu - after configure_repos"
    sudo pacman -Syyu --noconfirm

    log_section "Installing much needed software"
    install_packages sublime-text-4 ripgrep meld
}

run_base_modules() {
    log_warn "Start of the scripts - choices what to launch or not"

    run_remove_anywhere_software

    run_glob "${WORKING_DIR}/100-*"
    run_glob "${WORKING_DIR}/110-*"
    #run_glob "${WORKING_DIR}/120-*"
    run_glob "${WORKING_DIR}/130-*"
    run_glob "${WORKING_DIR}/140-*"
    run_glob "${WORKING_DIR}/150-*"

    run_glob "${WORKING_DIR}/200-software-aur-repo*"
    # run_glob "${WORKING_DIR}/300-sardi-extras*"
    # run_glob "${WORKING_DIR}/400-surfn-extras*"

    run_glob "${WORKING_DIR}/500-plasma*"
    run_glob "${WORKING_DIR}/600-chadwm*"
}

run_personal_modules() {
    log_warn "Going to the Personal folder"

    run_glob "${PERSONAL_DIR}/900-*"
    run_glob "${PERSONAL_DIR}/910-*"
    run_glob "${PERSONAL_DIR}/920-*"
    run_glob "${PERSONAL_DIR}/930-*"
    run_glob "${PERSONAL_DIR}/990-skel*"
    run_glob "${PERSONAL_DIR}/999-last*"
}

main() {
    log_section "Running $(script_name)"

    detect_os
    print_os_summary
    route_non_arch_if_needed

    run_backup_operations

    # Run distro-specific handlers from common/handle.sh.
    run_all_distro_handlers

    setup_repositories_and_update
    run_base_modules
    run_personal_modules

    log_warn "End current choices"
}

main "$@"