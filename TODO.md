# TODO.md

## Active

- [x] **Cross-distro `voyage-of-chadwm` de-brand: `arco-chadwm` → `chadwm`** — _done 2026-05-24._ All 16 distro installers migrated: the 13 that cloned upstream `arcolinux/arcolinux-chadwm` now clone `erikdubois/edu-chadwm`; `arco-chadwm` → `chadwm` everywhere; mint's bundled `arco-chadwm/` override dir renamed to `chadwm/`; brand URL headers stripped from the chadwm entry scripts. Behavioral change — these distros now install the edu-chadwm desktop; **retest per distro before relying on them.**

- [ ] **Migrate `arcolinux/arcolinux-powermenu` → `edu-powermenu` across voyage-of-chadwm** — _added 2026-05-24._ 14 subtrees still clone the ArcoLinux upstream powermenu; mint already uses `edu-powermenu`. Parallel to the chadwm migration; switch clone source + retest the super+shift+x exit binding per distro.

- [ ] **De-brand the remaining voyage-of-chadwm script headers** — _added 2026-05-24._ ~150 non-chadwm install scripts (`install-cubic.sh`, `install-xanmod.sh`, `install-apps-*.sh`, `dotfiles/fish/*`, `personal-configs.sh`, etc.) still carry `arcolinux.* / alci.online / ariser.eu` Website URL header lines. Strip them down to the `erikdubois.be` line (chadwm entry scripts already done).

- [ ] **Finish adding `# Purpose:` blocks to the remaining 15 scripts** so `1-install-scripts.sh` describe-mode (and the dialog checklist column) can show a one-line summary for every script. Helper + launcher are already wired (2026-05-21).
      Scripts that still need a Purpose block:
      - `300-sardi-extras.sh`
      - `301-sardi-extras-removal.sh`
      - `400-surfn-extras.sh`
      - `401-surfn-extras-removal.sh`
      - `scripts/change-boot-sequence-boot-kernel.sh`
      - `scripts/check-boot-config.sh`
      - `scripts/diagnose-boot.sh`
      - `scripts/give-me-nemesis-repo.sh`
      - `scripts/setup-printer.sh`
      - `personal/900-install-personal-settings-folders.sh`
      - `personal/910-plasma-specific-applications-and-settings.sh`
      - `personal/920-ckb-next.sh`
      - `personal/930-real-metal.sh`
      - `personal/990-skel.sh`
      - `personal/999-last-changes.sh`

## Backlog

_(none)_

## Done

- [x] Investigate per-package signing for nemesis_repo — _closed permanent-no (2026.05.21): Erik will never sign his packages. `SigLevel = Never` is the final answer for nemesis_repo / kiro_repo by design. Don't re-open._
- [x] Add `ruff` linting pass to manual checklist — _closed obsolete (2026.05.21): repo is pure bash, zero `.py` files. Re-open if Python scripts land later._
- [x] Add `flake8` and `ruff` to core packages (2026.05.18)
- [x] Fix plocate-updatedb.timer skip on static-unit systems (2026.05.02)
- [x] Add PipeWire install script + make audio scripts symmetric (2026.05.02)
- [x] Add `claude-code` AUR package to 200-software-aur-repo.sh (2026.05.01)
- [x] Extend `is_omarchy()` detection with ATT marker file (2026.05.06)
