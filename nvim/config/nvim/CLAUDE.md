# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Neovim configuration targeting **Neovim >= 0.12** (uses `vim.pack`, `vim._core.ui2`, native LSP progress). Part of a larger dotfiles repo — see the root `CLAUDE.md` for the module system.

## Architecture

**Entry point:** `init.lua` — sets options, loads plugins via `vim.pack.add()`, then auto-requires every `lua/internal/*.lua` module by scanning the directory. Module load order is filesystem-dependent (not guaranteed).

**Module pattern:** Each `lua/internal/*.lua` file is a self-contained feature module. Modules declare `local mod = "..."` at the top (used for augroup names and `vim.g.var`/`vim.b.var` namespacing). They set up their own autocommands, keymaps, and commands — no central registration.

**Plugin management:** Uses Neovim's built-in `vim.pack` (not lazy.nvim/packer). Plugins are pinned in `nvim-pack-lock.json`. Current plugins: nvim-lspconfig, conform.nvim, vim-fugitive.

**LSP tools are installed via mise**, not Mason. LSP module comments contain the exact `mise install` commands (e.g. `tool="go:golang.org/x/tools/gopls@latest"; mise install "$tool"`).

**Testing:** Functions prefixed `test_` in `_G` are auto-run once at startup (`vim.g.did_test` guards re-runs). See `go_gopls_lsp_import_organizing.lua` for the pattern — table-driven tests that call `vim.notify` on failure.

**Formatting:** Go files are formatted on save via gopls LSP. Lua files are formatted on save via stylua through conform.nvim. Both use `BufWritePre` autocommands.

**State namespacing:** `vim.g.opt`/`vim.b.opt` and `vim.g.var`/`vim.b.var` are initialized in `init.lua` and reset per-filetype. Modules extend these tables (e.g. `lua_fmt.lua` stores its `formatexpr` in `vim.g.var`).

## Key Design Decisions

- `hidden` is **off** — buffers are unloaded on abandon (mitigated by `undofile = true`)
- `wrapscan` is **off** — search does not wrap around
- Most built-in plugins and providers are disabled
- The `:Restart` command re-sources `$MYVIMRC` (and all modules, since `package.loaded` is cleared before each require)
