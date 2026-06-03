# CHANGELOG

## 2026.06.03

### What Changed

Gathered all Kiro packages into a new dedicated `101-install-kiro-packages.sh`. Previously the `kiro-*` packages were scattered: 9 mixed into `100-install-nemesis-software.sh` and 7 icon themes inside `120-install-nemesis-icon-themes.sh`. They now live in one place (20 packages total), making the Kiro set easy to find and maintain. Wired into the pipeline right after `100-*`. While here, cross-checked against the `kiro-v26.06.02` ISO pkglist and added four packages not previously installed by the framework: `kiro-keybindings`, `kiro-powermenu`, `kiro-system-files`, and `plymouth-theme-kiro-logo`.

### Technical Details

- New `101-install-kiro-packages.sh` follows the existing repo script idiom (erikdubois header banner, `source common/common.sh`, `log_section` + `pause_if_debug`, single `install_packages` call).
- Moved out of `100-install-nemesis-software.sh`: `kiro-dot-files`, `kiro-arc-dawn`, `kiro-arc-kde`, `kiro-rofi`, `kiro-rofi-themes`, `kiro-sddm-simplicity`, `kiro-shells`, `kiro-variety-config`, `kiro-xfce`. The non-Kiro Nemesis set (ATT, arc-gtk-theme, flameshot, neo-candy-icons, surfn-icons, rofi, etc.) stays in 100.
- Moved out of `120-install-nemesis-icon-themes.sh`: the 7 Kiro icon themes (`kiro-neo-candy-*`, `kiro-papirus-dark-tela*`). `surfn-plasma-flow-git` remains, so 120 still ships the non-Kiro icon theme.
- Added four packages from the ISO pkglist that the framework did not install before: `kiro-keybindings` (distinct from the plasma-specific `kiro-plasma-keybindings`, which intentionally stays in `500-plasma.sh`), `kiro-powermenu`, `kiro-system-files`, and `plymouth-theme-kiro-logo`. `kiro-calamares-config` was intentionally left out (installer-only).
- `kiro-system-files` is installed by its own `install_kiro_system_files()` step, **not** in the atomic `install_packages` batch — it overwrites real `/etc` files and can hit `exists in filesystem` conflicts. A `pacman -Sp` dry-run confirms it resolves, then the real install runs inside an `if` (condition context), so a conflict logs a warning and the pipeline continues instead of the whole 19-package transaction aborting. Relies on `common.sh` using `set -Euo pipefail` with no `-e` and a non-exiting `ERR` trap.

**Two robustness fixes surfaced while testing the run in a VirtualBox VM:**

- **`enable_now_service` now skips missing units** (`common/common.sh`). It blindly ran `sudo systemctl enable --now "${service}"`; when a unit didn't exist (e.g. `man-db.timer`, `plocate-updatedb.timer` on a system where those packages failed to install), systemctl errored and the `ERR` trap stalled ~10s per miss — twice per call via `errtrace` (helper line + call site). Now it guards with `systemctl cat "${service}" &>/dev/null` and `log_warn`+`return 0` when absent. Fixes every caller (cups, bluetooth, samba, mariadb, …), not just the timers.
- **Stopped force-removing `fastfetch`** (`0-current-choices.sh`, `common/handle.sh`). Both ran `remove_matching_packages fastfetch` to make room for `fastfetch-git` (installed in 110). But `fastfetch-git` already **Provides** and **Conflicts** `fastfetch`, so `pacman -S fastfetch-git` swaps it cleanly. The explicit `-Rs` broke `alacritty-tweak-tool-gtk4-git`'s hard dependency on `fastfetch` (`removing fastfetch breaks dependency 'fastfetch'`) on any re-run where ATT was already installed. Both removal lines deleted; the install handles the swap.
- Orchestrator: added `run_glob "${WORKING_DIR}/101-*"` after the `100-*` line in `0-current-choices.sh`. Note `120-*` remains commented out (pre-existing).
- All four touched scripts pass `bash -n`.

### Files Modified

- `101-install-kiro-packages.sh` (new)
- `100-install-nemesis-software.sh`, `120-install-nemesis-icon-themes.sh`, `0-current-choices.sh`
- `common/common.sh` (enable_now_service guard), `common/handle.sh` (fastfetch removal dropped)

## 2026.06.03 — edu→kiro repoint

### What Changed

