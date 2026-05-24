# CHANGELOG

## 2026.05.24

### What Changed

Full chadwm de-brand, triggered by `edu-chadwm` renaming its desktop config folder `arco-chadwm` → `chadwm` (Kiro de-brand). Two parts:

1. **Arch installers (functional fix)** — `arcolinux-desktops/chadwm.sh` and `ohmychadwm.sh` broke because they copied the now-gone `/etc/skel/.config/arco-chadwm`.
2. **Cross-distro `voyage-of-chadwm` migration** — all 16 distro chadwm installers now use `~/.config/chadwm`, and the 13 that pulled the desktop from the upstream **`arcolinux/arcolinux-chadwm`** repo were switched to clone **`erikdubois/edu-chadwm`** instead. (Correcting an earlier note in this log: those 13 were *not* self-contained — they cloned the ArcoLinux upstream, which is why renaming required switching the clone source.)

### Technical Details

- `arcolinux-desktops/chadwm.sh` — copies `/etc/skel/.config/chadwm` (was `arco-chadwm`); the `edu-chadwm-git` package now ships that path.
- `arcolinux-desktops/ohmychadwm.sh` — was copying `/etc/skel/.config/arco-chadwm` (latent copy-paste bug in an ohmychadwm installer); now copies `/etc/skel/.config/ohmychadwm`, its own config.
- `voyage-of-chadwm` (16 subtrees): `arcolinux/arcolinux-chadwm` → `erikdubois/edu-chadwm` clone source (+ `/tmp/arcolinux-chadwm` → `/tmp/edu-chadwm`), and `arco-chadwm` → `chadwm` across install scripts, run.sh, bar.sh, sxhkdrc, and gtk bookmarks. The mint bundled override dir `mint-chadwm/arco-chadwm/` was `git mv`'d to `chadwm/`.
- Stripped the `arcolinux.* / alci.online / ariser.eu` Website URL header lines (kept `erikdubois.be`) from the chadwm entry scripts (`install-chadwm.sh`, `1-all-in-one.sh`).
- **Left for follow-up** (see TODO): the parallel `arcolinux/arcolinux-powermenu` → `edu-powermenu` migration, and stripping the same brand URL headers from the ~150 non-chadwm install scripts across voyage-of-chadwm.

### Files Modified

- arcolinux-desktops/chadwm.sh, arcolinux-desktops/ohmychadwm.sh
- personal/settings/voyage-of-chadwm/ — all 16 `*-chadwm/` subtrees (install scripts, run.sh, bar.sh, sxhkdrc, bookmarks; mint bundled dir renamed)

## 2026.05.21

### What Changed

Refreshed the saved ckb-next config in `personal/settings/ckb-next/` from the now-working live config, and simplified `personal/920-ckb-next.sh` to match how autostart actually works on Erik's ohmychadwm setup.

### Technical Details

- `personal/settings/ckb-next/ckb-next.conf` updated from 199 B (stub) to 127 KB (the live, dialled-in config with all RGB profiles and key remaps).
- Removed `personal/settings/ckb-next/ckb-next.autostart.desktop` — `~/.config/autostart/*.desktop` is dead code on ohmychadwm (bare WM, no XDG autostart). GUI autostart is handled by `ohmychadwm/scripts/run.sh` via `command -v ckb-next && ckb-next --background`, with hardware-tolerant `pgrep -x` guard.
- `920-ckb-next.sh`: dropped the `~/.config/autostart` mkdir and the `.desktop` copy. Added a `log_info` note that GUI autostart is handled by `ohmychadwm/scripts/run.sh`. Daemon service (`ckb-next-daemon.service`) still enabled as before. Script remains hardware-gated by `hwinfo --keyboard | grep -qi corsair`.

### Files Modified

- [personal/settings/ckb-next/ckb-next.conf](personal/settings/ckb-next/ckb-next.conf)
- [personal/settings/ckb-next/ckb-next.autostart.desktop](personal/settings/ckb-next/ckb-next.autostart.desktop) (deleted)
- [personal/920-ckb-next.sh](personal/920-ckb-next.sh)

---

### What Changed (later, same day)

Removed two scripts that collided with system-level configs now owned by `edu-system-files` (Kiro block). Cross-stack audit between this personal install repo and the Kiro `edu-system-files` block identified that nemesis was overwriting Kiro-tuned files; ownership moved to the Kiro side.

### Technical Details

