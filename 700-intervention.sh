#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)/common/common.sh"

log_section "Running $(script_name)"

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################

readonly SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

restore_pacman_conf() {
    if [[ -f /etc/pacman.conf.nemesis ]]; then
        copy_file /etc/pacman.conf.nemesis /etc/pacman.conf
    else
        log_warn "/etc/pacman.conf.nemesis not found - cannot restore pacman.conf"
    fi
}

append_nemesis_repo() {
    sudo tee -a /etc/pacman.conf >/dev/null <<'EOF'

[nemesis_repo]
SigLevel = Never
Server = https://erikdubois.github.io/$repo/$arch
EOF
}

append_chaotic_repo() {
    sudo tee -a /etc/pacman.conf >/dev/null <<'EOF'

[chaotic-aur]
SigLevel = Required DatabaseOptional
Include = /etc/pacman.d/chaotic-mirrorlist
EOF
}

configure_repos() {
    local distro_name="$1"
    local include_chaotic="$2"

    log_section "We are on ${distro_name}"

    restore_pacman_conf
    append_nemesis_repo

    if [[ "${include_chaotic}" == "true" ]]; then
        append_chaotic_repo
        echo "Repositories (chaotic/nemesis) added to /etc/pacman.conf"
    else
        echo "Repository (nemesis) added to /etc/pacman.conf"
    fi
}

handle_archbang() {
    log_section "We are on ArchBang"
    echo "Making backups of important files to start openbox"

    if [[ -f "${HOME}/.bash_profile" && ! -f "${HOME}/.bash_profile_nemesis" ]]; then
        cp -vf "${HOME}/.bash_profile" "${HOME}/.bash_profile_nemesis"
    fi

    if [[ -f "${HOME}/.xinitrc" && ! -f "${HOME}/.xinitrc-nemesis" ]]; then
        cp -vf "${HOME}/.xinitrc" "${HOME}/.xinitrc-nemesis"
    fi

    mkdir -p "${HOME}/.bin"

    if [[ -f "/home/${USER}/AB_Scripts/startpanel" ]]; then
        cp "/home/${USER}/AB_Scripts/startpanel" "${HOME}/.bin/startpanel"
    else
        log_warn "File not found: /home/${USER}/AB_Scripts/startpanel"
    fi

    echo "Getting our mirrorlist in"
    copy_file "${SCRIPT_DIR}/mirrorlist" /etc/pacman.d/mirrorlist

    echo
    echo "Change from xz to zstd in mkinitcpio"
    echo

    sudo sed -i 's/COMPRESSION="xz"/COMPRESSION="zstd"/g' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
}

handle_omarchy() {
    if [[ -f /etc/plymouth/plymouthd.conf ]] && grep -q "omarchy" /etc/plymouth/plymouthd.conf; then
        configure_repos "OMARCHY" "true"
    fi
}


if grep -q "artix" /etc/os-release; then
    configure_repos "Artix" "true"
fi

if grep -q "rebornos" /etc/os-release; then
    configure_repos "RebornOS" "true"
fi

if grep -q "archcraft" /etc/os-release; then
    configure_repos "Archcraft" "true"
fi

if grep -q "CachyOS" /etc/os-release; then
    configure_repos "CachyOS" "true"
fi

if grep -q "Manjaro" /etc/os-release; then
    configure_repos "Manjaro" "true"
fi

if grep -q "Garuda" /etc/os-release; then
    configure_repos "Garuda" "false"
fi

if grep -q "ArchBang" /etc/os-release; then
    handle_archbang
fi

if grep -q "Liya" /etc/os-release; then
    configure_repos "Liya" "false"
fi

if grep -q "Berserk" /etc/os-release; then
    configure_repos "Berserk" "false"
fi

if grep -q "Prism" /etc/os-release; then
    configure_repos "PrismLinux" "false"
fi

if grep -q "blend" /etc/os-release; then
    configure_repos "BlendOS" "true"
fi

if grep -q "EndeavourOS" /etc/os-release; then
    configure_repos "EndeavourOS" "true"
fi

handle_omarchy

log_subsection "$(script_name) done"