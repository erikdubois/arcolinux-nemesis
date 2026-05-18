# TODO.md

## Active

- [ ] Review all numbered scripts (100–900 range) for any packages that have been renamed or dropped from Arch repos
- [ ] Add a `ruff` linting pass to the CI-equivalent manual checklist for Python scripts in the repo

## Backlog

- [ ] Consider a `scripts/1-install-scripts.sh` health-check mode that lists what would be installed without installing
- [ ] Investigate replacing `SigLevel=Never` with per-package signing once nemesis_repo has a stable key

## Done

- [x] Add `flake8` and `ruff` to core packages (2026.05.18)
- [x] Fix plocate-updatedb.timer skip on static-unit systems (2026.05.02)
- [x] Add PipeWire install script + make audio scripts symmetric (2026.05.02)
- [x] Add `claude-code` AUR package to 200-software-aur-repo.sh (2026.05.01)
- [x] Extend `is_omarchy()` detection with ATT marker file (2026.05.06)
