import { defineConfig } from 'vitepress'
import { withMermaid } from "vitepress-plugin-mermaid";

// https://vitepress.dev/reference/site-config
export default withMermaid(defineConfig({
  srcDir: './docs',
  title: "Windows Enterprise Defaults",
  description: "Make Windows enterprise-ready.",
  head: [['link', { rel: 'icon', href: '/defaults/favicon.ico' }]],
  lastUpdated: true,
  base: '/defaults/',
  sitemap: {
    hostname: 'https://stealthpuppy.com/defaults/'
  },
  cleanUrls: true,
  markdown: {
    image: {
      // image lazy loading is disabled by default
      lazyLoading: true
    },
    toc: { level: [1, 2, 3] },
  },

  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    nav: [
      { text: 'Home', link: '/' },
      { text: 'About', link: '/about' },
      { text: 'Getting started', link: '/install' },
      { text: 'Change log', link: 'https://github.com/aaronparker/defaults/releases' }
    ],

    logo: '/img/defaults.png',
    search: {
      provider: 'local'
    },

    sidebar: [
      {
        text: 'Introduction',
        collapsed: false,
        items: [
          { text: 'About', link: 'about.md' },
          { text: 'Results', link: 'results.md' },
          { text: 'Installing', link: 'install.md' },
          { text: 'Known issues', link: 'issues.md' }
        ]
      },
      {
        text: 'Under the hood',
        collapsed: false,
        items: [
          { text: 'Logging', link: 'logs.md' },
          { text: 'Configurations', link: 'configs.md' },
          { text: 'Remove AppX apps', link: 'appxapps.md' },
          { text: 'Machine settings', link: 'machine.md' },
          { text: 'User settings', link: 'profile.md' },
          { text: 'Customise', link: 'custom.md' },
          { text: 'Feature upgrades', link: 'feature.md' }
        ]
      },
      {
        text: 'Settings',
        collapsed: false,
        items: [
          { text: 'Registry', link: 'registry.md' },
          { text: 'Capabilities and Features', link: 'features.md' },
          { text: 'Paths', link: 'paths.md' },
          { text: 'Services', link: 'services.md' },
          { text: 'Files', link: 'files.md' }
        ]
      }
    ],

    socialLinks: [
      { icon: 'github', link: 'https://github.com/aaronparker/defaults' },
      { icon: 'bluesky', link: 'https://bsky.app/profile/stealthpuppy.com' },
      { icon: 'linkedin', link: 'https://www.linkedin.com/in/aaronedwardparker/' },
    ],

    footer: {
      message: 'A stealthpuppy project.',
      copyright: 'Copyright &copy; 2025 Aaron Parker.'
    },

    editLink: {
      pattern: 'https://github.com/aaronparker/defaults/edit/main/:path'
    }
  }
}))
