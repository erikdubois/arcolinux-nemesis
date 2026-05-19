# Kiro vs Prism — Machine Comparison

## Overview

| | Kiro (HQ) | Prism (VirtualBox VM) |
|---|---|---|
| Role | Host / daily driver | Guest VM for testing |
| Distro | Kiro (Arch-based) | PrismLinux |
| Kernel | linux-lqx | linux-lqx |
| Machine type | Bare metal | VirtualBox NAT |
| SSH access | local | `ssh-into-prism-vb.sh` (host:2023 → guest:22) |

---

## Security

All kernel hardening sysctls apply equally to both machines — a VM gets the same
kernel namespace and the same attack surface for local privilege escalation.

| Setting | Value | Both? | Notes |
|---|---|---|---|
| `kernel.sysrq` | 244 (REISUB only) | yes | |
| `kernel.kptr_restrict` | 2 | yes | hides kernel pointers from /proc |
| `kernel.dmesg_restrict` | 1 | yes | unprivileged users can't read dmesg |
| `kernel.yama.ptrace_scope` | 1 | yes | only parent/admin can trace |
| `kernel.unprivileged_bpf_disabled` | 1 | yes | blocks BPF loading by users |
| `kernel.perf_event_paranoid` | 3 | yes | perf restricted to CAP_SYS_ADMIN |
| `kernel.core_uses_pid` | 1 | yes | |
| `fs.suid_dumpable` | 0 | yes | no coredumps from SUID binaries |
| `kernel.core_pattern` | `/bin/false` | yes | coredumps disabled entirely |
| `net.ipv4.conf.all.send_redirects` | 0 | yes | |
| `net.ipv4.ip_forward` | 0 | yes | not a router |
| `net.ipv4.tcp_syncookies` | 1 | yes | SYN flood protection |
| `net.ipv6.conf.all.use_tempaddr` | 2 | yes | IPv6 privacy addresses |
| coredump storage | none | yes | `systemd/coredump.conf.d/` |
| security limits | `@audio rtprio 99`, fd/proc limits | yes | |

No changes needed for Prism.

---

## Speed

### Sysctl — network (both machines, same values)

| Setting | Value | Effect |
|---|---|---|
| `net.ipv4.tcp_congestion_control` | bbr | low latency, less bufferbloat |
| `net.ipv4.tcp_fastopen` | 3 | data in SYN packet |
| `net.core.default_qdisc` | fq | fair queuing, no single flow dominates |
| `net.core.netdev_budget_usecs` | 2000 | responsive packet processing |
| `net.ipv4.tcp_rmem/wmem` | max 512MB | large transfer buffers |
| `net.ipv4.tcp_tw_reuse` | 1 | faster reconnect |
| `net.ipv4.tcp_fin_timeout` | 20 | faster connection cleanup |

### Sysctl — memory and CPU (both machines, same values)

| Setting | Value | Effect |
|---|---|---|
| `vm.swappiness` | 100 | **requires ZRAM** — see warning below |
| `vm.vfs_cache_pressure` | 50 | keep more inode/dentry cache |
| `vm.dirty_bytes` | 256MB | write threshold |
| `vm.page-cluster` | 0 | single-page swap reads (SSD/ZRAM optimal) |
| `kernel.sched_autogroup_enabled` | 0 | RT/audio priority; less fair multi-user |
| `kernel.sched_rt_runtime_us` | 950000 | RT tasks get 95% CPU/period |
| `vm.max_map_count` | 2147483642 | many memory maps (dev tools, DBs) |

### udev rules — what fires on each machine

| Rule file | Kiro (bare metal) | Prism (VirtualBox) |
|---|---|---|
| `60-io-scheduler.rules` | nvme→none, ssd→bfq, hdd→mq-deadline | **VBox SATA reports rotational=0 → gets BFQ. Should be none.** See fix below. |
| `60-ioschedulers-tuning.rules` | slice_idle_us, io_poll_delay | Partial — NVMe poll rule won't match, SSD slice_idle rule fires but is a no-op |
| `61-audio-power.rules` | USB audio, HDA PCIe | VBox AC97/HDA — HDA PCIe rule fires if Intel HDA emulated |
| `62-network-optimization.rules` | e1000e/igb/r8169 — fires | VBox uses `e1000` (not `e1000e`) — rule likely does NOT fire. WiFi rules don't fire. |
| `63-usb-optimization.rules` | active | active (VBox emulates USB) |
| `64-gpu-optimization.rules` | AMD (0x1002) / Intel (0x8086) — fires | VBoxSVGA has no matching PCI vendor ID — **does not fire, harmless** |
| `65-storage-optimization.rules` | read_ahead_kb for SSD/HDD | Fires for VBox SATA (`sd*`, rotational=0) — sets 256KB read-ahead, ok |
| `66-input-optimization.rules` | USB HID autosuspend disabled | VBox USB keyboard/mouse — fires, ok |
| `67-laptop-optimization.rules` | all rules commented out | same |
| `68-sound-power.rules` | alsactl restore on sound card | fires on VBox sound card — ok |

