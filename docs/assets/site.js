/*
 * Shared interactions for the ArcoLinux Nemesis site.
 * Loaded with `defer` at the end of every page. The pre-paint accent/a11y
 * boot lives inline in each page <head> (it must run before first paint to
 * avoid a color flash); everything that can wait lives here.
 *
 * Depends on window.PALETTES (defined by the inline boot script).
 */
(function () {
  'use strict';

  const STORE_ACCENT = 'nemesis-accent';

  function applyAccent(name) {
    const p = window.PALETTES && window.PALETTES[name];
    if (!p) return;
    for (const [k, v] of Object.entries(p)) {
      document.documentElement.style.setProperty(`--accent-${k}`, v);
    }
    try { localStorage.setItem(STORE_ACCENT, name); } catch (e) { /* private mode */ }
    document.querySelectorAll('[data-accent]').forEach(btn => {
      btn.setAttribute('aria-pressed', btn.dataset.accent === name ? 'true' : 'false');
    });
  }

  // Reflect the already-applied accent on the swatches at load.
  (function syncSwatches() {
    let saved = null;
    try { saved = localStorage.getItem(STORE_ACCENT); } catch (e) { /* private mode */ }
    const active = (saved && window.PALETTES && window.PALETTES[saved]) ? saved : (window.DEFAULT_ACCENT || 'sky');
    document.querySelectorAll('[data-accent]').forEach(btn => {
      btn.setAttribute('aria-pressed', btn.dataset.accent === active ? 'true' : 'false');
    });
  })();

  // ── Click delegation — accent swatches, menus, copy buttons, zoom ──────────
  document.addEventListener('click', async e => {
    const accentBtn = e.target.closest('[data-accent]');
    if (accentBtn) {
      applyAccent(accentBtn.dataset.accent);
      document.getElementById('accent-menu')?.classList.add('hidden');
      document.querySelector('[data-accent-menu]')?.setAttribute('aria-expanded', 'false');
      return;
    }

    const accentMenuBtn = e.target.closest('[data-accent-menu]');
    if (accentMenuBtn) {
      const am = document.getElementById('accent-menu');
      const open = !am.classList.toggle('hidden');
      accentMenuBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
      return;
    }
    const openAccentMenu = document.getElementById('accent-menu');
    if (openAccentMenu && !openAccentMenu.classList.contains('hidden') && !e.target.closest('#accent-menu')) {
      openAccentMenu.classList.add('hidden');
      document.querySelector('[data-accent-menu]')?.setAttribute('aria-expanded', 'false');
    }

    const menuToggle = e.target.closest('[data-menu-toggle]');
    if (menuToggle) {
      const menu = document.getElementById('mobile-menu');
      const isOpen = !menu.classList.toggle('hidden');
      menuToggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
      return;
    }
    if (e.target.closest('#mobile-menu a')) {
      document.getElementById('mobile-menu').classList.add('hidden');
      document.querySelector('[data-menu-toggle]')?.setAttribute('aria-expanded', 'false');
    }

    const copyBtn = e.target.closest('[data-copy]');
    if (copyBtn) {
      try {
        await navigator.clipboard.writeText(copyBtn.dataset.copy);
        const original = copyBtn.textContent;
        copyBtn.textContent = 'Copied!';
        setTimeout(() => { copyBtn.textContent = original; }, 1500);
      } catch (err) {
        console.error('Clipboard write failed:', err);
      }
      return;
    }

    const zoomTrigger = e.target.closest('[data-zoom]');
    if (zoomTrigger) {
      const overlay = document.getElementById('zoom-overlay');
      const img     = document.getElementById('zoom-image');
      img.src = zoomTrigger.dataset.zoom;
      img.alt = zoomTrigger.getAttribute('aria-label') || '';
      overlay.classList.remove('hidden');
      document.body.style.overflow = 'hidden';
      return;
    }
    const overlay = document.getElementById('zoom-overlay');
    if (overlay && !overlay.classList.contains('hidden') && overlay.contains(e.target)) {
      overlay.classList.add('hidden');
      document.getElementById('zoom-image').src = '';
      document.body.style.overflow = '';
    }
  });

  // Esc closes the zoom overlay.
  document.addEventListener('keydown', e => {
    if (e.key !== 'Escape') return;
    const overlay = document.getElementById('zoom-overlay');
    if (overlay && !overlay.classList.contains('hidden')) {
      overlay.classList.add('hidden');
      document.getElementById('zoom-image').src = '';
      document.body.style.overflow = '';
    }
  });

  // ── Back-to-top — appears after scrolling; respects reduced-motion ─────────
  (function () {
    const btt = document.querySelector('[data-back-to-top]');
    if (!btt) return;
    const toggle = () => { btt.style.display = window.scrollY > 400 ? 'inline-flex' : 'none'; };
    toggle();
    window.addEventListener('scroll', toggle, { passive: true });
    btt.addEventListener('click', () => {
      const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
      window.scrollTo({ top: 0, behavior: reduce ? 'auto' : 'smooth' });
    });
  })();

  // ── Accessibility toggles — larger text / high contrast, persisted ─────────
  (function () {
    const MAP = { large: 'nemesis-a11y-large', contrast: 'nemesis-a11y-contrast' };
    const CLASS = { large: 'a11y-large', contrast: 'a11y-contrast' };
    function syncUI() {
      document.querySelectorAll('[data-a11y-toggle]').forEach(btn => {
        const on = document.documentElement.classList.contains(CLASS[btn.dataset.a11yToggle]);
        btn.setAttribute('aria-pressed', on ? 'true' : 'false');
        const s = btn.querySelector('[data-a11y-state]');
        if (s) s.textContent = on ? 'On' : 'Off';
      });
    }
    syncUI();
    document.addEventListener('click', e => {
      const menuBtn = e.target.closest('[data-a11y-menu]');
      if (menuBtn) {
        const menu = document.getElementById('a11y-menu');
        const open = !menu.classList.toggle('hidden');
        menuBtn.setAttribute('aria-expanded', open ? 'true' : 'false');
        return;
      }
      const toggle = e.target.closest('[data-a11y-toggle]');
      if (toggle) {
        const kind = toggle.dataset.a11yToggle;
        const on = document.documentElement.classList.toggle(CLASS[kind]);
        try { localStorage.setItem(MAP[kind], on ? '1' : '0'); } catch (e2) { /* private mode */ }
        syncUI();
        return;
      }
      const menu = document.getElementById('a11y-menu');
      if (menu && !menu.classList.contains('hidden') && !e.target.closest('#a11y-menu') && !e.target.closest('[data-a11y-menu]')) {
        menu.classList.add('hidden');
        document.querySelector('[data-a11y-menu]')?.setAttribute('aria-expanded', 'false');
      }
    });
  })();
})();
