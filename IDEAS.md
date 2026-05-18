# IDEAS.md

## Claude's Ideashop

### 2026.05.18 — Auto-detect stale mirrors before committing the mirrorlist

Before committing an updated `mirrorlist`, run a background curl/wget health-check against each `Server =` URL (e.g. `curl -s --max-time 3 -o /dev/null -w "%{http_code}" "$url/$repo/os/$arch/core.db"`). Any URL returning a non-2xx response or timing out gets flagged or automatically removed. This turns mirror maintenance from a manual prune into a self-healing step — no more stale mirrors silently slowing `pacman -Syu` with timeout waits.
