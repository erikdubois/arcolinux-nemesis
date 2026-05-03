# CHANGELOG

## 2026.05.02

### What Changed

Fixed audio system: PulseAudio doesn't work with modern Spotify. Created [install-pipewire.sh](scripts/install-pipewire.sh) as the recommended audio backend (Arch default). Made both audio scripts symmetric so users can switch between PipeWire and PulseAudio. Enhanced [110-install-core-software.sh](110-install-core-software.sh) to safely skip plocate timer on systems where it's not enableable.

### Technical Details

- Spotify on modern Linux is hardcoded to use PipeWire (`pw.loop`); PulseAudio was breaking audio completely
- [install-pipewire.sh](scripts/install-pipewire.sh) cleanly removes PulseAudio and installs PipeWire + wireplumber. Installs and enables `pipewire-pulse` service for PulseAudio API compatibility (allows pavucontrol and PulseAudio-based apps to work). Removes stale `/etc/alsa/conf.d/99-pipewire-default.conf` that breaks ALSA when PipeWire is absent
- [install-pulseaudio.sh](scripts/install-pulseaudio.sh) enhanced to cleanly switch from PipeWire: stops/disables both `pipewire` and `pipewire-pulse` user services, removes PipeWire ALSA config, and removes all PipeWire packages before installing PulseAudio
- [110-install-core-software.sh](110-install-core-software.sh): plocate-updatedb.timer is a static unit on some systems and cannot be enabled via systemctl; added conditional check to skip enabling if unit state is static

### Files Modified

- [scripts/install-pipewire.sh](scripts/install-pipewire.sh) (updated with pipewire-pulse emulation)
- [scripts/install-pulseaudio.sh](scripts/install-pulseaudio.sh) (enhanced to properly switch from PipeWire)
- [110-install-core-software.sh](110-install-core-software.sh)

---

## 2026.05.01

### What Changed

Added `claude-code` AUR package installation to the AUR software script. Updated Chaotic AUR mirrorlist to the 2026-04-28 build.

### Technical Details

`install_aur_package claude-code` appended in [200-software-aur-repo.sh](200-software-aur-repo.sh) alongside the existing Opera AUR build. Two chaotic-mirrorlist package files present in `packages/` reflect the April→May mirrorlist refresh cycle.

### Files Modified

- [200-software-aur-repo.sh](200-software-aur-repo.sh)
- [mirrorlist](mirrorlist)
- [packages/chaotic-mirrorlist-20260406-1-any.pkg.tar.zst](packages/chaotic-mirrorlist-20260406-1-any.pkg.tar.zst)
- [packages/chaotic-mirrorlist-20260428-1-any.pkg.tar.zst](packages/chaotic-mirrorlist-20260428-1-any.pkg.tar.zst)

---

## 2026.04.26

### What Changed

Updated mirrorlist.

### Technical Details

Routine mirrorlist refresh.

### Files Modified

- [mirrorlist](mirrorlist)

---

## 2026.04.24

### What Changed

Updated chadwm configuration and SDDM KDE settings.

### Technical Details

Changes to [600-chadwm.sh](600-chadwm.sh) and the SDDM config at `personal/settings/sddm/kde_settings.conf`. Mirrorlist also refreshed.

### Files Modified

- [600-chadwm.sh](600-chadwm.sh)
- [mirrorlist](mirrorlist)
- [personal/settings/sddm/kde_settings.conf](personal/settings/sddm/kde_settings.conf)

---

## 2026.04.23

### What Changed

Extended chadwm support to Ubuntu and Linux Mint. Built out a "voyage of chadwm" collection — full chadwm install scripts for Ubuntu and Mint, covering dotfiles, sxhkdrc keybindings, picom config, alacritty config, and bar/run scripts.

### Technical Details

New directory structure under `personal/settings/voyage-of-chadwm/` with separate `ubuntu-chadwm/` and `mint-chadwm/` subtrees. Each contains an `install-chadwm.sh` orchestrator plus config subdirectories for both `arco-chadwm` and `ohmychadwm` variants. Alacritty configs use the `.toml` format.

### Files Modified

- [personal/settings/voyage-of-chadwm/ubuntu-chadwm/install-chadwm.sh](personal/settings/voyage-of-chadwm/ubuntu-chadwm/install-chadwm.sh)
- [personal/settings/voyage-of-chadwm/ubuntu-chadwm/dotfiles/alacritty/alacritty.toml](personal/settings/voyage-of-chadwm/ubuntu-chadwm/dotfiles/alacritty/alacritty.toml)
- [personal/settings/voyage-of-chadwm/mint-chadwm/install-chadwm.sh](personal/settings/voyage-of-chadwm/mint-chadwm/install-chadwm.sh)
- [personal/settings/voyage-of-chadwm/mint-chadwm/ohmychadwm/](personal/settings/voyage-of-chadwm/mint-chadwm/ohmychadwm/) (alacritty.toml, picom.conf, run.sh, sxhkdrc, uca.xml)
- [personal/settings/voyage-of-chadwm/mint-chadwm/arco-chadwm/](personal/settings/voyage-of-chadwm/mint-chadwm/arco-chadwm/) (bar.sh, config.def.h, picom.conf, run.sh, sxhkdrc, uca.xml)
- [mirrorlist](mirrorlist)

---

## 2026.04.21

### What Changed

Added Mint chadwm app installation scripts (PPA and Snap variants). Updated core software list and mirrorlist.

### Technical Details

Two new scripts: `install-apps-ppa.sh` (PPA-sourced apps for Mint chadwm) and `install-apps-snap.sh` (Snap-sourced apps). Core software script [110-install-core-software.sh](110-install-core-software.sh) updated.

### Files Modified

- [personal/settings/voyage-of-chadwm/mint-chadwm/install-apps-ppa.sh](personal/settings/voyage-of-chadwm/mint-chadwm/install-apps-ppa.sh)
- [personal/settings/voyage-of-chadwm/mint-chadwm/install-apps-snap.sh](personal/settings/voyage-of-chadwm/mint-chadwm/install-apps-snap.sh)
- [110-install-core-software.sh](110-install-core-software.sh)
- [mirrorlist](mirrorlist)
