#!/usr/bin/env bash

##################################################################################################################
# Author    : Erik Dubois
# Website   : https://www.erikdubois.be
# Youtube   : https://youtube.com/erikdubois
# Github    : https://github.com/erikdubois
# Github    : https://github.com/kirodubes
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
#   Purpose:
#   Discover and add a printer to CUPS on Arch Linux — driverless (IPP Everywhere).
#   Clears the two things that usually stop a network printer being found:
#     - avahi-daemon not running (mDNS/dnssd discovery needs it)
#     - a firewall (firewalld / ufw) blocking mDNS (UDP 5353)
#   Falls back to manual IP entry when discovery still returns nothing.
#
##################################################################################################################

set -euo pipefail

R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'
C='\033[0;36m'; W='\033[1;37m'; NC='\033[0m'

header() { echo -e "\n${C}${W}$*${NC}"; }
ok()     { echo -e "${G}✔ $*${NC}"; }
warn()   { echo -e "${Y}! $*${NC}"; }
err()    { echo -e "${R}✘ $*${NC}" >&2; }
ask()    { echo -e "${Y}$*${NC}"; }

# ── ensure a systemd service is up (offer to start it) ────────────────────────
ensure_service() {
    local svc="$1" label="$2"
    if systemctl is-active --quiet "$svc"; then
        ok "$label is running"
        return 0
    fi
    ask "$label is not running. Start and enable it? [Y/n]:"
    read -rp "> " ans
    if [[ "$ans" =~ ^[Nn]$ ]]; then
        warn "$label left stopped — discovery may not work"
        return 1
    fi
    sudo systemctl enable --now "$svc"
    sleep 1
    ok "$label started"
}

# ── open the firewall for printer discovery + printing ────────────────────────
open_firewall_for_printing() {
    # firewalld
    if systemctl is-active --quiet firewalld; then
        header "Opening firewalld for printing (mDNS + IPP)..."
        local s
        for s in mdns ipp ipp-client; do
            sudo firewall-cmd --permanent --add-service="$s" >/dev/null 2>&1 || true
        done
        sudo firewall-cmd --reload >/dev/null 2>&1 || true
        ok "firewalld: mdns + ipp allowed"
        return 0
    fi

    # ufw
    if command -v ufw >/dev/null 2>&1 && sudo ufw status 2>/dev/null | grep -q "Status: active"; then
        header "Opening ufw for printing (mDNS + IPP)..."
        sudo ufw allow 5353/udp >/dev/null 2>&1 || true   # mDNS discovery
        sudo ufw allow 631 >/dev/null 2>&1 || true        # IPP
        ok "ufw: 5353/udp + 631 allowed"
        return 0
    fi

    ok "No active firewall to adjust"
}

# ── discover printers via CUPS ────────────────────────────────────────────────
scan_printers() {
    # Only real device URIs (must contain ://) — drops the bare backend stubs
    # (e.g. "network ipp", "network socket") that are not actual printers.
    mapfile -t raw < <(lpinfo -v 2>/dev/null \
        | grep -E "^(network|direct) (dnssd|ipp|ipps|socket|usb)://" || true)
    order_printers
}

