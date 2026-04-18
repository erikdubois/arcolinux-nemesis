#!/usr/bin/env bash

##################################################################################################################
# Test Validation Script for ArcoLinux Nemesis
#
# Purpose: Parse each script and verify system state without installing or removing anything.
#
# Usage:
#   bash test-validation.sh           # Summary: list scripts and check counts
#   bash test-validation.sh --detail  # Full line-by-line check for every operation
##################################################################################################################

WORKING_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PERSONAL_DIR="${WORKING_DIR}/personal"
REPORT_FILE="${WORKING_DIR}/test-report.txt"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

DETAIL_MODE=false
[[ "${1:-}" == "--detail" ]] && DETAIL_MODE=true

# Global counters
total_checks=0
success_count=0
failure_count=0

##################################################################################################################
# Result helpers
##################################################################################################################

log_result() {
    local status="$1"
    local description="$2"
    total_checks=$((total_checks + 1))
    if [[ "$status" == "SUCCESS" ]]; then
        success_count=$((success_count + 1))
        if [[ "$DETAIL_MODE" == true ]]; then
            echo -e "  ${GREEN}✓${NC} ${description}  ${GREEN}SUCCESS${NC}"
        fi
        echo "  [✓ SUCCESS] $description" >> "$REPORT_FILE"
    else
        failure_count=$((failure_count + 1))
        if [[ "$DETAIL_MODE" == true ]]; then
            echo -e "  ${RED}✗${NC} ${description}  ${RED}FAILED${NC}"
        fi
        echo "  [✗ FAILED]  $description" >> "$REPORT_FILE"
    fi
}

##################################################################################################################
# Conditional package guards — packages only relevant when a DE is present
##################################################################################################################

XFCE_ONLY_PKGS=("menulibre" "mugshot")

is_xfce_installed() {
    [[ -f /usr/share/xsessions/xfce.desktop ]]
}

pkg_should_skip() {
    local pkg="$1"
    local p
    for p in "${XFCE_ONLY_PKGS[@]}"; do
        if [[ "$pkg" == "$p" ]] && ! is_xfce_installed; then
            return 0
        fi
    done
    return 1
}

##################################################################################################################
# System state checks
##################################################################################################################

check_pkg_installed() {
    local pkg="$1"
    if pkg_should_skip "$pkg"; then
        if [[ "$DETAIL_MODE" == true ]]; then
            echo -e "  ${YELLOW}⊘${NC} install $pkg  ${YELLOW}SKIPPED${NC} (xfce4 not installed)"
        fi
        return
    fi
    local git_variant="${pkg}-git"
    if pacman -Qq | grep -Fxq "$pkg"; then
        log_result "SUCCESS" "install $pkg"
    elif pacman -Qq | grep -Fxq "$git_variant"; then
        log_result "SUCCESS" "install $pkg (via $git_variant)"
    else
        log_result "FAILED"  "install $pkg - not found"
    fi
}

check_pkg_removed() {
    local pkg="$1"
    if ! pacman -Qq | grep -Fxq "$pkg"; then
        log_result "SUCCESS" "$pkg - not present"
    else
        log_result "FAILED"  "$pkg - still installed (should be removed)"
    fi
}

check_backup_file() {
    local src="$1"
    local dst="$2"
    local label
    label="backup $(basename "$src") → $(basename "$dst")"
    if [[ -f "$dst" ]]; then
        log_result "SUCCESS" "$label"
    else
        log_result "FAILED"  "$label - backup missing at $dst"
    fi
}

check_service_active() {
    local svc="$1"
    if systemctl is-active --quiet "$svc" 2>/dev/null; then
        log_result "SUCCESS" "service $svc - active"
    else
        log_result "FAILED"  "service $svc - not active"
    fi
}

check_dir_exists() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        log_result "SUCCESS" "dir $dir"
    else
        log_result "FAILED"  "dir $dir - missing"
    fi
}

check_service_enabled() {
    local svc="$1"
    if systemctl is-enabled --quiet "$svc" 2>/dev/null; then
        log_result "SUCCESS" "service $svc - enabled"
    else
        log_result "FAILED"  "service $svc - not enabled"
    fi
}

##################################################################################################################
# Script parsers — read each script and extract operations
##################################################################################################################

