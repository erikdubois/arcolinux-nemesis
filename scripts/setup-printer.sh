#!/usr/bin/env bash
# setup-printer.sh
# Discover and add a printer to CUPS on Arch Linux.

set -euo pipefail

R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'
C='\033[0;36m'; W='\033[1;37m'; NC='\033[0m'

header() { echo -e "\n${C}${W}$*${NC}"; }
ok()     { echo -e "${G}✔ $*${NC}"; }
err()    { echo -e "${R}✘ $*${NC}" >&2; }
ask()    { echo -e "${Y}$*${NC}"; }

# ── ensure CUPS is running ────────────────────────────────────────────────────
header "Checking CUPS..."
if ! systemctl is-active --quiet cups; then
    ask "CUPS is not running. Start it? [Y/n]:"
    read -rp "> " ans
    if [[ ! "$ans" =~ ^[Nn]$ ]]; then
        sudo systemctl enable --now cups
        sleep 2
    else
        err "CUPS must be running to add a printer."
        exit 1
    fi
fi
ok "CUPS is running"

# ── discover devices ─────────────────────────────────────────────────────────
header "Scanning for printers (this may take a few seconds)..."
mapfile -t raw < <(lpinfo -v 2>/dev/null | grep -E "^network (ipp|ipps|dnssd|socket)|^usb" || true)

if [[ ${#raw[@]} -eq 0 ]]; then
    err "No printers found. Make sure your printer is on and on the same network."
    exit 1
fi

# build display list and uri list in parallel arrays
display=()
uris=()
for line in "${raw[@]}"; do
    uri="${line#* }"
    # friendly label: strip URL noise for readability
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

# ── let user pick ─────────────────────────────────────────────────────────────
header "Found ${#display[@]} printer(s):"
for i in "${!display[@]}"; do
    printf "  %2d) %s\n" $((i+1)) "${display[$i]}"
done
echo

ask "Select a printer [1-${#display[@]}]:"
read -rp "> " pick
if ! [[ "$pick" =~ ^[0-9]+$ ]] || (( pick < 1 || pick > ${#uris[@]} )); then
    err "Invalid selection."
    exit 1
fi
selected_uri="${uris[$((pick-1))]}"

# ── printer name ──────────────────────────────────────────────────────────────
default_name=$(echo "$selected_uri" | sed \
    -e 's|dnssd://||' \
    -e 's|%20|_|g' \
    -e 's|\._.*||' \
    -e 's|ipp[s]*://||' \
    -e 's|socket://||' \
    -e 's|[^a-zA-Z0-9_].*||')

ask "Printer name [default: $default_name]:"
read -rp "> " pname
pname="${pname:-$default_name}"
pname="${pname// /_}"

# ── try to add with ipps, fall back to ipp ───────────────────────────────────
header "Adding printer '$pname'..."

add_printer() {
    local uri="$1"
    lpadmin -p "$pname" -v "$uri" -m everywhere -E 2>&1
}

# if dnssd or ipps uri — try as-is first, then swap to plain ipp on local IP
if lpadmin -p "$pname" -v "$selected_uri" -m everywhere -E 2>/dev/null; then
    ok "Added via $selected_uri"
else
    # extract IP from socket:// fallback or resolve from dnssd
    fallback_ip=$(lpinfo -v 2>/dev/null | grep "^network socket://" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)
    if [[ -n "$fallback_ip" ]]; then
        fallback_uri="ipp://${fallback_ip}/ipp/print"
        ask "Secure connection failed. Trying plain IPP at $fallback_uri ..."
        if lpadmin -p "$pname" -v "$fallback_uri" -m everywhere -E 2>/dev/null; then
            ok "Added via $fallback_uri"
        else
            err "Could not add printer. Try installing a specific driver (e.g. cnijfilter2 from AUR)."
            exit 1
        fi
    else
        err "Could not add printer. No fallback IP found."
        exit 1
    fi
fi

# ── set as default ────────────────────────────────────────────────────────────
ask "Set '$pname' as default printer? [Y/n]:"
read -rp "> " ans
if [[ ! "$ans" =~ ^[Nn]$ ]]; then
    lpoptions -d "$pname"
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
