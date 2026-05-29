/** @type {import('tailwindcss').Config} */
// Tailwind config for the ArcoLinux Nemesis learning site.
// Mirrors the kiro-website palette wiring: every accent class resolves
// through CSS variables (--accent-200..500) so the visitor-switchable
// theme works without any rebuild. See the inline <script> in the page
// <head> for the setter. Keep this content array in sync with the pages.
module.exports = {
  content: [
    './index.html',
    './learn.html',
    './getting-started.html',
    './the-scripts.html',
    './desktops.html',
    './distros.html',
    './links.html',
    './404.html',
  ],
  theme: {
    extend: {
      colors: {
        accent: {
          200: 'rgb(var(--accent-200) / <alpha-value>)',
          300: 'rgb(var(--accent-300) / <alpha-value>)',
          400: 'rgb(var(--accent-400) / <alpha-value>)',
          500: 'rgb(var(--accent-500) / <alpha-value>)',
        },
      },
    },
  },
  plugins: [],
};
