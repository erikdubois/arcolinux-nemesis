#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/common.sh"

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

run_distro_script() {
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

if [[ -f "${LSB_RELEASE}" ]] && grep -q "MX 23.4" "${LSB_RELEASE}"; then
    run_distro_script "mxlinux"
fi

case "${OS_ID,,}:${OS_NAME,,}:${OS_PRETTY_NAME,,}" in
    *bunsenlabs* ) run_distro_script "bunsenlabs" ;;
    *freebsd* )    run_distro_script "freebsd" ;;
    *ghostbsd* )   run_distro_script "ghostbsd" ;;
    *debian* )     run_distro_script "debian" ;;
    *peppermint* ) run_distro_script "peppermint" ;;
    *pop* )        run_distro_script "popos" ;;
    *lmde* )       run_distro_script "lmde6" ;;
    *linuxmint* )  run_distro_script "mint" ;;
    *almalinux* )  run_distro_script "almalinux" ;;
    *anduinos* )   run_distro_script "anduin" ;;
    *ubuntu* )     run_distro_script "ubuntu" ;;
    *void* )       run_distro_script "void" ;;
    *nobara* )     run_distro_script "nobara" ;;
    *fedora* )     run_distro_script "fedora" ;;
    *solus* )      run_distro_script "solus" ;;
esac

echo "Use the script give-me-pacman.conf.sh to only get the new /etc/pacman.conf"
echo "Stop this script with CTRL + C then and run give-me-pacman.conf.sh"

if confirm_yes_no "Do you want to install Chadwm on your system?"; then
    touch /tmp/install-chadwm
    remove_packages \
        arcolinux-chadwm-pacman-hook-git \
        arcolinux-chadwm-git
else
    [[ -f /tmp/install-chadwm ]] && rm -f /tmp/install-chadwm
fi

if ! grep -q -e "Manjaro" -e "Artix" "${OS_RELEASE}" 2>/dev/null; then
    backup_file_once \
        /etc/pacman.d/mirrorlist \
        /etc/pacman.d/mirrorlist-nemesis

    write_arch_mirrorlist
fi

log_section "Installing Chaotic keyring and Chaotic mirrorlist"
install_local_packages

backup_file_once \
    /etc/pacman.conf \
    /etc/pacman.conf.nemesis

copy_file "${SCRIPT_DIR}/pacman.conf" /etc/pacman.conf
copy_file "${SCRIPT_DIR}/pacman.conf" /etc/pacman.conf.edu

echo
echo "/etc/pacman.conf.edu is there to have a backup"
echo

if ! grep -qi "kiro" "${OS_RELEASE}" 2>/dev/null; then
    log_warn "Removing ArcoLinux software"

    remove_packages \
        archlinux-tweak-tool-git \
        archlinux-tweak-tool-dev-git \
        arcolinux-keyring \
        arcolinux-mirrorlist-git

    log_warn "Software removed"
fi

log_section "Updating the system - sudo pacman -Syyu - before 700-intervention"
sudo pacman -Syyu --noconfirm

run_glob "${SCRIPT_DIR}/700-intervention*"

log_section "Updating the system - sudo pacman -Syyu - after 700-intervention"
sudo pacman -Syyu --noconfirm

log_section "Installing much needed software"
install_packages \
    sublime-text-4 \
    ripgrep \
    meld

if [[ -f /etc/dev-rel ]]; then
    if [[ "$(sudo bootctl is-installed 2>/dev/null || true)" == "yes" ]]; then
        log_warn "By default we choose systemd-boot
This is to be able to change the kernel"

        install_packages pacman-hook-kernel-install
    fi
fi

log_warn "Start of the scripts - choices what to launch or not"

run_glob "${SCRIPT_DIR}/100-remove-software*"
run_glob "${SCRIPT_DIR}/110-install-nemesis-software*"
run_glob "${SCRIPT_DIR}/120-install-core-software*"

run_glob "${SCRIPT_DIR}/160-install-bluetooth*"
run_glob "${SCRIPT_DIR}/170-install-cups*"
run_glob "${SCRIPT_DIR}/180-ananicy*"

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