### modprobe.d

| File | Kiro | Prism |
|---|---|---|
| `amdgpu.conf` | active (AMD GPU) | **not loaded — no GPU passthrough** |
| `nvidia.conf` | active if NVIDIA present | **not loaded** |
| `audio-hda.conf` | active | active if VBox Intel HDA selected |
| `intel-ethernet.conf` | active for e1000e/igb/ixgbe | **e1000e not loaded in VBox** (VBox uses `e1000` module) |
| `realtek-ethernet.conf` | active for r8169 | not loaded in VBox |
| `blacklist-watchdog.conf` | needed (iTCO/sp5100) | harmless but irrelevant in VM |
| `blacklist evbug`, `nobeep` | active | active |

---

## Stability

| Setting | Value | Kiro | Prism | Risk |
|---|---|---|---|---|
| `kernel.panic` | 10 | reboot after 10s | same | none |
| `vm.panic_on_oom` | 0 | userspace handles OOM | same | none |
| `vm.overcommit_memory` | 1 | needed with ZRAM | needed with ZRAM | low with ZRAM |
| `vm.min_free_kbytes` | 262144 (256MB) | fine at 16+ GB | **risky if VM has <4GB RAM** | see below |
| `vm.watermark_scale_factor` | 200 | aggressive reclaim | same | none |
| Journal storage | persistent | survives reboots | same | none |
| Systemd start timeout | 30s | safe | same | none |
| Systemd stop timeout | 15s | safe | same | none |
| ZRAM | `min(ram/2, 4096M)`, zstd | active | **must be installed** | high if missing |

---

## Warnings / Action Items for Prism

### 1. ZRAM is required — HIGH priority

`vm.swappiness = 100` is set in `99-kiro-optimizations.conf` with an explicit warning
in the comment: *"Requires ZRAM to be active; without ZRAM this setting causes
thrashing on disk-based swap."*

Check inside Prism:

```bash
systemctl status systemd-zram-setup@zram0.service
zramctl
```

If ZRAM is not active, install it:

```bash
sudo pacman -S zram-generator
# zram-generator.conf is shipped by edu-system-files — should already be present
sudo systemctl enable --now systemd-zram-setup@zram0.service
```

### 2. I/O scheduler for VirtualBox SATA — MEDIUM priority

VirtualBox SATA virtual disks show up as `sda*` with `rotational=0`.
The current rule assigns **BFQ**, but `none` is correct for virtual disks
(the host OS already schedules I/O; double-scheduling wastes CPU).

Add to `60-io-scheduler.rules` in edu-system-files:

```
# VirtualBox SATA (emulated, rotational=0 but not a real SSD)
ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="0", \
  ATTRS{model}=="VBOX HARDDISK*", ATTR{queue/scheduler}="none"
```

This must appear **before** the generic SSD rule so it takes priority.

### 3. `vm.min_free_kbytes = 262144` — LOW priority

256MB reserved for kernel on a VM with <4GB RAM allocated means the guest
sees 12–25% of its RAM as permanently unavailable. Either:
- Allocate 4GB+ to the Prism VM (recommended), or
- Add a Prism-specific sysctl override: `vm.min_free_kbytes = 131072` (128MB)

### 4. `net.ipv4.tcp_max_tw_buckets = 2000000` — INFO

2M TIME_WAIT buckets on a VM is excessive. Default (32768) is fine.
No harm, just unnecessary memory overhead.

---

## SSH Quick Reference

```bash
# From HQ into Prism VM
bash ~/DATA/arcolinux-nemesis/scripts/ssh-into-prism-vb.sh
# Port mapping: host:2023 → guest:22
# Kiro-VB uses 2022; Prism uses 2023
```

First-time guest setup inside Prism:

```bash
sudo pacman -S openssh zram-generator
sudo systemctl enable --now sshd
sudo systemctl enable --now systemd-zram-setup@zram0.service
```

---

## Config Source

All configs ship from: `~/EDU/edu-system-files/`  
Package: `edu-system-files-git`  
Both machines should run the same package version.
