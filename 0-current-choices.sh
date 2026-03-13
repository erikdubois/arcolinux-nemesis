#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/common.sh"
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/handle.sh"

log_section "Running $(script_name)"

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
##################################################################################################################

export DEBUG=true

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly PERSONAL_DIR="${SCRIPT_DIR}/Personal"

OS_RELEASE="/etc/os-release"
LSB_RELEASE="/etc/lsb-release"

OS_ID=""
OS_ID_LIKE=""
OS_NAME=""
OS_PRETTY_NAME=""

if [[ -f "${OS_RELEASE}" ]]; then
    # shellcheck disable=SC1091
    source "${OS_RELEASE}"

    OS_ID="${ID:-}"
    OS_ID_LIKE="${ID_LIKE:-}"
    OS_NAME="${NAME:-}"
    OS_PRETTY_NAME="${PRETTY_NAME:-}"
fi

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
printf "Use the script give-me-pacman.conf.sh to only get the new /etc/pacman.conf"
printf "Stop this script with CTRL + C then and run give-me-pacman.conf.sh"
printf "\n"

# First check if we are on something else than Arch based, then we run the script for that distro
if [[ -f "${LSB_RELEASE}" ]] && grep -q "MX 23.4" "${LSB_RELEASE}"; then
    run_non_arch_distro_script "mxlinux"
fi

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

run_backup_operations() {
    pause_if_debug
    log_section "Running backup operations"

    log_warn "Creating backups of important configuration files"

    # skel configs
    if [[ -f /etc/skel/.bashrc && ! -f /etc/skel/.bashrc-nemesis ]]; then
        sudo mv -v /etc/skel/.bashrc /etc/skel/.bashrc-nemesis
    fi

    if [[ -f /etc/skel/.zshrc && ! -f /etc/skel/.zshrc-nemesis ]]; then
        sudo mv -v /etc/skel/.zshrc /etc/skel/.zshrc-nemesis
    fi

    # pacman mirrorlist
    backup_file_once \
        /etc/pacman.d/mirrorlist \
        /etc/pacman.d/mirrorlist-nemesis

    # pacman.conf.nemesis
    backup_file_once \
        /etc/pacman.conf \
        /etc/pacman.conf.nemesis

    # pacman.conf.edu
    backup_file_once \
        /etc/pacman.conf \
        /etc/pacman.conf.edu

    log_warn "Backup operations completed"
}

run_remove_anywhere_software() {
    pause_if_debug
    log_section "Running removal of software on any Arch based distro"

    log_warn "Move configs for all - backup"

    [[ -f /etc/skel/.bashrc-nemesis ]] || [[ ! -f /etc/skel/.bashrc ]] || sudo mv -v /etc/skel/.bashrc /etc/skel/.bashrc-nemesis
    [[ -f /etc/skel/.zshrc-nemesis ]] || [[ ! -f /etc/skel/.zshrc ]] || sudo mv -v /etc/skel/.zshrc /etc/skel/.zshrc-nemesis

    log_warn "Removing the driver for xf86-video-vmware if possible"

    if command -v systemd-detect-virt >/dev/null 2>&1; then
        if ! systemd-detect-virt | grep -q "oracle"; then
            if pacman -Qi xf86-video-vmware >/dev/null 2>&1; then
                sudo pacman -Rs --noconfirm xf86-video-vmware
            fi
        fi
    fi

    # we go for the -git variants
    remove_matching_packages neofetch
    remove_matching_packages fastfetch
    remove_matching_packages yay
    remove_matching_packages paru
    remove_matching_packages picom
    remove_matching_packages mkinitcpio-nfs-utils
    remove_matching_packages xfburn
    remove_matching_packages parole
    remove_matching_packages_deps pamac
    remove_matching_packages_deps pamac-git
    remove_matching_packages mpv
    remove_matching_packages clapper   

    log_warn "Partition formatting software - we check the root filesystem and remove the software for the filesystems that are not used on the system"

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

run_backup_operations

log_section "Installing Chaotic keyring and Chaotic mirrorlist"
install_local_packages

append_chaotic_repo
append_nemesis_repo

log_section "Updating the system - sudo pacman -Syyu - after configure_repos"
sudo pacman -Syyu --noconfirm

run_all_distro_handlers

log_section "Installing much needed software"
install_packages \
    sublime-text-4 \
    ripgrep \
    meld

run_chadwm_choice

###################################################################################
###################################################################################
###################################################################################
###################################################################################
log_warn "Start of the scripts - choices what to launch or not"

run_remove_anywhere_software

run_glob "${SCRIPT_DIR}/100-*"
run_glob "${SCRIPT_DIR}/110-*"
run_glob "${SCRIPT_DIR}/120-*"
run_glob "${SCRIPT_DIR}/130-*"
run_glob "${SCRIPT_DIR}/140-*"
run_glob "${SCRIPT_DIR}/150-*"

run_glob "${SCRIPT_DIR}/200-software-aur-repo*"
# run_glob "${SCRIPT_DIR}/300-sardi-extras*"
# run_glob "${SCRIPT_DIR}/400-surfn-extras*"

run_glob "${SCRIPT_DIR}/500-plasma*"
run_glob "${SCRIPT_DIR}/600-chadwm*"

log_warn "Going to the Personal folder"
cd "${PERSONAL_DIR}" || exit 1

run_glob "${PERSONAL_DIR}/900-*"
run_glob "${PERSONAL_DIR}/910-*"
run_glob "${PERSONAL_DIR}/920-*"
run_glob "${PERSONAL_DIR}/930-*"

run_glob "${PERSONAL_DIR}/970-distro*"

run_glob "${PERSONAL_DIR}/990-skel*"
run_glob "${PERSONAL_DIR}/999-last*"

log_warn "End current choices"
