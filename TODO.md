# TODO.md

## Active

- [ ] **Cross-distro `voyage-of-chadwm` de-brand: `arco-chadwm` → `chadwm`** — _added 2026-05-24._ The functional breaks from the edu-chadwm rename are fixed (chadwm.sh, ohmychadwm.sh, mint, solus). Remaining is cosmetic brand consistency across the ~14 self-contained subtrees (ubuntu, debian, fedora, void, popos, mxlinux, nobara, peppermint, lmde6, bunsenlabs, freebsd, ghostbsd, anduin, almalinux) that bundle their own configs and use `~/.config/arco-chadwm`. Includes renaming the bundled `mint-chadwm/arco-chadwm/` override dir. No functional payoff — only do it for a uniform folder name across distros. These are out of Kiro scope (personal stack).

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
