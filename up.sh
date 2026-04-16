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
##################################################################################################################

set -uo pipefail   # -e intentionally omitted: continue on errors by design
shopt -s nullglob

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$(cd -- "${SCRIPT_DIR}/common" && pwd)"

source "${COMMON_DIR}/common.sh"

WORKDIR="${SCRIPT_DIR}"
CHAOTIC_URL="https://chaoticmirror.com/chaotic-aur/chaotic-aur/x86_64/"
DEST="${SCRIPT_DIR}/packages"
MIRRORLIST_FILE="${WORKDIR}/mirrorlist"

##################################################################################################################
# Configuration
##################################################################################################################

enable_chaotic_packages() {
    CHAOTIC_ENABLED=true
}

##################################################################################################################
# Helpers
##################################################################################################################

get_version() {
    local filename="${1:-}"
    [[ -n "${filename}" ]] || return 0
    basename "${filename}" | sed -E 's/^.*-([0-9]{8,})-[0-9]+-any\.pkg\.tar\.zst$/\1/'
}

fetch_remote_package_list() {
    curl -fsSL "${CHAOTIC_URL}" | grep -oP 'href="[^"]*\.pkg\.tar\.zst"' | cut -d'"' -f2
}

update_chaotic_package() {
    local pkg="$1"
    local remote_list="$2"
    local remote_file=""
    local local_file=""
    local remote_version=""
    local local_version=""

    remote_file="$(echo "${remote_list}" | grep "^${pkg}-.*-any\.pkg\.tar\.zst" | sort -Vr | head -n1)"
    if [[ -z "${remote_file}" ]]; then
        log_warn "No remote version found for ${pkg}"
        return 0
    fi

    local_file="$(find "${DEST}" -maxdepth 1 -type f -name "${pkg}-*-any.pkg.tar.zst" | sort -Vr | head -n1)"

    remote_version="$(get_version "${remote_file}")"
    local_version="$(get_version "${local_file}")"

    if [[ "${remote_version}" != "${local_version}" ]]; then
        log_subsection "Updating ${pkg}: ${local_version:-none} -> ${remote_version}"

        if curl -fLO "${CHAOTIC_URL}${remote_file}"; then
            rm -f "${DEST}/${pkg}"*
            mv -f "${remote_file}" "${DEST}/"
            log_success "${pkg} updated"
        else
            log_error "Failed to download ${pkg}"
        fi
    else
        log_info "${pkg} is up to date: ${local_version}"
    fi
}

update_chaotic_packages() {
    local remote_list=""

    [[ "${CHAOTIC_ENABLED}" == "true" ]] || {
        log_info "Chaotic package update disabled"
        return 0
    }

    log_section "Updating Chaotic keyring and mirrorlist"

    remote_list="$(fetch_remote_package_list)" || {
        log_error "Failed to fetch remote package list from ${CHAOTIC_URL}"
        return 1
    }

    update_chaotic_package "chaotic-keyring" "${remote_list}"
    update_chaotic_package "chaotic-mirrorlist" "${remote_list}"
}

generate_mirrorlist() {
    log_section "Generating mirrorlist"

    > "${MIRRORLIST_FILE}"

    cat <<'EOF' | tee "${MIRRORLIST_FILE}" >/dev/null
## Best Arch Linux servers worldwide from arcolinux-nemesis

Server = https://mirror.osbeck.com/archlinux/$repo/os/$arch
Server = http://mirror.osbeck.com/archlinux/$repo/os/$arch
Server = https://mirrors.kernel.org/archlinux/$repo/os/$arch
Server = https://geo.mirror.pkgbuild.com/$repo/os/$arch
Server = http://mirror.rackspace.com/archlinux/$repo/os/$arch
Server = https://mirror.rackspace.com/archlinux/$repo/os/$arch
EOF

    log_info "Getting mirrorlist from archlinux.org"

    if wget "https://archlinux.org/mirrorlist/?country=all&protocol=http&protocol=https&ip_version=4&ip_version=6" -O - >> "${MIRRORLIST_FILE}"; then
        sed -i 's/^#Server/Server/g' "${MIRRORLIST_FILE}"
        log_success "Mirrorlist updated"
    else
        log_error "Failed to download Arch Linux mirrorlist"
    fi
}

update_kiro_sysctl() {
    log_section "Updating kiro sysctl optimizations from GitHub"

    local sysctl_dir="${SCRIPT_DIR}/personal/settings/sysctl.d"
    local sysctl_file="${sysctl_dir}/99-kiro-optimizations.conf"
    local sysctl_url="https://raw.githubusercontent.com/erikdubois/edu-dot-files/refs/heads/main/etc/sysctl.d/99-kiro-optimizations.conf"

    mkdir -p "${sysctl_dir}"

    if curl -fsSL "${sysctl_url}" -o "${sysctl_file}"; then
        log_success "kiro sysctl optimizations updated"
    else
        log_error "Failed to download kiro sysctl optimizations"
        return 1
    fi
}

update_kiro_coredump() {
    log_section "Updating kiro coredump configuration from GitHub"

    local coredump_dir="${SCRIPT_DIR}/personal/settings/systemd/coredump.conf.d"
    local coredump_file="${coredump_dir}/10-kiro-coredump.conf"
    local coredump_url="https://raw.githubusercontent.com/erikdubois/edu-dot-files/refs/heads/main/etc/systemd/coredump.conf.d/10-kiro-coredump.conf"

    mkdir -p "${coredump_dir}"

    if curl -fsSL "${coredump_url}" -o "${coredump_file}"; then
        log_success "kiro coredump configuration updated"
    else
        log_error "Failed to download kiro coredump configuration"
        return 1
    fi
}

git_commit_and_push() {
    local input branch

    log_section "Git add / commit / push"
    git add --all .

    git commit -m "update" || log_warn "Nothing to commit or commit failed"

    branch="$(git rev-parse --abbrev-ref HEAD)"
    git push -u origin "${branch}" || log_error "Git push failed"
}

main() {
    enable_chaotic_packages
    update_chaotic_packages
    generate_mirrorlist
    update_kiro_sysctl
    update_kiro_coredump
    git_commit_and_push

    echo
    tput setaf 6
    echo "##############################################################"
    echo "###################  $(basename "$0") done"
    echo "##############################################################"
    tput sgr0
    echo
}

main "$@"