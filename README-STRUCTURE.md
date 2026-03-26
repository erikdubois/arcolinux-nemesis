# ArcoLinux / Nemesis Script Structure

## Goal

The goal of this structure is to turn the current script collection into a coherent, maintainable, and scalable installer framework.

This is not a rewrite for the sake of rewriting.

It is a structured refactor of the current working setup into a cleaner architecture with:

- one clear entry point
- shared helper logic
- modular installer stages
- separate package data
- a dedicated personal post-install phase
- consistent naming and execution order

---

## Design Principles

### 1. One script, one responsibility

Each script should do one clear job.

Examples:

- install Bluetooth support
- install printing support
- install Chadwm extras
- apply personal desktop settings
- sync `/etc/skel` into the user home

A script should not try to do five unrelated things at once.

---

### 2. Separate orchestration from implementation

The main runner should only control the flow.

It should:

- detect the operating system
- prepare the environment
- run backups
- configure repositories
- update the system
- launch numbered modules in order
- launch personal scripts last

The runner should **not** become a giant all-in-one installer.

---

### 3. Separate logic from package lists

Large package arrays should not live inside every module.

Instead:

- `modules/` should contain the logic
- `packages/` should contain the package lists

That makes the project easier to read, diff, and maintain.

---

### 4. Personalization is a separate phase

The `personal/` folder is not part of the generic installer phase.

It is a **post-install personalization layer**.

It should only run after:

- base system setup
- repository configuration
- package installation
- desktop/environment setup

This keeps general distro logic separate from user-specific preferences.

---

### 5. Shared checks belong in common helpers

Desktop detection, virtualization detection, package helpers, service helpers, backup helpers, logging, and reusable utility functions should live in `common/`.

Modules should call helper functions instead of duplicating detection logic.

---

### 6. Naming should explain intent

File names should tell us what the script does.

Good names are:

- `run.sh`
- `130-install-bluetooth.sh`
- `140-install-printing.sh`
- `500-install-plasma-extras.sh`
- `940-install-ckb-next-if-needed.sh`

The name should answer:
**what does this script do?**

---

## Proposed Project Layout

```text
arcolinux/
├── run.sh
├── common/
│   ├── common.sh
│   ├── handle.sh
│   ├── logging.sh
│   ├── detection.sh
│   ├── services.sh
│   ├── packages.sh
│   ├── backups.sh
│   └── desktop.sh
├── modules/
│   ├── 100-install-nemesis-software.sh
│   ├── 110-install-core-software.sh
│   ├── 120-install-icon-themes.sh
│   ├── 130-install-bluetooth.sh
│   ├── 140-install-printing.sh
│   ├── 150-install-ananicy.sh
│   ├── 200-install-aur-software.sh
│   ├── 300-install-sardi-extras.sh
│   ├── 301-remove-sardi-extras.sh
│   ├── 400-install-surfn-extras.sh
│   ├── 401-remove-surfn-extras.sh
│   ├── 500-install-plasma-extras.sh
│   └── 600-install-chadwm-extras.sh
├── personal/
│   ├── 900-create-personal-directories.sh
│   ├── 905-sync-skel-to-home.sh
│   ├── 910-install-user-settings.sh
│   ├── 920-install-root-settings.sh
│   ├── 930-apply-desktop-defaults.sh
│   ├── 940-install-ckb-next-if-needed.sh
│   ├── 950-apply-real-metal-settings.sh
│   └── 999-run-final-fixes.sh
├── packages/
│   ├── core-packages.sh
│   ├── nemesis-packages.sh
│   ├── plasma-packages.sh
│   ├── chadwm-packages.sh
│   ├── bluetooth-packages.sh
│   ├── printing-packages.sh
│   ├── sardi-extra-packages.sh
│   ├── sardi-removal-packages.sh
│   ├── surfn-extra-packages.sh
│   └── surfn-removal-packages.sh
└── settings/