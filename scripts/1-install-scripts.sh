#!/usr/bin/env bash

##################################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
##################################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################################

set -Euo pipefail
shopt -s nullglob

SCRIPTS_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
COMMON_DIR="$(cd -- "${SCRIPTS_DIR}/../common" && pwd)"
source "${COMMON_DIR}/common.sh"

##################################################################################################################################
# Purpose
# - Provide an interactive menu to run installation scripts from the scripts directory
# - Automatically discover all .sh scripts in the current directory except the launcher itself
# - Display a checklist using dialog or whiptail
# - Allow the user to select one or more scripts to execute
# - Provide an option to install all scripts at once
# - Run the selected scripts sequentially
# - Use shared logging and helper functions from common/common.sh
##################################################################################################################################

ALL_OPTION="__ALL__"

get_dialog_bin() {
    command -v dialog || command -v whiptail
}

collect_scripts() {
    local file
    local scripts=()

    for file in "${SCRIPTS_DIR}"/*.sh; do
        [[ -f "${file}" ]] || continue
        [[ "$(basename "${file}")" == 1-* ]] && continue
        scripts+=( "$(basename "${file}")" )
    done

    printf '%s\n' "${scripts[@]}"
}

build_menu_items() {
    local script
    local items=()

    items+=( "${ALL_OPTION}" "Install all scripts" "OFF" )

    for script in "$@"; do
        items+=( "${script}" "" "OFF" )
    done

    printf '%s\n' "${items[@]}"
}

show_checklist() {
    local dialog_bin="$1"
    shift

    local height=20
    local width=80
    local list_height=15

    if [[ "$(basename "${dialog_bin}")" == "dialog" ]]; then
        "${dialog_bin}" \
            --stdout \
            --checklist "Select scripts to run:" \
            "${height}" "${width}" "${list_height}" \
            "$@"
    else
        "${dialog_bin}" \
            --separate-output \
            --checklist "Select scripts to run:" \
            "${height}" "${width}" "${list_height}" \
            "$@" 3>&1 1>&2 2>&3
    fi
}

parse_selected_items() {
    local dialog_bin="$1"
    local selected_raw="$2"
    local item

    local -a parsed=()

    if [[ "$(basename "${dialog_bin}")" == "dialog" ]]; then
        eval "parsed=( ${selected_raw} )"
        printf '%s\n' "${parsed[@]}"
    else
        while IFS= read -r item; do
            [[ -n "${item}" ]] && printf '%s\n' "${item}"
        done <<< "${selected_raw}"
    fi
}

expand_all_selection() {
    local item
    local -a scripts=( "$@" )
    local -a expanded=()
    local all_selected=false

    for item in "${scripts[@]}"; do
        if [[ "${item}" == "${ALL_OPTION}" ]]; then
            all_selected=true
            break
        fi
    done

    if [[ "${all_selected}" == true ]]; then
        collect_scripts
    else
        printf '%s\n' "${scripts[@]}"
    fi
}

run_selected_scripts() {
    local script

    for script in "$@"; do
        log_subsection "Running ${script}"
        bash "${SCRIPTS_DIR}/${script}"
    done
}

main() {
    local dialog_bin
    local selected_raw

    local -a scripts=()
    local -a menu_items=()
    local -a selected=()
    local -a expanded_selected=()

    mapfile -t scripts < <(collect_scripts)

    dialog_bin="$(get_dialog_bin)"
    [[ -n "${dialog_bin}" ]] || { log_warn "dialog or whiptail required"; exit 1; }

    (( ${#scripts[@]} > 0 )) || {
        log_warn "No scripts found in ${SCRIPTS_DIR}"
        exit 1
    }

    mapfile -t menu_items < <(build_menu_items "${scripts[@]}")

    selected_raw="$(show_checklist "${dialog_bin}" "${menu_items[@]}")" || exit 0

    mapfile -t selected < <(parse_selected_items "${dialog_bin}" "${selected_raw}")

    (( ${#selected[@]} > 0 )) || {
        log_warn "No scripts selected"
        exit 0
    }

    mapfile -t expanded_selected < <(expand_all_selection "${selected[@]}")

    (( ${#expanded_selected[@]} > 0 )) || {
        log_warn "No scripts selected"
        exit 0
    }

    run_selected_scripts "${expanded_selected[@]}"
}

main "$@"