Repointed all `edu-*` references to the new `kiro-*` names after the edu→kiro repo move and package rename. Fresh installs now pull the renamed packages from nemesis_repo and clone from the `kirodubes` account instead of `erikdubois`. 33 scripts touched across the numbered pipeline, the desktop installers, and the voyage-of-chadwm distro scripts.

### Technical Details

- **Package names drop the `-git` suffix** — the rename was not 1:1. `edu-X-git` → `kiro-X` (e.g. `edu-chadwm-git` → `kiro-chadwm`, `edu-xfce-git` → `kiro-xfce`); `edu-arc-kde` (already suffix-less) → `kiro-arc-kde`. Verified every target exists in `~/EDU/nemesis_repo/x86_64/`. A naive `edu-`→`kiro-` swap would have produced nonexistent `kiro-*-git` names.
- **Clone URLs** — `github.com/erikdubois/edu-X` → `github.com/kirodubes/kiro-X` (Phase-1 repo move is live with redirects; URLs cleaned up to the real targets). One exception: `edu-pkgbuild` moved to `kirodubes/KIRO-PKG-BUILD-APPS` (not `kiro-pkgbuild`), subpath `archlinux-tweak-tool-gtk4-git` unchanged.
- **Deliberately preserved (still ship as `edu-`)** — three artifacts inside the renamed repos were not renamed: the SDDM theme dir `edu-simplicity` (`Current=edu-simplicity`), the `/usr/local/bin/edu-powermenu` binary basename, and one `# getting edu-powermenu` comment that accurately names it. Confirmed against the live `kirodubes` repos.
- **`/tmp/edu-*` working dirs left untouched** by rule — never modify `/tmp` paths.
- Applied via two scoped sed passes whose regexes (`-git` suffix / `erikdubois/` prefix) cannot match the preserved items; all 33 scripts pass `bash -n`.

### Files Modified

- Package lists: `100-install-nemesis-software.sh`, `120-install-nemesis-icon-themes.sh`, `500-plasma.sh`, `600-ohmychadwm.sh`, `arcolinux-desktops/{awesome,bspwm,chadwm,i3,leftwm,ohmychadwm,qtile,xfce}.sh`
- Clone URLs: `scripts/install-archlinux-tweak-tool-gtk4.sh`, `personal/settings/voyage-of-chadwm/*/install-chadwm.sh`, `.../{mint,ubuntu}-chadwm/{personal-configs,install-apps-install}.sh`

## 2026.05.29

### What Changed

Added a full learning website under `docs/`, served by GitHub Pages at `https://erikdubois.github.io/arcolinux-nemesis`. It rewrites the README's content into a multi-page site that matches the kiro-website look (dark slate theme, switchable accent palette, accessibility widget). Six pages: landing, learning hub, getting started, the scripts, desktops, distros — plus a 404. The site logo is the Kiro "K".

### Technical Details

- Build pipeline mirrors kiro-website: Tailwind v3 CLI (`build-css.sh`) scans the HTML pages listed in `tailwind.config.js` and emits minified `dist/tailwind.css`. The accent system resolves through CSS variables (`--accent-200..500`) so the visitor-switchable theme needs no rebuild.
- **Differs from kiro-website on purpose** (both noted in-file): `dist/` is committed (GitHub Pages serves `/docs` directly, no build step), and the shared interactions live in one `assets/site.js` (loaded `defer`) instead of being inlined into every page — only a small pre-paint accent/a11y boot is inline per page.
- Content drawn from the existing README and scripts: quick-start (`nemesis_repo` + `0-current-choices.sh`), the numbered pipeline (100–600, personal 900–999), `common/common.sh` helper summary, the 13 desktops from `arcolinux-desktops/`, and the full Arch-based + non-Arch distro lists with their real YouTube playlist links.
- Assets reused from the repo: `personal/settings/arcolinux.png` (initial logo, since replaced by the Kiro logo) and the seven `personal/settings/desktop-images/` screenshots, copied into `docs/assets/`.
- Logo set to the Kiro "K" (`docs/assets/branding/logo.png`, copied from `kiro-website/assets/branding/logo.png`). Favicon currently points at that logo; a lightweight dedicated favicon set is not yet generated.
- SEO scaffold: `robots.txt`, `sitemap.xml` (5 indexable pages), per-page canonical + Open Graph tags; `404.html` is `noindex`.

### Files Modified

