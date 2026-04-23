# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal Neovim configuration (based on NvChad/tinyvim). Entry point: `init.lua`. Plugins are managed by lazy.nvim and bootstrapped automatically on first launch.

## Formatting

Lua files are formatted with `stylua` — configured via `.stylua.toml`: **tabs for indentation** (width 4), double quotes, Unix line endings, column width 140. Conform auto-formats on save
(`format_on_save` in `lua/plugins/configs/conform.lua`); for manual formatting use `<leader>fm`.

Do not switch to spaces or change quote style when editing Lua files — stylua will revert it and the diff will be noisy.

## Bootstrap / reset

```bash
# First run installs lazy.nvim, then run :MasonInstallAll inside nvim to install LSPs/formatters
# Full reset:
rm -rf ~/.local/share/nvim && rm -f ~/.config/nvim/lazy-lock.json
```

Treesitter parsers are installed by a custom `:TSInstallAll` command (defined in `lua/commands.lua`) that reads `ensure_installed` from the treesitter plugin spec. The plugin's `build` runs
`TSUpdate | TSInstallAll`.

## Architecture

`init.lua` loads four core modules in order — **`options` → `mappings` → `commands` → `autocmds`** — then bootstraps lazy.nvim and calls `require("lazy").setup(plugins, require("lazy_config"))`. The
colorscheme (`catppuccin-mocha`) is set at the end of `init.lua`.

### Directory layout

- `lua/options.lua`, `mappings.lua`, `commands.lua`, `autocmds.lua` — core editor config. Leader is `<space>`, localleader is `\`.
- `lua/lazy_config.lua` — lazy.nvim options (defaults to `lazy = true`, disables a large set of builtin rtp plugins for startup perf).
- `lua/plugins/init.lua` — **single flat `LazyPluginSpec[]` list of every plugin**. Each spec either inlines its config or pulls from `lua/plugins/configs/<name>.lua`.
- `lua/plugins/configs/*.lua` — one file per plugin. Convention: each file `return`s either the `opts` table or a `keys` table (never calls `setup()` directly — lazy.nvim does that).
- `lua/utils/` — small helpers (e.g. `uuid4.lua`).
- `neotree-def.lua` (repo root) — a reference dump of neo-tree defaults; not loaded.
- `neovim_tips/` — markdown tips consumed by the `neovim-tips` plugin.

### LSP / Mason flow

`lua/plugins/configs/lspconfig.lua` returns a flat list of server/tool names that is passed as `ensure_installed` to **mason-lspconfig** (the list mixes LSP servers and CLI tools like `stylua`,
`oxlint`, `ruff` — Mason installs both). That file also:

- Sets global `vim.lsp.config("*", { capabilities = ... })` with blink.cmp-style capabilities.
- Enables `codelens`, `document_color`, `linked_editing_range`, `inlay_hint`, and `inline_completion` globally.
- Configures `lua_ls` with project-specific library paths (nvim runtime, mpv types, somewm).
- Registers `LspAttach` autocmd for buffer-local keymaps (`gd`, `gD`, `<space>rn`, etc.).
- Configures `vim.diagnostic` signs/virtual text.

Adding a new language server: append its name to the `servers` list in `lspconfig.lua`. Per-server settings go via `vim.lsp.config("<name>", { settings = ... })` in the same file. Rust is the
exception — handled by `rustaceanvim`, not mason-lspconfig.

### Formatters (conform.nvim)

`lua/plugins/configs/conform.lua` maps filetypes to formatters. The web stack (JS/TS/CSS/HTML/JSON/YAML/Vue/MD/GraphQL) all use **oxfmt**, configured via `.oxfmtrc.json` at the repo root (tabs, width
4, `printWidth` 200, double quotes, semicolons, no trailing commas, LF line endings). Lua uses stylua. `format_on_save` is enabled with `timeout_ms = 0` and `lsp_fallback = true`. A custom `caddy`
formatter is defined inline.

### Sessions (resession)

On `VimLeavePre`, `autocmds.lua` auto-saves a session keyed by `<cwd>__branch__<git branch>`. `<leader>sf` lists sessions via fzf-lua (with `ctrl-e` to delete). This is why `sessionoptions` in
`options.lua` is customized.

### Terminals (ergoterm)

On `DirChanged`, `autocmds.lua` sends `cd <new cwd>` to every ergoterm terminal on the current tabpage and clears it. Keybinds live in `lua/plugins/configs/ergoterm.lua`.

### Other conventions

- Neo-tree is on `branch = "main"` (v3+ API).
- `scope.nvim` gives per-tab buffer lists; bufferline respects it.
- PATH is extended in `options.lua` to include `vim.fn.stdpath("data")/mason/bin` so Mason binaries are callable from `:!` and terminals.
- `QuickFixCmdPost` autocmd routes all quickfix output into Trouble.
- Node/Python/Perl/Ruby providers are disabled for startup perf.

## Commit style

Recent commits use Conventional Commits with a scope matching the area touched, e.g. `refactor(options): ...`, `feat(ai): ...`, `lspconfig: ...`. Match this style.
