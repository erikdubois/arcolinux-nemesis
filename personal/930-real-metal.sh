#!/usr/bin/env bash
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")"/.. && pwd)/common/common.sh"

log_section "Running $(script_name)"

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
echo $SCRIPT_DIR
SETTINGS_DIR="${SCRIPT_DIR}/settings"
echo $SETTINGS_DIR

pause_if_debug

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
    systemd-detect-virt 2>/dev/null || echo "none"
}

handle_virtualbox_template() {
    local result
    local template_dir
    local vm_dir
    local output

    result="$(get_virtualization_type)"
    template_dir="${PROJECT_DIR}/p/settings/virtualbox-template"
    vm_dir="${HOME}/VirtualBox VMs"

    log_section "Virtualization detection"
    echo "Result: ${result}"
    echo

    if [[ "${result}" == "none" ]]; then
        log_section "Real hardware detected - installing VirtualBox template"

        if [[ ! -d "${template_dir}" ]]; then
            log_warn "Template directory not found: ${template_dir}"
            return 1
        fi

        mkdir -p "${vm_dir}"

        cp -rf "${template_dir}/." "${vm_dir}/" || {
            log_warn "Failed to copy VirtualBox template files"
            return 1
        }

        cd "${vm_dir}" || return 1

        if [[ -f "template.tar.gz" ]]; then
            tar -xzf "template.tar.gz" || {
                log_warn "Failed to extract template.tar.gz"
                return 1
            }
            rm -f "template.tar.gz"
        else
            log_warn "template.tar.gz not found in ${vm_dir}"
        fi
    else
        log_warn "Virtual machine detected - skipping VirtualBox template"
        log_warn "Template not copied over"
        log_warn "We will set your screen resolution with xrandr"

        if ! command -v xrandr >/dev/null 2>&1; then
            log_warn "xrandr not found"
            return 0
        fi

        output="$(xrandr | awk '/ connected primary/ {print $1; exit} / connected/ {print $1; exit}')"

        if [[ -z "${output}" ]]; then
            log_warn "No connected display found"
            return 0
        fi

        xrandr --output "${output}" --primary --mode 1920x1080 --pos 0x0 --rotate normal || {
            log_warn "Failed to apply xrandr settings to ${output}"
            return 1
        }

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