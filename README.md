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
brew install neovim tmux git-delta bat fzf ripgrep fd
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

## Features

### Unified theme switching

Switch Ghostty, Neovim, tmux, and delta between light and dark with a single command:

```bash
theme light    # Solarized Light + Everforest
theme dark     # Catppuccin Macchiato
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

### Personal configs

Project shortcuts, work-specific aliases, and anything personal goes in `zsh/local/`. Files there are gitignored and sourced automatically.

Copy the template to get started:

```bash
cp zsh/local.example zsh/local/work.zsh
```
