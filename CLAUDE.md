# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

ArcoLinux Nemesis is a Bash-based system automation framework that installs, configures, and personalizes Arch Linux and 30+ other distributions (Debian, Fedora, Ubuntu, FreeBSD, etc.) to match the author's preferred setup. Scripts are meant to be examined and run manually by the user at their own discretion.

## Running Scripts

```bash
# Full automated setup (main entry point)
bash 0-current-choices.sh

# Interactive desktop environment selection
bash arcolinux-desktops/1-install-desktops.sh

# Interactive utility tools selection
bash scripts/1-install-scripts.sh

# Update Chaotic AUR packages
bash up.sh
```

Individual scripts can be run standalone — they source `common/common.sh` themselves.

There are no build, lint, or test commands; these are system administration scripts.

## Architecture

### Numbered Pipeline Model

`0-current-choices.sh` is the orchestrator. It sources `common/common.sh`, detects the OS, configures repos, and then runs numbered scripts via glob patterns:

```bash
run_glob "${WORKING_DIR}/100-*"   # runs all 100-prefixed scripts in order
run_glob "${WORKING_DIR}/110-*"
# ...
```

Scripts are enabled/disabled simply by commenting or uncommenting lines in `0-current-choices.sh`. The numbering defines execution order.

### Key Files

- **`common/common.sh`** — Shared helper library (logging, package install/remove, service management, file backup, user/group management, repo configuration). All scripts source this.
- **`common/handle.sh`** — Per-distro handlers called after OS detection. Contains `handle_<distroname>()` functions for distro-specific fixups.
- **`0-current-choices.sh`** — Main orchestrator: OS detection → repo setup → system update → distro handler → numbered pipeline.
- **`personal/`** — Scripts numbered 900–999 that apply the author's personal dotfiles, themes, and application configs.
- **`arcolinux-desktops/`** — One script per desktop environment (awesome.sh, chadwm.sh, plasma.sh, etc.) with an interactive menu launcher.

### OS Detection

`0-current-choices.sh` reads `/etc/os-release` and `/etc/lsb-release` to set `$ARCO_DISTRO`, then routes non-Arch systems to handlers in `common/handle.sh` via `run_non_arch_distro_script`.

### Package Management Pattern

`common/common.sh` provides wrappers like `install_packages`, `remove_packages`, `pkg_installed`. All scripts use these rather than calling `pacman` directly, enabling cross-distro support. On non-Arch systems, the handlers swap in the appropriate package manager.

### Repository Setup

The framework adds two custom repos to `pacman.conf`:
- **Chaotic AUR** — Pre-built AUR packages (keyring/mirrorlist in `packages/`)
- **Nemesis repo** — Author's personal packages (ArcoLinux tools, dot-files, etc.)

`SigLevel=Never` is intentional for these repos.

### Backup Pattern

`backup_file_once` in `common/common.sh` saves originals with a `.nemesis` suffix before overwriting. This applies to `/etc/pacman.conf`, `/etc/environment`, mirrorlist, etc.

### Debug Mode

Setting `DEBUG=true` before running causes the pipeline to pause before each section for step-by-step inspection.

### TARGET_USER

`$TARGET_USER` (set in `common/common.sh` as `${SUDO_USER:-$USER}`) resolves to the invoking user even when running under sudo. Use it when writing files to user home directories.

## Helper Functions in common/common.sh

**Logging:** `log_section`, `log_subsection`, `log_info`, `log_warn`, `log_success`

**Packages:**
- `install_packages pkg...` — pacman -S --needed
- `remove_packages pkg...` — only removes if installed
- `remove_matching_packages pkg...` — removes with deps (Rs)
- `remove_matching_packages_deps pkg...` — removes with deps+orphans (Rns)
- `remove_matching_packages_deps_dd pkg...` — force remove ignoring deps (Rdd)
- `pkg_installed pkg` — boolean check via `pacman -Q`
- `install_local_packages` — installs `*.pkg.tar.*` from `$PACKAGES_DIR`

**Services:** `enable_now_service`, `disable_service`, `start_service`, `restart_service`

**Files:**
- `backup_file_once src dst` — copies only if dst doesn't exist
- `copy_file src dst` / `copy_file_user src dst` — root vs TARGET_USER
- `move_file src dst` / `move_file_user src dst`
- `write_file_as_root target` — reads stdin, writes via sudo tee
- `append_line_if_missing file line` / `append_line_if_missing_root file line`
- `remove_file_if_exists`, `remove_folder_if_exists`
- `replace_text_in_file file old new [use_sudo]`
- `comment_out_patterns_in_file file pattern...`

**Detection:** `is_plasma_installed`, `is_plasma_x11_installed`
