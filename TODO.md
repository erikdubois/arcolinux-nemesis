# TODO.md

## Active

_(none)_

## Backlog

- [ ] Lazy audit: fix renamed/dropped Arch packages **when they fail at install** on the next fresh install, rather than pre-auditing now. Deferred 2026-05-21 — pre-audit was too heavy for the value, and pacman will tell us at install time.
- [ ] Consider a `scripts/1-install-scripts.sh` health-check mode that lists what would be installed without installing
- [ ] Investigate replacing `SigLevel=Never` with per-package signing once nemesis_repo has a stable key

## Done

- [x] Add `ruff` linting pass to manual checklist — _closed obsolete (2026.05.21): repo is pure bash, zero `.py` files. Re-open if Python scripts land later._
- [x] Add `flake8` and `ruff` to core packages (2026.05.18)
- [x] Fix plocate-updatedb.timer skip on static-unit systems (2026.05.02)
- [x] Add PipeWire install script + make audio scripts symmetric (2026.05.02)
- [x] Add `claude-code` AUR package to 200-software-aur-repo.sh (2026.05.01)
- [x] Extend `is_omarchy()` detection with ATT marker file (2026.05.06)
