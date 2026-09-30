# Copilot Instructions for .dotfiles

Personal dotfiles repo: configs for zsh, tmux, alacritty, git, AwesomeWM, rofi,
and a Neovim distribution (based on kickstart.nvim), plus setup and desktop
helper scripts. There is no build/test/lint pipeline — validate changes by
sourcing/reloading the relevant tool:

- zsh: `source ~/.zshrc` (or open a new shell).
- AwesomeWM: `awesome -k -c config/awesome/rc.lua` for a syntax check, then
  reload with `Mod4+Ctrl+r`.
- Neovim Lua: `stylua --check nvim/` (or `stylua nvim/` to format).

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
- `config/awesome/` — AwesomeWM config (symlinked as a whole dir to
  `~/.config/awesome`). `rc.lua` is the monolithic entry point (keybindings,
  rules, wibar). It must call `beautiful.init(... "gruvbox-theme/theme.lua")`
  **before** `require("modules")`, because widgets read `beautiful.colors` at
  require-time. User-tunable values (default apps, autostart, launcher apps,
  monitor names, weather API, lock command) live in `settings.lua` — prefer
  adding knobs there over hardcoding in `rc.lua`. Components are aggregated
  via `modules/init.lua` → `modules/<group>/init.lua` tables (`menus`, `tools`,
  `widgets`, `sidebar`); a new widget must be registered in its group's
  `init.lua`. Helper shell scripts it spawns live in `config/awesome/scripts/`
  and are referenced via `gears.filesystem.get_configuration_dir()`.
  `config/awesome/tyrannical/init.lua` is a patched copy of the
  `awesome-extra` tyrannical (fixes screen add/remove bugs); it shadows the
  system lib because the config dir comes first in `package.path`. Patches
  are marked with `-- Patched:` comments.
- `config/awesome-old/` — previous Awesome config with vendored third-party
  libs (lain, freedesktop, tyrannical, modalawesome). Legacy/reference only;
  don't edit or reformat it.
- `config/rofi/` — mostly vendored adi1090x rofi themes. Launchers/powermenus
  pick their style via a `theme='style-N'` variable in each `launcher.sh` /
  `powermenu.sh`; `config/rofi/scripts/` is added to `$PATH` in `exports.zsh`.
- `scripts/setup.sh` — clones this repo + antidote, then symlinks configs into
  `$HOME` (e.g. `~/.zshrc`, `~/.tmux.conf`, `~/.gitconfig`, `~/.config/zsh`,
  `~/.config/starship.toml`, `~/.config/awesome`, `~/.config/rofi`). When
  adding a new config file that should be installed, add a corresponding
  `ln -sf`/`ln -sfn` line here. Note `~/.config/nvim` and
  `~/.config/alacritty/alacritty.toml` are symlinked manually and not (yet) in
  this script.
- `scripts/rm-config-root.sh` — inverse of setup: removes the symlinked
  dotfiles from `$HOME` (for a clean reinstall).
- `scripts/go-init.sh` — one-off Go toolchain installer (downloads/extracts a
  pinned Go version to `/usr/local/go`, appends PATH exports to `~/.bashrc`).
- Other `scripts/*.sh` (volume, battery, pomodoro, mute-mic, toggle_wifi, …)
  are standalone desktop helpers invoked from WM keybindings/widgets.
- `config/shell/zsh/installer.zsh` apt-installs a package list at most once a
  day (stamp file in `~/.cache`); add new required system packages to its
  `PKGS` array.

## Conventions

- Lua files are formatted with `stylua` per `nvim/.stylua.toml`: 2-space
  indent, 160 column width, single quotes preferred, no parens on zero/one-arg
  calls (`call_parentheses = "None"`). Run `stylua nvim/` after editing Lua.
  This applies to `nvim/` only — `config/awesome/` Lua uses tabs, double
  quotes, and parenthesized `require("...")`; match that style there and
  don't run the nvim stylua config over it.
- Shell functions/aliases follow the existing style in
  `config/shell/zsh/*.zsh` (one concern per file, e.g. `aliases.zsh`,
  `functions.zsh`, `exports.zsh`, `fzf.zsh`, `ssh-agent.zsh`, `tmux.zsh`) —
  add new shell logic to the matching file rather than creating ad-hoc new
  ones unless it's a distinct concern.
- Symlink-based install model: files in this repo are the source of truth;
  changes should be made here, not on the deployed `~/.config`/`~/.*rc`
  symlinks.
- Commit messages use Conventional Commits with the tool as scope, e.g.
  `feat(awesome): ...`, `fix(alacritty): ...`, `refactor(tmux): ...`.
