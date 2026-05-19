# Kiro vs Prism — Config Research

**Purpose:** Inspect PrismLinux's system configuration to identify settings or
approaches that could improve Kiro's `edu-system-files`. PrismLinux is a
reference only — no changes are made to it.

**Method:** SSH into the Prism VirtualBox VM, read its `etc/` configs, compare
against `~/EDU/edu-system-files/`, and record findings here. Any improvement
goes into `edu-system-files` on Kiro.

---

## Machine Details

| | Kiro (HQ) | Prism (reference) |
|---|---|---|
| Distro | Kiro (Arch-based) | PrismLinux |
| Kernel | linux-lqx | linux-lqx |
| Machine type | Bare metal | VirtualBox VM |
| SSH | local | `ssh-into-prism-vb.sh` (host:2023 → guest:22) |
| edu-system-files | installed | not installed / not our concern |

Both run **linux-lqx** — Liquorix kernel with BFQ, low-latency scheduling, and
desktop tuning baked in. Same kernel means sysctl and scheduler settings are
directly comparable.

---

## Comparison Areas

### Security

| Setting | Kiro value | Prism value | Verdict |
|---|---|---|---|
| `kernel.kptr_restrict` | 2 | ? | |
| `kernel.dmesg_restrict` | 1 | ? | |
| `kernel.yama.ptrace_scope` | 1 | ? | |
| `kernel.unprivileged_bpf_disabled` | 1 | ? | |
| `kernel.perf_event_paranoid` | 3 | ? | |
| `fs.suid_dumpable` | 0 | ? | |
| `kernel.core_pattern` | `/bin/false` | ? | |
| `net.ipv4.tcp_syncookies` | 1 | ? | |
| `net.ipv6.conf.all.use_tempaddr` | 2 | ? | |

### Speed

| Setting | Kiro value | Prism value | Verdict |
|---|---|---|---|
| `vm.swappiness` | 100 | ? | |
| `vm.vfs_cache_pressure` | 50 | ? | |
| `vm.dirty_bytes` | 268435456 | ? | |
| `net.ipv4.tcp_congestion_control` | bbr | ? | |
| `net.core.default_qdisc` | fq | ? | |
| `kernel.sched_autogroup_enabled` | 0 | ? | |
| `kernel.sched_rt_runtime_us` | 950000 | ? | |
| I/O scheduler (NVMe) | none | ? | |
| I/O scheduler (SSD) | bfq | ? | |

### Stability

| Setting | Kiro value | Prism value | Verdict |
|---|---|---|---|
| `kernel.panic` | 10 | ? | |
| `vm.panic_on_oom` | 0 | ? | |
| `vm.overcommit_memory` | 1 | ? | |
| `vm.min_free_kbytes` | 262144 | ? | |
| `vm.watermark_scale_factor` | 200 | ? | |
| ZRAM compression | zstd | ? | |
| Journal storage | persistent | ? | |

---

## Findings

*To be filled in after SSHing into Prism and reading its configs.*

```bash
# Collect Prism's active sysctl values
sysctl -a 2>/dev/null | sort

# Collect udev rules
ls /etc/udev/rules.d/
cat /etc/udev/rules.d/*.rules

# Collect modprobe
ls /etc/modprobe.d/
cat /etc/modprobe.d/*.conf

# Collect systemd
find /etc/systemd -name "*.conf" | xargs grep -l "" | sort
```

---

## Improvements Applied to Kiro

*Record here any settings adopted from Prism into `edu-system-files`.*

| Setting | Old Kiro value | New value | Source |
|---|---|---|---|
| | | | |