# Extract all packages from install_packages blocks.
# Handles two patterns:
#   1. install_packages pkg1 pkg2 \  (inline / backslash continuation)
#   2. local pkgs=( ... ) + install_packages "${pkgs[@]}"  (array pattern)
parse_install_packages() {
    local script="$1"
    awk '
        # Array definition start: local pkgs=(
        /local pkgs[[:space:]]*=\s*\(/ {
            in_array = 1
            array_count = 0
            delete pkgs_arr
            next
        }
        # Array definition end
        in_array && /^[[:space:]]*\)/ {
            in_array = 0
            next
        }
        # Collect array items
        in_array {
            line = $0
            gsub(/^[[:space:]]+/, "", line)
            gsub(/[[:space:]]+$/, "", line)
            if (line != "" && line !~ /^#/) pkgs_arr[array_count++] = line
            next
        }
        # install_packages called with array: output collected items
        /install_packages.*\$\{pkgs\[@\]\}/ {
            for (i = 0; i < array_count; i++) print pkgs_arr[i]
            next
        }
        # install_packages called with inline args (backslash continuation)
        /install_packages/ {
            in_inline = 1
            line = $0
            sub(/.*install_packages[[:space:]]*/, "", line)
            sub(/[[:space:]]*\\[[:space:]]*$/, "", line)
            gsub(/^[[:space:]]+/, "", line)
            # Skip bash variable expansions like "${pkg}" or "$pkg"
            if (line != "" && line !~ /^\$/ && line !~ /^"?\$\{/) print line
            if ($0 !~ /\\$/) in_inline = 0
            next
        }
        in_inline {
            line = $0
            sub(/[[:space:]]*\\[[:space:]]*$/, "", line)
            gsub(/^[[:space:]]+/, "", line)
            if (line != "" && line !~ /^#/ && line !~ /^\$/ && line !~ /^"?\$\{/) print line
            if ($0 !~ /\\$/) in_inline = 0
        }
    ' "$script" | tr ' ' '\n' | sed '/^[[:space:]]*$/d'
}

# Extract packages from remove_* function calls (single-line)
parse_remove_packages() {
    local script="$1"
    grep -E '^[[:space:]]*(remove_matching_packages|remove_matching_packages_deps|remove_matching_packages_deps_dd|remove_packages)[[:space:]]+' "$script" \
        | grep -v '^[[:space:]]*#' \
        | sed -E 's/^[[:space:]]*(remove_matching_packages_deps_dd|remove_matching_packages_deps|remove_matching_packages|remove_packages)[[:space:]]*//' \
        | sed "s/['\"]//g" \
        | xargs -n1
}

# Extract src/dst from backup_file_once calls
parse_backup_files() {
    local script="$1"
    grep -E '^[[:space:]]*backup_file_once[[:space:]]+' "$script" \
        | grep -v '^[[:space:]]*#' \
        | sed 's/^[[:space:]]*backup_file_once[[:space:]]*//'
}

# Extract services from start_service / systemctl enable
parse_services_started() {
    local script="$1"
    grep -E '^[[:space:]]*(start_service|sudo systemctl start)[[:space:]]+' "$script" \
        | grep -v '^[[:space:]]*#' \
        | sed -E 's/^[[:space:]]*(start_service|sudo systemctl start)[[:space:]]*//' \
        | sed "s/['\"]//g" \
        | xargs -n1
}

parse_services_enabled() {
    local script="$1"
    grep -E '^[[:space:]]*(enable_service|enable_now_service|sudo systemctl enable)[[:space:]]+' "$script" \
        | grep -v '^[[:space:]]*#' \
        | sed -E 's/^[[:space:]]*(enable_now_service|enable_service|sudo systemctl enable)[[:space:]]*//' \
        | sed "s/['\"]//g" \
        | xargs -n1
}

# Extract directories from local dirs=(...) arrays and direct mkdir -p calls.
# Expands ${HOME} to the actual home directory.
parse_create_dirs() {
    local script="$1"
    awk -v home="$HOME" '
        /local dirs[[:space:]]*=\s*\(/ { in_array = 1; next }
        in_array && /^[[:space:]]*\)/ { in_array = 0; next }
        in_array {
            line = $0
            gsub(/^[[:space:]]+/, "", line)
            gsub(/[[:space:]]+$/, "", line)
            gsub(/\$\{HOME\}/, home, line)
            gsub(/\$HOME/, home, line)
            gsub(/"/, "", line)
            if (line != "" && line !~ /^#/) print line
        }
        /sudo mkdir -p[[:space:]]+/ && !/\$/ {
            line = $0
            sub(/.*sudo mkdir -p[[:space:]]+/, "", line)
            gsub(/^[[:space:]]+/, "", line)
            gsub(/[[:space:]]+$/, "", line)
            gsub(/"/, "", line)
            if (line != "") print line
        }
    ' "$script"
}

# Extract files that are copied via copy_file / copy_file_user
parse_copied_files() {
    local script="$1"
    awk -v home="$HOME" '
        /copy_file[[:space:]]/ && !/for / && !/log_warn/ {
            # grab destination (third token after function name, handling multiline)
            if ($0 ~ /\\$/) { getline next_line; $0 = $0 " " next_line }
            match($0, /copy_file(_user)?[[:space:]]+"[^"]+"[[:space:]]+\\?[[:space:]]+"([^"]+)"/, arr)
            if (arr[2] != "") {
                dst = arr[2]
                gsub(/\$\{HOME\}/, home, dst)
                gsub(/\$HOME/, home, dst)
                print dst
            }
        }
    ' "$script"
}

##################################################################################################################
# Validate a single script
##################################################################################################################

validate_script() {
    local script_path="$1"
    local script_name
    script_name=$(basename "$script_path")
    local script_num
    script_num=$(echo "$script_name" | grep -oE '^[0-9]+' || echo "0")

    local script_total_before=$total_checks
    local script_success_before=$success_count
    local script_fail_before=$failure_count

    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}[${script_num}] ${script_name}${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    {
        echo ""
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "[${script_num}] ${script_name}"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    } >> "$REPORT_FILE"

    # Backup file checks
    while IFS= read -r args; do
        [[ -z "$args" ]] && continue
        src=$(echo "$args" | awk '{print $1}')
        dst=$(echo "$args" | awk '{print $2}')
        [[ -n "$src" && -n "$dst" ]] && check_backup_file "$src" "$dst"
    done < <(parse_backup_files "$script_path")

    # Remove checks
    while IFS= read -r pkg; do
        [[ -z "$pkg" ]] && continue
        check_pkg_removed "$pkg"
    done < <(parse_remove_packages "$script_path")

    # Install checks
    while IFS= read -r pkg; do
        [[ -z "$pkg" ]] && continue
        check_pkg_installed "$pkg"
    done < <(parse_install_packages "$script_path")

    # Directory checks
    while IFS= read -r dir; do
        [[ -z "$dir" ]] && continue
        check_dir_exists "$dir"
    done < <(parse_create_dirs "$script_path")

    # Copied file checks
    while IFS= read -r dst; do
        [[ -z "$dst" ]] && continue
        if [[ "$dst" == */ ]]; then
            log_result "$([[ -d "$dst" ]] && echo SUCCESS || echo FAILED)" "dir $dst"
        else
            if [[ -f "$dst" ]] || [[ -d "$dst" ]]; then
                log_result "SUCCESS" "copied → $dst"
            else
                log_result "FAILED"  "copied → $dst - missing"
            fi
        fi
    done < <(parse_copied_files "$script_path")

    # Service checks
    while IFS= read -r svc; do
        [[ -z "$svc" ]] && continue
        check_service_active "$svc"
    done < <(parse_services_started "$script_path")

    while IFS= read -r svc; do
        [[ -z "$svc" ]] && continue
        check_service_enabled "$svc"
    done < <(parse_services_enabled "$script_path")

    # Script-level summary
    local script_checks=$(( total_checks - script_total_before ))
    local script_pass=$(( success_count - script_success_before ))
    local script_fail=$(( failure_count - script_fail_before ))

    if [[ $script_checks -eq 0 ]]; then
        echo -e "  ${YELLOW}(no trackable operations found)${NC}"
    elif [[ "$DETAIL_MODE" == true ]]; then
        echo -e "  ${script_name}: ${GREEN}${script_pass} passed${NC} / ${RED}${script_fail} failed${NC} / ${script_checks} total"
    fi

    if [[ $script_checks -gt 0 ]]; then
        if [[ $script_fail -eq 0 ]]; then
            echo -e "  ${GREEN}SUCCESS${NC}"
        else
            echo -e "  ${RED}ERROR${NC} (${script_fail} failed / ${script_checks} total)"
        fi
    fi
}

##################################################################################################################
# Main
##################################################################################################################

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  ArcoLinux Nemesis - Test Validation      ${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "${YELLOW}Mode: $([ "$DETAIL_MODE" = true ] && echo "DETAIL (line-by-line)" || echo "SUMMARY")${NC}"
echo ""

{
    echo "============================================="
    echo "  Test Report - $(date '+%Y-%m-%d %H:%M:%S')"
    echo "============================================="
} > "$REPORT_FILE"

# All scripts in pipeline order (matching 0-current-choices.sh)
declare -a ALL_SCRIPTS=()

ALL_SCRIPTS+=("${WORKING_DIR}/0-current-choices.sh")

ON_PLASMA=false
[[ "${XDG_CURRENT_DESKTOP,,}" == *plasma* || "${XDG_CURRENT_DESKTOP,,}" == *kde* || "${DESKTOP_SESSION,,}" == *plasma* ]] && ON_PLASMA=true

for pattern in "100-*" "110-*" "130-*" "140-*" "150-*" "200-software-aur-repo*" "600-chadwm*"; do
    for script in "${WORKING_DIR}"/${pattern}; do
        [[ -f "$script" ]] && ALL_SCRIPTS+=("$script")
    done
done

if [[ "$ON_PLASMA" == true ]]; then
    for script in "${WORKING_DIR}"/500-plasma*; do
        [[ -f "$script" ]] && ALL_SCRIPTS+=("$script")
    done
else
    echo -e "${YELLOW}Skipping 500-plasma* (not running Plasma — XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP})${NC}"
fi

for pattern in "900-*" "910-*" "920-*" "930-*" "990-skel*" "999-last*"; do
    for script in "${PERSONAL_DIR}"/${pattern}; do
        [[ -f "$script" ]] && ALL_SCRIPTS+=("$script")
    done
done

echo -e "${YELLOW}Scripts to validate: ${#ALL_SCRIPTS[@]}${NC}"

for script_path in "${ALL_SCRIPTS[@]}"; do
    validate_script "$script_path"
done

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Final Summary${NC}"
echo -e "${BLUE}============================================${NC}"
echo -e "Total checks : ${total_checks}"
echo -e "${GREEN}Passed       : ${success_count}${NC}"
echo -e "${RED}Failed       : ${failure_count}${NC}"
echo ""
echo -e "${BLUE}Full report saved to: ${REPORT_FILE}${NC}"
echo ""
{
    echo ""
    echo "============================================="
    echo "  Final Summary"
    echo "============================================="
    echo "Total  : $total_checks"
    echo "Passed : $success_count"
    echo "Failed : $failure_count"
} >> "$REPORT_FILE"

##################################################################################################################
# Systemd service summary
##################################################################################################################

# Packages installed by the pipeline that have a service/timer not explicitly enabled by any script.
# Format: "package:service-or-timer"
PKG_SERVICE_MAP=(
    "smartmontools:smartd.service"
    "logrotate:logrotate.timer"
    "man-db:man-db.timer"
    "plocate:plocate-updatedb.timer"
    "cups:cups.service"
    "bluetooth:bluetooth.service"
    "avahi:avahi-daemon.service"
    "ananicy-cpp:ananicy-cpp.service"
    "ckb-next-git:ckb-next-daemon.service"
)

print_service_block() {
    local heading="$1"; shift
    local -n _svcs="$1"
    local svc_enabled_count=0
    local svc_missing_count=0
    local svc_skipped_count=0

    echo -e "${CYAN}  ${heading}${NC}"
    echo "  ${heading}" >> "$REPORT_FILE"

    for entry in "${_svcs[@]}"; do
        local pkg="${entry%%:*}"
        local svc="${entry##*:}"

        if ! pacman -Qq "$pkg" &>/dev/null; then
            echo -e "  ${YELLOW}⊘${NC} ${svc}  ${YELLOW}skipped${NC} (${pkg} not installed)"
            echo "  [⊘ skipped]  $svc ($pkg not installed)" >> "$REPORT_FILE"
            svc_skipped_count=$(( svc_skipped_count + 1 ))
            continue
        fi

        if systemctl is-enabled --quiet "$svc" 2>/dev/null; then
            echo -e "  ${GREEN}✓${NC} ${svc}  ${GREEN}enabled${NC}"
            echo "  [✓ enabled]  $svc" >> "$REPORT_FILE"
            svc_enabled_count=$(( svc_enabled_count + 1 ))
        else
            echo -e "  ${RED}✗${NC} ${svc}  ${RED}NOT enabled${NC}"
            echo "  [✗ missing]  $svc" >> "$REPORT_FILE"
            svc_missing_count=$(( svc_missing_count + 1 ))
        fi
    done

    echo ""
    echo -e "  Enabled : ${GREEN}${svc_enabled_count}${NC}  |  Not enabled : ${RED}${svc_missing_count}${NC}  |  Skipped : ${YELLOW}${svc_skipped_count}${NC}"
    {
        echo ""
        echo "  Enabled : $svc_enabled_count  |  Not enabled : $svc_missing_count  |  Skipped : $svc_skipped_count"
    } >> "$REPORT_FILE"
}

echo ""
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}  Systemd Services Summary${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

{
    echo ""
    echo "============================================="
    echo "  Systemd Services Summary"
    echo "============================================="
} >> "$REPORT_FILE"

# --- Section 1: services explicitly enabled by pipeline scripts ---
declare -A seen_services
declare -a pipeline_services=()

for script_path in "${ALL_SCRIPTS[@]}"; do
    while IFS= read -r svc; do
        [[ -z "$svc" ]] && continue
        if [[ -z "${seen_services[$svc]+_}" ]]; then
            seen_services[$svc]=1
            pipeline_services+=("$svc")
        fi
    done < <(grep -E '^[[:space:]]*(enable_now_service|sudo systemctl enable --now)[[:space:]]+' "$script_path" \
        | grep -v '^[[:space:]]*#' \
        | sed -E 's/^[[:space:]]*(enable_now_service|sudo systemctl enable --now)[[:space:]]*//' \
        | sed "s/['\"]//g" \
        | xargs -n1 2>/dev/null)
done

echo -e "${CYAN}  Explicitly enabled by scripts${NC}"
echo "  Explicitly enabled by scripts" >> "$REPORT_FILE"
exp_enabled=0; exp_missing=0; exp_skipped=0
for svc in "${pipeline_services[@]}"; do
    svc_name="${svc%.service}"
    pkg_found=false
    pacman -Qq "$svc_name" &>/dev/null && pkg_found=true
    pacman -Qq "${svc_name%-*}" &>/dev/null && pkg_found=true

    if systemctl is-enabled --quiet "$svc" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} ${svc}  ${GREEN}enabled${NC}"
        echo "  [✓ enabled]  $svc" >> "$REPORT_FILE"
        exp_enabled=$(( exp_enabled + 1 ))
    elif ! $pkg_found; then
        echo -e "  ${YELLOW}⊘${NC} ${svc}  ${YELLOW}skipped${NC} (package not installed)"
        echo "  [⊘ skipped]  $svc (package not installed)" >> "$REPORT_FILE"
        exp_skipped=$(( exp_skipped + 1 ))
    else
        echo -e "  ${RED}✗${NC} ${svc}  ${RED}NOT enabled${NC}"
        echo "  [✗ missing]  $svc" >> "$REPORT_FILE"
        exp_missing=$(( exp_missing + 1 ))
    fi
done
echo ""
echo -e "  Enabled : ${GREEN}${exp_enabled}${NC}  |  Not enabled : ${RED}${exp_missing}${NC}  |  Skipped : ${YELLOW}${exp_skipped}${NC}"
{ echo ""; echo "  Enabled : $exp_enabled  |  Not enabled : $exp_missing  |  Skipped : $exp_skipped"; } >> "$REPORT_FILE"

# --- Section 2: services from installed packages not covered by scripts ---
echo ""
declare -a implicit_services=()
for entry in "${PKG_SERVICE_MAP[@]}"; do
    pkg="${entry%%:*}"; svc="${entry##*:}"
    # Only include if NOT already tracked by the pipeline
    if [[ -z "${seen_services[$svc]+_}" ]]; then
        implicit_services+=("$entry")
    fi
done

if [[ ${#implicit_services[@]} -gt 0 ]]; then
    print_service_block "Package services not covered by scripts (potential oversights)" implicit_services
fi

echo ""

##################################################################################################################
# SMART Drive Health Summary
##################################################################################################################

print_smart_summary() {
    local device="$1"

    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE}  Drive Health: ${device}${NC}"
    echo -e "${BLUE}============================================${NC}"
    {
        echo ""
        echo "============================================="
        echo "  Drive Health: ${device}"
        echo "============================================="
    } >> "$REPORT_FILE"

    if ! command -v smartctl &>/dev/null; then
        echo -e "  ${YELLOW}smartctl not installed — skipping${NC}"
        return
    fi

    if [[ ! -b "$device" ]]; then
        echo -e "  ${YELLOW}${device} not found — skipping${NC}"
        return
    fi

    local raw
    raw=$(sudo smartctl -a "$device" 2>&1)

    # Model / type
    local model
    model=$(echo "$raw" | grep -E "^(Device Model|Model Number|Model Family):" | head -1 | sed 's/.*:[[:space:]]*//')
    echo -e "  Model        : ${CYAN}${model:-unknown}${NC}"

    # Overall health
    local health
    health=$(echo "$raw" | grep "overall-health self-assessment" | awk '{print $NF}')
    if [[ "$health" == "PASSED" ]]; then
        echo -e "  Health       : ${GREEN}PASSED${NC}"
    else
        echo -e "  Health       : ${RED}${health:-UNKNOWN}${NC}"
    fi

    # Temperature
    local temp
    temp=$(echo "$raw" | grep -E "^(190|194) " | awk '{print $NF}')
    [[ -z "$temp" ]] && temp=$(echo "$raw" | grep -i "^Temperature:" | awk '{print $2}')
    [[ -n "$temp" ]] && echo -e "  Temperature  : ${temp}°C"

    # Power-on hours
    local hours
    hours=$(echo "$raw" | grep -E "^  9 " | awk '{print $NF}')
    [[ -n "$hours" ]] && echo -e "  Power-on hrs : ${hours}"

    # Power cycle count
    local cycles
    cycles=$(echo "$raw" | grep -E "^  12 " | awk '{print $NF}')
    [[ -n "$cycles" ]] && echo -e "  Power cycles : ${cycles}"

    # Reallocated sectors — non-zero is a warning
    local realloc
    realloc=$(echo "$raw" | grep -E "^  5 " | awk '{print $NF}')
    if [[ -n "$realloc" ]]; then
        if [[ "$realloc" -eq 0 ]]; then
            echo -e "  Reallocated  : ${GREEN}${realloc}${NC}"
        else
            echo -e "  Reallocated  : ${RED}${realloc} ← WARNING${NC}"
        fi
    fi

    # Pending sectors
    local pending
    pending=$(echo "$raw" | grep -E "^197 " | awk '{print $NF}')
    if [[ -n "$pending" ]]; then
        if [[ "$pending" -eq 0 ]]; then
            echo -e "  Pending      : ${GREEN}${pending}${NC}"
        else
            echo -e "  Pending      : ${RED}${pending} ← WARNING${NC}"
        fi
    fi

    # Uncorrectable sectors
    local uncorr
    uncorr=$(echo "$raw" | grep -E "^198 " | awk '{print $NF}')
    if [[ -n "$uncorr" ]]; then
        if [[ "$uncorr" -eq 0 ]]; then
            echo -e "  Uncorrectable: ${GREEN}${uncorr}${NC}"
        else
            echo -e "  Uncorrectable: ${RED}${uncorr} ← WARNING${NC}"
        fi
    fi

    # NVMe: percentage used + available spare
    local pct_used spare
    pct_used=$(echo "$raw" | grep "Percentage Used:" | awk '{print $3}')
    spare=$(echo "$raw" | grep "Available Spare:" | head -1 | awk '{print $3}')
    [[ -n "$pct_used" ]] && echo -e "  NVMe used    : ${pct_used}"
    [[ -n "$spare"    ]] && echo -e "  Spare left   : ${spare}"

    echo ""
    echo "$raw" | grep -E "(overall-health|Temperature|Power_On|Reallocated|Pending|Uncorrectable|Percentage Used|Available Spare)" \
        >> "$REPORT_FILE"
}

# Auto-detect all physical drives (excludes loop, ram, partitions)
mapfile -t DRIVES < <(lsblk -dn -o NAME,TYPE | awk '$2=="disk" && $1 !~ /^zram/{print "/dev/"$1}')

if [[ ${#DRIVES[@]} -eq 0 ]]; then
    echo -e "  ${YELLOW}No drives detected — skipping SMART summary${NC}"
else
    for drive in "${DRIVES[@]}"; do
        print_smart_summary "$drive"
    done
fi

echo ""
