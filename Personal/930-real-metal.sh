#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. && pwd)/common/common.sh"

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

get_virtualization_type() {
    systemd-detect-virt 2>/dev/null || echo none
}

handle_virtualbox_template() {
    local result
    result="$(get_virtualization_type)"

    log_section "Virtualization detection"
    echo "result = ${result}"
    echo

    if [[ "${result}" == "none" ]]; then
        log_section "Real hardware detected - installing VirtualBox template"

        mkdir -p "${HOME}/VirtualBox VMs"

        cp -rf \
            "${PROJECT_DIR}/Personal/settings/virtualbox-template/"* \
            "${HOME}/VirtualBox VMs/"

        cd "${HOME}/VirtualBox VMs/" || return 1

        tar -xzf template.tar.gz
        rm -f template.tar.gz
    else
        log_warn "Virtual machine detected - skipping VirtualBox template
Template not copied over
We will set your screen resolution with xrandr"

        local output
        output="$(xrandr | grep " connected" | awk '{print $1}' || true)"

        if [[ -z "${output}" ]]; then
            log_warn "No connected display found."
            return 0
        fi

        xrandr --output "${output}" --primary --mode 1920x1080 --pos 0x0 --rotate normal
        echo "Display settings applied to output: ${output}"
    fi
}

remove_vm_software_if_real_hardware() {
    local result
    result="$(get_virtualization_type)"

    log_section "Removal of virtual machine software"

    if [[ "${result}" == "none" ]]; then
        echo "Running on real hardware. Proceeding with cleanup..."

        if systemctl list-units --full --all | grep -q 'qemu-guest-agent.service'; then
            sudo systemctl stop qemu-guest-agent.service
            sudo systemctl disable qemu-guest-agent.service
        fi

        if systemctl list-units --full --all | grep -q 'vboxservice.service'; then
            sudo systemctl stop vboxservice.service
            sudo systemctl disable vboxservice.service
        fi

        remove_matching_packages qemu-guest-agent
        remove_matching_packages virtualbox-guest-utils
    else
        echo "Virtual machine detected (${result}). No action taken."
    fi
}

handle_virtualbox_template
remove_vm_software_if_real_hardware

log_subsection "$(script_name) done"