- `docs/` (new): `index.html`, `learn.html`, `getting-started.html`, `the-scripts.html`, `desktops.html`, `distros.html`, `404.html`
- `docs/` tooling: `build-css.sh`, `package.json`, `tailwind.config.js`, `tailwind.input.css`, `css/style.css`, `assets/site.js`, `.gitignore`, `robots.txt`, `sitemap.xml`
- `docs/assets/branding/logo.png`, `docs/assets/screenshots/*` (7 images)

### Refinements (same day)

After the initial build, the site was reviewed and iterated, then deployed:

- **Layout** — widened the body 10% on every page (`max-w-5xl` → `70.4rem`, `max-w-6xl` → `79.2rem`); still centered and responsive on all devices.
- **Personal credit** — changed from "creator of ArcoLinux" to **"creator of Kiro"** (hero subline, all footers, homepage meta descriptions). The "ArcoLinux Nemesis" project name and every repo/URL reference were intentionally kept.
- **Copy polish (review pass)** —
  - Homepage hero pill relabeled to **"The learning hub"** (it pointed at `learn.html` while the "Get started" button points at `getting-started.html` — two "start" prompts were confusing).
  - Desktop names normalized to first-letter-capital everywhere (hero, Desktops cards, gallery captions, meta): Awesome, Bspwm, I3, Leftwm, Qtile, Chadwm, Ohmychadwm, Plasma, Gnome, Cinnamon, Mate, Budgie, Xfce.
  - Footer brand expanded from "Nemesis" to the full **"ArcoLinux Nemesis"** on all pages (matching the header).
  - Added a calm safety line — *"Prefer to read it first? Use the manual block above."* — under both `curl … | sudo bash` one-liners (index + getting-started).
  - Hero ending reworded: *"— reproducibly, on any distro."* → *"— and lets you reproduce it on any distro."*
  - Learn page: *"Customization & ricing"* → *"Customization & ricing (theming your setup)"*.
  - Left unchanged by choice: the homepage quick-start "Clone the repo" step.
- **Deployed** — GitHub Pages build succeeded (commit `43ed2b6`); live and verified at `https://erikdubois.github.io/arcolinux-nemesis/`.

### New: Links page

- Added **`links.html`** — a curated set of the most important resources for an Arch Linux beginner, researched from the web and grouped into four sections: *start here* (Installation guide, Help:Reading, FAQ, Download), *understand it* (Arch Linux / the Arch Way, terminology, General recommendations), *keep it healthy* (pacman, AUR, System maintenance, Arch news), and *help & give back* (Forums, Code of conduct, Getting involved, ArchWiki home). Every URL was verified to return HTTP 200.
- **"Links" added to the nav (at the end) and the footer "Learn" list on all pages**, plus `sitemap.xml` and the `tailwind.config.js` content array.
- Dropped the `arch-announce` mailing-list link — `lists.archlinux.org` was returning 502/unreachable at the time, so the verified **Code of conduct** page was used instead (the "warning before updates" value is already covered by the Arch news card). No social-media links included, per project preference.
- **Fix:** the `getting-started.html` steps were in a narrow off-center column (`max-w-3xl`); widened to `max-w-[70.4rem]` to align with the hero and the rest of the site.

## 2026.05.25

### What Changed

Removed the Chadwm installation path from the Arch pipeline, leaving only Ohmychadwm. The renamed `600-chadwm.sh` → `600-ohmychadwm.sh` now installs ohmychadwm exclusively, and the dead chadwm decision point was stripped from the orchestrator and shared library.

### Technical Details

- `600-ohmychadwm.sh` — dropped `install_chadwm_package()`, the `_install_chadwm` flag and its `/tmp/install-chadwm` check, and the chadwm install block. Core packages + VirtualBox guest utils now install only when `/tmp/install-ohmychadwm` is present. Purpose header and the core-packages log line updated to ohmychadwm-only.
- `0-current-choices.sh` — removed the already-commented `#run_chadwm_choice` decision point and its comment (lines 112-113).
- `common/common.sh` — removed the now-dead `run_chadwm_choice()` function (it was the only writer of `/tmp/install-chadwm`, which nothing reads anymore).
- **Not touched:** the cross-distro `personal/settings/voyage-of-chadwm/*-chadwm/install-chadwm.sh` installers still build chadwm — that is the separate non-Arch subsystem, out of scope for the Arch pipeline.

### Files Modified

- [600-ohmychadwm.sh](600-ohmychadwm.sh)
- [0-current-choices.sh](0-current-choices.sh)
- [common/common.sh](common/common.sh)

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