- `scripts/install-zram.sh` deleted — was writing `/etc/systemd/zram-generator.conf` with `lz4` + uncapped `ram/2`. `edu-system-files` now ships this file with `zstd` + `min(ram/2, 4096)` cap. Kiro owns zram tuning.
- `scripts/enable-oomd.sh` deleted — was writing `/etc/systemd/system.conf.d/90-memory-accounting.conf` including the deprecated `DefaultSwapAccounting=true`. `edu-system-files` ships the correct file (memory accounting only). Kiro owns this.
- `scripts/disable-oomd.sh` deleted as a pair — its remaining purpose was to undo what enable-oomd.sh did; with the enable side gone and Kiro owning the memory-accounting config, the disable script no longer has a meaningful job.
- Audit results recorded in [Kiro-HQ/TODO.md](/home/erik/Insync/Kiro/Kiro-HQ/TODO.md) item closed.

### Files Modified

- [scripts/install-zram.sh](scripts/install-zram.sh) (deleted)
- [scripts/enable-oomd.sh](scripts/enable-oomd.sh) (deleted)
- [scripts/disable-oomd.sh](scripts/disable-oomd.sh) (deleted)

---

### What Changed (later, same day — describe-mode for the launcher)

Wired up a "describe what each script does" feature in `scripts/1-install-scripts.sh` so a user can preview what a script will do without running it or reading its bash. Backed by a new `# Purpose:` block convention in each script's header and a small parsing helper in `common/common.sh`. Two scripts updated as a pilot; the remaining 15 are tracked in TODO.md.

### Technical Details

- New helper `extract_purpose <script>` in [common/common.sh](common/common.sh) — awk-based parser that returns the bullets under a script's `# Purpose` (or `# Purpose:`) header. Exits cleanly on the next blank-comment line, banner separator (`^##+`), or non-comment line.
- [scripts/1-install-scripts.sh](scripts/1-install-scripts.sh) updated:
    - `build_menu_items` now fills the dialog description column with each script's first Purpose bullet (truncated to 60 chars).
    - New top-of-checklist option **"Describe selected scripts (don't run anything)"** alongside the existing "Install all scripts". When checked, prints each selected script's full Purpose block and exits without running anything; if checked alone (no scripts), describes all discovered scripts.
    - New helpers `describe_selected_scripts`, `is_describe_selected`, `filter_out_describe_and_all`.
- Purpose blocks added to 2 scripts as pilot: [100-install-nemesis-software.sh](100-install-nemesis-software.sh) (5 bullets) and [120-install-nemesis-icon-themes.sh](120-install-nemesis-icon-themes.sh) (3 bullets). 8 other scripts already had Purpose blocks from earlier; 15 still need one (tracked in [TODO.md](TODO.md)).
- Format convention: a `##############...` banner line, `# Purpose` (no colon needed) on its own line, then `# - bullet` lines, then a closing banner. Sits right after the standard `DO NOT JUST RUN THIS` banner.

### Files Modified

- [common/common.sh](common/common.sh)
- [scripts/1-install-scripts.sh](scripts/1-install-scripts.sh)
- [100-install-nemesis-software.sh](100-install-nemesis-software.sh)
- [120-install-nemesis-icon-themes.sh](120-install-nemesis-icon-themes.sh)
- [TODO.md](TODO.md)

## 2026.05.18

### What Changed

Added `flake8` and `ruff` to the core packages installed by `110-install-core-software.sh`, ensuring Python linting tools are always present system-wide. Updated the Arch mirrorlist to the 2026-05-18 generated version with two new mirrors added and one stale mirror removed.

### Technical Details

- `flake8` and `ruff` added to the `install_core_packages()` array in alphabetical order alongside existing dev tools
- Mirrorlist regenerated: added `arch.ljkx.org` and `mirror.tzulo.com`, removed `mirror.thereisno.page/archlinux` (stale)
- No structural changes; pure package list and mirror maintenance

### Files Modified

- [110-install-core-software.sh](110-install-core-software.sh)
- [mirrorlist](mirrorlist)

---

## 2026.05.06

### What Changed

Extended `is_omarchy()` in [common/handle.sh](common/handle.sh) to detect Omarchy via an ATT marker file in addition to the existing plymouth config check.

### Technical Details

- Previous logic: `[[ -f /etc/plymouth/plymouthd.conf ]] && grep -qi "omarchy" /etc/plymouth/plymouthd.conf`
- New logic: same plymouth check **OR** `[[ -f /etc/att/att-omarchy-marker ]]`
- Curly-brace grouping `{ ...; } ||` is required so the `||` applies to the entire `&&` chain, not just the grep
- Matches the detection logic in ATT Python: `fn.check_content("omarchy", ...) or fn.os.path.isfile("/etc/att/att-omarchy-marker")`

### Files Modified

- [common/handle.sh](common/handle.sh)

---

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
