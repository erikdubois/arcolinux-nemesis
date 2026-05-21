# TODO.md

## Active

_(none)_

## Backlog

- [ ] Consider a `scripts/1-install-scripts.sh` health-check mode that lists what would be installed without installing

## Done

- [x] Investigate per-package signing for nemesis_repo — _closed permanent-no (2026.05.21): Erik will never sign his packages. `SigLevel = Never` is the final answer for nemesis_repo / kiro_repo by design. Don't re-open._
- [x] Add `ruff` linting pass to manual checklist — _closed obsolete (2026.05.21): repo is pure bash, zero `.py` files. Re-open if Python scripts land later._
- [x] Add `flake8` and `ruff` to core packages (2026.05.18)
- [x] Fix plocate-updatedb.timer skip on static-unit systems (2026.05.02)
- [x] Add PipeWire install script + make audio scripts symmetric (2026.05.02)
- [x] Add `claude-code` AUR package to 200-software-aur-repo.sh (2026.05.01)
- [x] Extend `is_omarchy()` detection with ATT marker file (2026.05.06)
