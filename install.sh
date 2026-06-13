#!/bin/bash

# Dotfiles installation script
# Run: cd ~/.dotfiles && ./install.sh

set -e

DOTFILES="$HOME/.dotfiles"

echo "Installing dotfiles from $DOTFILES"

# Create necessary directories
mkdir -p ~/.config/borders
mkdir -p ~/.config/bat
mkdir -p ~/.config/lazygit
mkdir -p "$DOTFILES/zsh/local"
mkdir -p ~/Library/Application\ Support/com.mitchellh.ghostty

# Helper function to create symlink (backs up existing files)
link() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "Backing up $dest to $dest.backup"
        mv "$dest" "$dest.backup"
    fi

    if [ -L "$dest" ]; then
        rm "$dest"
    fi

    ln -s "$src" "$dest"
    echo "Linked $dest -> $src"
}

# Shell
link "$DOTFILES/.zshrc" ~/.zshrc
link "$DOTFILES/.zprofile" ~/.zprofile

# Git
link "$DOTFILES/.gitconfig" ~/.gitconfig

# Tmux
link "$DOTFILES/tmux.conf" ~/.tmux.conf

# Neovim
link "$DOTFILES/nvim" ~/.config/nvim

# Ghostty
link "$DOTFILES/ghostty-config" ~/Library/Application\ Support/com.mitchellh.ghostty/config

# Borders
link "$DOTFILES/borders/bordersrc" ~/.config/borders/bordersrc

# Hammerspoon
link "$DOTFILES/hammerspoon" ~/.hammerspoon

# Bat themes
link "$DOTFILES/bat/themes" ~/.config/bat/themes

# Machine-local / work-specific config:
#   - if the private companion repo is present, symlink the real files from it
#   - otherwise seed blank templates so you can fill them in by hand
PRIVATE="$HOME/.dotfiles-private"
if [ -d "$PRIVATE" ] && [ -f "$PRIVATE/link.sh" ]; then
    echo "Found $PRIVATE — linking work-specific config..."
    "$PRIVATE/link.sh"
else
    echo "No private config repo at $PRIVATE — seeding blank templates."
    echo "  (clone your private dotfiles there and re-run ./install.sh to get real values)"

    seed() {
        local template="$1"
        local dest="$2"
        if [ ! -e "$dest" ]; then
            cp "$template" "$dest"
            echo "Seeded $dest from $(basename "$template")"
        fi
    }

    # Zsh: only if no local config exists yet
    if ! ls "$DOTFILES"/zsh/local/*.zsh >/dev/null 2>&1; then
        seed "$DOTFILES/zsh/local.example" "$DOTFILES/zsh/local/work.zsh"
    fi

    # Git: machine-local include (referenced by .gitconfig)
    seed "$DOTFILES/.gitconfig.local.example" ~/.gitconfig.local

    # Neovim: machine-local lua config
    seed "$DOTFILES/nvim/lua/config/local.example.lua" "$DOTFILES/nvim/lua/config/local.lua"
fi

# Initialize theme mode file (default to light)
if [ ! -f ~/.theme-mode ]; then
    echo "light" > ~/.theme-mode
    echo "Created ~/.theme-mode (default: light)"
fi

# Rebuild bat cache for syntax themes
if command -v bat &> /dev/null; then
    echo "Rebuilding bat cache..."
    bat cache --build
fi

echo ""
echo "Done! Restart your terminal or run: source ~/.zshrc"
echo "Switch themes with: theme light | theme dark"
