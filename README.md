# facomplete.nvim

Font Awesome Free glyph completion for Neovim, powered by
[blink.cmp](https://github.com/Saghen/blink.cmp).

Typing `fa:` in Insert mode opens completion. Continue typing an icon name or
alias, then accept an entry to replace the full `fa:<query>` token with the
Font Awesome Unicode glyph.

## Requirements

- Neovim 0.10 or newer
- [blink.cmp](https://github.com/Saghen/blink.cmp)
- A Nerd Font configured in Neovim to render Font Awesome private-use glyphs

## Setup

```lua
{
  dir = "/path/to/facomplete.nvim",
  name = "facomplete.nvim",
  opts = {
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "facomplete" },
      providers = {
        facomplete = {
          name = "Font Awesome",
          module = "facomplete.blink",
        },
      },
    },
  },
}
```

For LazyVim, add this as a plugin spec that extends `saghen/blink.cmp`.

## Catalog

The plugin bundles Font Awesome Free 7.2.0 metadata for offline completion.
Canonical icon names, aliases, and search terms are searchable. See
`LICENSE-FONTAWESOME` for attribution and licensing.
