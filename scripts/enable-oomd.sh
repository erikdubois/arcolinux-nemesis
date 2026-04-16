#!/bin/bash
set -eo pipefail

##################################################################################################################
# Enable systemd-oomd on a running system
# Author: Erik Dubois
# Usage: sudo ./enable-oomd.sh
##################################################################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

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

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    error "This script must be run as root (use sudo)"
fi

echo "======================================================================"
echo "systemd-oomd Setup Script"
echo "======================================================================"
echo

# Check prerequisites
info "Checking system requirements..."

# Check for cgroups-v2
if ! grep -q "cgroup2" /proc/filesystems; then
    error "cgroups-v2 not available. Kernel must support unified cgroup hierarchy"
fi
success "cgroups-v2 available"

# Check for PSI support
if [ ! -f /proc/pressure/memory ]; then
    error "PSI (Pressure Stall Information) not available. Requires Linux 4.20+"
fi
success "PSI support available"

# Check if swap is enabled
SWAP_TOTAL=$(free | grep Swap | awk '{print $2}')
if [ "$SWAP_TOTAL" -eq 0 ]; then
    warning "Swap not detected. oomd works better with swap enabled"
else
    success "Swap is enabled"
fi

echo

# Enable memory accounting
info "Configuring memory accounting..."
mkdir -p /etc/systemd/system.conf.d

cat > /etc/systemd/system.conf.d/90-memory-accounting.conf <<'EOF'
[Manager]
DefaultMemoryAccounting=true
DefaultSwapAccounting=true
EOF

success "Memory accounting enabled"

# Create/update oomd.conf with correct settings
info "Configuring oomd.conf..."
cat > /etc/systemd/oomd.conf <<'EOF'
[OOM]
# Systemd-oomd memory pressure monitoring and OOM handling

# Threshold: only act when memory pressure exceeds 60% (default)
DefaultMemoryPressureLimit=60%

# How long to observe memory pressure before taking action
# 20 seconds = better balance between responsiveness and stability
DefaultMemoryPressureDurationSec=20s
EOF
success "oomd.conf configured"

# Configure system.slice monitoring
info "Configuring slice monitoring..."
mkdir -p /etc/systemd/system/system.slice.d

cat > /etc/systemd/system/system.slice.d/oomd.conf <<'EOF'
[Slice]
# Monitor system slice memory pressure (responsive)
ManagedOOMMemoryPressure=kill
# Disable swap-based killing - let swap handle overflow gracefully
# ManagedOOMSwap=kill
EOF

success "system.slice monitoring configured"

# Configure user.slice monitoring
mkdir -p /etc/systemd/system/user.slice.d

cat > /etc/systemd/system/user.slice.d/oomd.conf <<'EOF'
[Slice]
# Monitor user slice memory pressure (responsive)
ManagedOOMMemoryPressure=kill
# Disable swap-based killing - let swap handle overflow gracefully
# ManagedOOMSwap=kill
EOF

success "user.slice monitoring configured"

echo

# Enable and start the service
info "Enabling systemd-oomd service..."
systemctl daemon-reload
systemctl enable systemd-oomd.service
systemctl enable systemd-oomd.socket
systemctl start systemd-oomd.service

success "systemd-oomd enabled and started"

echo

# Verify installation
info "Verifying installation..."
echo

# Check service status
if systemctl is-active --quiet systemd-oomd.service; then
    success "systemd-oomd.service is running"
else
    error "systemd-oomd.service failed to start"
fi

# Check socket status
if systemctl is-active --quiet systemd-oomd.socket; then
    success "systemd-oomd.socket is active"
else
    warning "systemd-oomd.socket is not active (will activate on first use)"
fi

echo

# Show status
info "Showing systemd-oomd status:"
systemctl status systemd-oomd.service --no-pager

echo
echo "======================================================================"
echo "systemd-oomd Setup Complete!"
echo "======================================================================"
echo
echo "To monitor oomd activity:"
echo "  journalctl -u systemd-oomd.service -f"
echo
echo "To test with memory pressure:"
echo "  stress-ng --vm 1 --vm-bytes 85% --timeout 30s"
echo
echo "To check monitored cgroups:"
echo "  oomctl"
echo
