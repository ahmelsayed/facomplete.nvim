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

## LazyVim installation

Create `~/.config/nvim/lua/plugins/facomplete.lua`:

```lua
return {
  {
    "saghen/blink.cmp",
    dependencies = { "ahmelsayed/facomplete.nvim" },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}
      if not vim.tbl_contains(opts.sources.default, "facomplete") then
        table.insert(opts.sources.default, "facomplete")
      end

      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.facomplete = {
        name = "Font Awesome",
        module = "facomplete.blink",
      }

      return opts
    end,
  },
}
```

Restart Neovim, then enter Insert mode and type `fa:`. Continue typing an icon
name or alias, then accept an entry to replace `fa:<query>` with its glyph.

## Other blink.cmp setups

Add `ahmelsayed/facomplete.nvim` as a plugin dependency and configure the
`facomplete` provider as shown above. Ensure it is included in
`sources.default`.

## Catalog

The plugin bundles Font Awesome Free 7.2.0 metadata for offline completion.
Canonical icon names, aliases, and search terms are searchable. See
`LICENSE-FONTAWESOME` for attribution and licensing.
