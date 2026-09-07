# Copilot Instructions for .dotfiles

Personal dotfiles repo: configs for zsh, tmux, alacritty, git, and a Neovim
distribution (based on kickstart.nvim), plus a handful of setup scripts. There
is no build/test/lint pipeline — validate changes by sourcing/reloading the
relevant tool.

## Repository layout

- `config/shell/` — zsh config. `.zshrc` sources every `*.zsh` file in
  `config/shell/zsh/` (order matters only via filename), then inits starship,
  then sources SDKMAN (must stay last in `.zshrc` per the file's own comment).
  Plugins are managed by `antidote` (`plugins.zsh` loads `../.zsh_plugins.txt`).
  `env.zsh` is gitignored — treat it as machine-local secrets/env (e.g.
  `$COMPANY_EMAIL`, referenced from `config/git/.gitconfig`) and never commit it.
- `config/tmux/.tmux.conf`, `config/alacritty/alacritty.toml`, `config/git/.gitconfig`
  — standalone tool configs, symlinked into place (see below).
- `nvim/` — Neovim config derived from kickstart.nvim. `init.lua` loads
  `lua/options.lua`, `lua/keymaps.lua`, `lua/lazy-bootstrap.lua`,
  `lua/lazy-plugins.lua` in that order. `lazy-plugins.lua` just does
  `{ import = 'custom.plugins' }`, so **every** file under
  `nvim/lua/custom/plugins/*.lua` is auto-discovered by lazy.nvim — add a new
  plugin by dropping a new file there returning a lazy.nvim plugin spec table,
  no manual registration needed. `lazy-lock.json` pins plugin commits; don't
  hand-edit it, let lazy.nvim manage it.
- `scripts/setup.sh` — clones this repo + antidote, then symlinks configs into
  `$HOME` (e.g. `~/.zshrc`, `~/.tmux.conf`, `~/.gitconfig`, `~/.config/zsh`,
  `~/.config/starship.toml`). When adding a new config file that should be
  installed, add a corresponding `ln -sf`/`ln -sfn` line here.
- `scripts/rm-config-root.sh` — inverse of setup: removes the symlinked
  dotfiles from `$HOME` (for a clean reinstall).
- `scripts/go-init.sh` — one-off Go toolchain installer (downloads/extracts a
  pinned Go version to `/usr/local/go`, appends PATH exports to `~/.bashrc`).

## Conventions

- Lua files are formatted with `stylua` per `nvim/.stylua.toml`: 2-space
  indent, 160 column width, single quotes preferred, no parens on zero/one-arg
  calls (`call_parentheses = "None"`). Run `stylua nvim/` after editing Lua.
- Shell functions/aliases follow the existing style in
  `config/shell/zsh/*.zsh` (one concern per file, e.g. `aliases.zsh`,
  `functions.zsh`, `exports.zsh`, `fzf.zsh`, `ssh-agent.zsh`, `tmux.zsh`) —
  add new shell logic to the matching file rather than creating ad-hoc new
  ones unless it's a distinct concern.
- Symlink-based install model: files in this repo are the source of truth;
  changes should be made here, not on the deployed `~/.config`/`~/.*rc`
  symlinks.
