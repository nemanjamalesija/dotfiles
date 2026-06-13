# Dotfiles

Personal dotfiles for macOS development environment.

## Installation

```bash
git clone git@github.com:nemanjamalesija/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The install script creates symlinks for all configurations and sets up the theme system.

### Dependencies

```bash
brew install neovim tmux git-delta bat fzf ripgrep fd pure lazygit
brew install felixkratz/formulae/borders
brew install --cask hammerspoon
```

### Post-install

1. Restart your terminal or run `source ~/.zshrc`
2. Open Neovim to install plugins automatically
3. Set your preferred theme with `theme light` or `theme dark`

## What's Included

| Tool | Config | Description |
|------|--------|-------------|
| Zsh | `.zshrc`, `zsh/` | Shell config with modular sourcing |
| Neovim | `nvim/` | LazyVim-based setup with LSP, Treesitter, fuzzy finding |
| Ghostty | `ghostty-config` | Terminal emulator |
| tmux | `tmux.conf` | Terminal multiplexer |
| Git | `.gitconfig` | Git config with delta integration |
| Delta | `delta/` | Themed git diffs (light/dark) |
| Bat | `bat/themes/` | Syntax highlighting themes |
| Borders | `borders/bordersrc` | Window border styling |
| Hammerspoon | `hammerspoon/init.lua` | macOS automation (`;`-prefix tmux shortcuts) |

## Features

### Unified theme switching

Switch Ghostty, Neovim, tmux, and delta between light and dark with a single command:

```bash
theme light    # Solarized Light + Everforest
theme dark     # TokyoNight Moon
tt             # Toggle between themes
```

### Cleanup utility

Kill orphaned Neovim, LSP, and Copilot processes and clean stale logs:

```bash
cleanup
```

### Modular shell config

`.zshrc` is a thin loader that sources modular files:

```
zsh/
  aliases.zsh       # Git, config editing, utility aliases
  functions.zsh     # Theme switcher, cleanup, slugify
  prompt.zsh        # Pure prompt setup
  local/            # Your personal configs (gitignored)
```

All aliases and functions live in `zsh/*.zsh` — browse them directly for the full list.

### Machine-local / work-specific config

Anything personal or work-specific (project shortcuts, work aliases, internal
project names, per-repo git identity) is kept **out of this public repo**. Each
tool has a tracked `*.example` template and a gitignored real file:

| Tool | Template (tracked) | Real file (gitignored) | Loaded by |
|------|--------------------|------------------------|-----------|
| Zsh  | `zsh/local.example` | `zsh/local/*.zsh` | `.zshrc` sources `zsh/local/*.zsh` |
| Git  | `.gitconfig.local.example` | `~/.gitconfig.local` | `[include]` in `.gitconfig` |
| Neovim | `nvim/lua/config/local.example.lua` | `nvim/lua/config/local.lua` | `pcall(require, "config.local")` in plugin specs |

`./install.sh` seeds each real file from its template on a fresh machine (it
never overwrites an existing file). After install, fill the seeded files with
your own values — nothing work-specific ever lands in git.