# Present the most reliable choice first: dnssd (mDNS — survives DHCP IP changes and is the
# driverless default) → ipps → ipp → socket → usb.
order_printers() {
    local ordered=() proto line
    for proto in dnssd ipps ipp socket usb; do
        for line in "${raw[@]}"; do
            [[ "$line" == *" ${proto}://"* ]] && ordered+=("$line")
        done
    done
    (( ${#ordered[@]} )) && raw=("${ordered[@]}")
}

# ── add a printer driverless, with a plain-ipp fallback ───────────────────────
add_printer() {
    local pname="$1" uri="$2"
    if sudo lpadmin -p "$pname" -v "$uri" -m everywhere -E 2>/dev/null; then
        ok "Added '$pname' via $uri"
        return 0
    fi
    return 1
}

# ── main ──────────────────────────────────────────────────────────────────────
header "Preparing the system for printer discovery..."
ensure_service cups          "CUPS"          || { err "CUPS must run to add a printer."; exit 1; }
ensure_service avahi-daemon  "avahi-daemon"  || true
open_firewall_for_printing

header "Scanning for printers (this may take a few seconds)..."
sleep 2   # give avahi a moment to populate after enabling it / opening the firewall
scan_printers

# If nothing showed up, retry once more after a longer settle.
if [[ ${#raw[@]} -eq 0 ]]; then
    warn "Nothing found yet — waiting for mDNS to settle and retrying..."
    sleep 4
    scan_printers
fi

selected_uri=""

if [[ ${#raw[@]} -gt 0 ]]; then
    display=(); uris=()
    for line in "${raw[@]}"; do
        uri="${line#* }"
        label=$(echo "$uri" | sed \
            -e 's|dnssd://||' \
            -e 's|%20| |g' \
            -e 's|\._ipp\._tcp\.local.*||' \
            -e 's|\._ipps\._tcp\.local.*||' \
            -e 's|ipp[s]*://||' \
            -e 's|socket://||' \
            -e 's|/ipp/print||' \
            -e 's|/.*||')
        proto=$(echo "$uri" | grep -oE '^[a-z]+')
        display+=("[$proto]  $label  →  $uri")
        uris+=("$uri")
    done

    header "Found ${#display[@]} printer(s):"
    for i in "${!display[@]}"; do
        printf "  %2d) %s\n" $((i+1)) "${display[$i]}"
    done
    printf "  %2d) %s\n" 0 "Enter a printer IP manually"
    echo

    ask "Select a printer [default 1, 1-${#display[@]}, or 0 for manual]:"
    read -rp "> " pick
    pick="${pick:-1}"
    if [[ "$pick" =~ ^[0-9]+$ ]] && (( pick >= 1 && pick <= ${#uris[@]} )); then
        selected_uri="${uris[$((pick-1))]}"
    elif [[ "$pick" != "0" ]]; then
        err "Invalid selection."
        exit 1
    fi
else
    warn "No printers discovered automatically (printer off, not on this subnet, or still firewalled)."
fi

# ── manual IP fallback ────────────────────────────────────────────────────────
if [[ -z "$selected_uri" ]]; then
    ask "Enter the printer's IP address (e.g. 192.168.1.50):"
    read -rp "> " printer_ip
    if ! [[ "$printer_ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        err "That is not a valid IPv4 address."
        exit 1
    fi
    selected_uri="ipp://${printer_ip}/ipp/print"
fi

# ── printer name ──────────────────────────────────────────────────────────────
default_name=$(echo "$selected_uri" | sed \
    -e 's|dnssd://||' \
    -e 's|%20|_|g' \
    -e 's|\._.*||' \
    -e 's|ipp[s]*://||' \
    -e 's|socket://||' \
    -e 's|[^a-zA-Z0-9_].*||')
[[ -z "$default_name" ]] && default_name="network_printer"

ask "Printer name [default: $default_name]:"
read -rp "> " pname
pname="${pname:-$default_name}"
pname="${pname// /_}"

# ── add (try selected URI, then plain ipp on the same host) ───────────────────
header "Adding printer '$pname'..."
if ! add_printer "$pname" "$selected_uri"; then
    host=$(echo "$selected_uri" | sed -E 's|^[a-z]+://||; s|[/:].*||')
    fallback_uri="ipp://${host}/ipp/print"
    warn "First attempt failed — trying plain IPP at $fallback_uri ..."
    if ! add_printer "$pname" "$fallback_uri"; then
        err "Could not add the printer. If it is a very old model, a specific driver may be needed (e.g. cnijfilter2 from the AUR)."
        exit 1
    fi
fi

# ── set as default ────────────────────────────────────────────────────────────
ask "Set '$pname' as default printer? [Y/n]:"
read -rp "> " ans
if [[ ! "$ans" =~ ^[Nn]$ ]]; then
    lpoptions -d "$pname" >/dev/null
    ok "'$pname' is now the default printer"
fi

# ── test page ─────────────────────────────────────────────────────────────────
ask "Print a test page? [y/N]:"
read -rp "> " ans
if [[ "$ans" =~ ^[Yy]$ ]]; then
    lp -d "$pname" /usr/share/cups/data/testprint
    ok "Test page sent"
fi

header "Done!"
lpstat -p "$pname"
