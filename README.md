# Dotfiles

Personal dotfiles for macOS development environment.

## Installation

```bash
git clone git@github.com:nemanjamalesija/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The install script creates symlinks for all configurations and sets up the theme system.

## What's Included

| Tool | Config File |
|------|-------------|
| Zsh | `.zshrc`, `.zprofile`, `zsh/` |
| Git | `.gitconfig` |
| Neovim | `nvim/` |
| tmux | `tmux.conf` |
| Ghostty | `ghostty-config` |
| Borders | `borders/bordersrc` |
| Delta | `delta/` (git diff themes) |
| Bat | `bat/themes/` (syntax themes) |

## Theme Switching

Unified theme switching across Ghostty, Neovim, tmux, and delta:

```bash
theme light    # Solarized Light + Everforest
theme dark     # Catppuccin Macchiato
tt             # Toggle between themes
```

## Shell Config Structure

`.zshrc` is a thin loader that sources modular files:

```
zsh/
  aliases.zsh       # Git, config editing, utility aliases
  functions.zsh     # Theme switcher, cleanup, slugify
  prompt.zsh        # Pure prompt setup
  local/            # Your personal configs (gitignored)
    work.zsh        # Project shortcuts, work-specific aliases
```

To add your own personal aliases, create any `.zsh` file in `zsh/local/` — it will be sourced automatically and won't be tracked by git. See `zsh/local.example` for a template.

## Key Aliases

### Git
- `gs` - git status
- `ga` - git add
- `gcm` - git commit -m
- `gco` - git checkout
- `gp` - git push
- `gpl` - git pull -r

### Config Editing
- `zcfg` - edit .zshrc
- `vcfg` - edit nvim config
- `tcfg` - edit tmux.conf

### Navigation
- `dot` - cd to ~/.dotfiles
- `v` - open nvim

## Dependencies

Install via Homebrew:

```bash
brew install neovim tmux git-delta bat fzf ripgrep fd
```

## Post-Install

After running `install.sh`:

1. Restart your terminal or run `source ~/.zshrc`
2. Open Neovim to install plugins automatically
3. Set your preferred theme with `theme light` or `theme dark`
