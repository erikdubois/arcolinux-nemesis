#!/bin/bash
set -eo pipefail

##################################################################################################################
# Disable systemd-oomd on a running system
# Author: Erik Dubois
# Usage: sudo ./disable-oomd.sh [--remove-package]
# Options:
#   --remove-package    Also uninstall the systemd-oomd package
##################################################################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

REMOVE_PACKAGE=false

error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

success() {
    echo -e "${GREEN}✓ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

info() {
    echo -e "${YELLOW}ℹ $1${NC}"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --remove-package)
            REMOVE_PACKAGE=true
            shift
            ;;
        *)
            error "Unknown option: $1"
            ;;
    esac
done

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root (use sudo)"
fi

echo "======================================================================"
echo "systemd-oomd Removal Script"
echo "======================================================================"
echo

if [ "$REMOVE_PACKAGE" = true ]; then
    info "Package removal enabled - systemd-oomd will be uninstalled"
else
    info "Package will NOT be removed (use --remove-package to remove)"
fi
echo

# Check if systemd-oomd is installed
info "Checking systemd-oomd status..."
if ! command -v systemd-oomd &> /dev/null; then
    warning "systemd-oomd command not found - may not be properly installed"
fi

# Stop the service
info "Stopping systemd-oomd service..."
if systemctl is-active --quiet systemd-oomd.service 2>/dev/null; then
    systemctl stop systemd-oomd.service
    success "systemd-oomd.service stopped"
else
    warning "systemd-oomd.service not running"
fi

# Disable the service and socket
info "Disabling systemd-oomd..."
systemctl disable systemd-oomd.service 2>/dev/null || warning "Could not disable systemd-oomd.service"
systemctl disable systemd-oomd.socket 2>/dev/null || warning "Could not disable systemd-oomd.socket"
systemctl daemon-reload
success "systemd-oomd disabled and service cache reloaded"

echo

# Remove configuration files
info "Removing systemd-oomd configuration files..."

CONFIG_FILES=(
    "/etc/systemd/oomd.conf"
    "/etc/systemd/oomd.conf.d/*"
    "/etc/systemd/system/system.slice.d/oomd.conf"
    "/etc/systemd/system/user.slice.d/oomd.conf"
    "/etc/systemd/user/user-*.slice.d/oomd.conf"
)

REMOVED_COUNT=0
for config_file in "${CONFIG_FILES[@]}"; do
    # Use find to handle wildcards
    while IFS= read -r file; do
        if [ -n "$file" ] && [ -f "$file" ]; then
            rm -f "$file"
            success "Removed: $file"
            ((REMOVED_COUNT++))
        fi
    done < <(find $(dirname "$config_file" 2>/dev/null) -maxdepth 1 -name "$(basename "$config_file")" 2>/dev/null)
done

if [ $REMOVED_COUNT -gt 0 ]; then
    success "Removed $REMOVED_COUNT configuration file(s)"
else
    warning "No oomd configuration files found to remove"
fi

echo

# Optionally remove the package
if [ "$REMOVE_PACKAGE" = true ]; then
    info "Removing systemd-oomd package..."

    # Check if systemd-oomd is installed
    if pacman -Qi systemd &> /dev/null; then
        warning "systemd-oomd is part of the 'systemd' package and cannot be removed separately"
        info "To disable oomd, restart the system or run: systemctl restart systemd-oomd"
    else
        warning "systemd package not found"
    fi
else
    info "Skipping package removal (systemd-oomd is part of 'systemd' package)"
fi

echo

# Remove memory accounting if no longer needed (optional)
info "Checking memory accounting configuration..."
MEMACCT_FILE="/etc/systemd/system.conf.d/90-memory-accounting.conf"
if [ -f "$MEMACCT_FILE" ]; then
    warning "Memory accounting configuration file exists:"
    warning "  $MEMACCT_FILE"
    info "This can be safely removed if not needed by other services"
fi

echo

# Verify removal
info "Verifying systemd-oomd removal..."
echo

if systemctl is-enabled --quiet systemd-oomd.service 2>/dev/null; then
    warning "systemd-oomd.service is still enabled (unexpected)"
else
    success "systemd-oomd.service is disabled"
fi

if systemctl is-active --quiet systemd-oomd.service 2>/dev/null; then
    warning "systemd-oomd.service is still running"
else
    success "systemd-oomd.service is not running"
fi

echo
echo "======================================================================"
echo "systemd-oomd Removal Complete!"
echo "======================================================================"
echo

# Show summary
echo "Summary of changes:"
echo "  • systemd-oomd service: STOPPED & DISABLED"
echo "  • Configuration files: REMOVED"

if [ "$REMOVE_PACKAGE" = true ]; then
    echo "  • Package removal: SKIPPED (systemd-oomd is part of 'systemd')"
else
    echo "  • Package: NOT REMOVED"
fi

echo
echo "To completely disable oomd after reboot:"
echo "  systemctl mask systemd-oomd.service systemd-oomd.socket"
echo
echo "To re-enable oomd later:"
echo "  sudo ./enable-oomd.sh"
echo
