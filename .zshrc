autoload -Uz compinit
compinit

export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"
# Fullscreen (alternate-screen) rendering: stops the scroll-jump/flicker in tmux
export CLAUDE_CODE_NO_FLICKER=1

# Source general shell modules
for file in ~/.dotfiles/zsh/*.zsh; do
  source "$file"
done

# Source local/personal configs (gitignored, optional)
for file in ~/.dotfiles/zsh/local/*.zsh(N); do
  source "$file"
done

RPROMPT=''

# Colours the command line while typing, red for a command or alias that does
# not exist. It has to load last, after everything that adds keybindings.
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
