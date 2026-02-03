#!/bin/bash

# Dotfiles installation script
# Run: cd ~/.dotfiles && ./install.sh

set -e

DOTFILES="$HOME/.dotfiles"

echo "Installing dotfiles from $DOTFILES"

# Create necessary directories
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/borders
mkdir -p ~/.config/bat
mkdir -p ~/.config/lazygit
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

# Alacritty
link "$DOTFILES/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml

# Borders
link "$DOTFILES/borders/bordersrc" ~/.config/borders/bordersrc

# Bat themes
link "$DOTFILES/bat/themes" ~/.config/bat/themes

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
