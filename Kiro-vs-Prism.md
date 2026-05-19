# Kiro vs Prism — Machine Comparison

## Overview

| | Kiro (HQ) | Prism (VirtualBox VM) |
|---|---|---|
| Role | Host / daily driver | Guest VM for testing |
| Distro | Kiro (Arch-based) | PrismLinux |
| Kernel | linux-lqx | linux-lqx |
| Machine type | Bare metal | VirtualBox |
| SSH access | local | `ssh-into-prism.sh` (host:2023 → guest:22) |

## Kernel

Both machines run **linux-lqx** (Liquorix kernel). This means:
- BFQ I/O scheduler as default
- MuQSS / BMQ process scheduler
- Low-latency desktop tuning baked in
- Same kernel parameters apply to both

## Repos

| | Kiro | Prism |
|---|---|---|
| nemesis_repo | yes | yes |
| chaotic-aur | yes | yes |
| extra / core | yes | yes |

## System Files (edu-system-files)

Both machines should ship the same `edu-system-files` package:
- `etc/udev/rules.d/` — I/O, USB, GPU, audio, input tuning
- `etc/sysctl.d/99-kiro-optimizations.conf` — kernel tuning
- `etc/modprobe.d/` — driver options
- `etc/systemd/` — service timeouts, journal config

## Differences

| | Kiro | Prism |
|---|---|---|
| Hardware | real CPU / GPU / NVMe | virtual hardware |
| GPU rules | active (AMD/Nvidia) | inactive (no GPU passthrough) |
| USB rules | active | limited (virtual USB only) |
| Audio | PipeWire on real hardware | PipeWire or PulseAudio |
| Bluetooth | n/a | n/a |

## SSH Quick Reference

```bash
# From HQ into Prism VM
bash ~/DATA/arcolinux-nemesis/scripts/ssh-into-prism.sh
# Port: 2022 = Kiro-VB, 2023 = Prism
```

## Notes

- Prism VM: first-time guest setup → `sudo pacman -S openssh && sudo systemctl enable --now sshd`
- Both machines run `kiro-audit` to verify system state
- lqx kernel packages: `linux-lqx` + `linux-lqx-headers`
