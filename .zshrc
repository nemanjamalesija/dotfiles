export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"

# Source general shell modules
for file in ~/.dotfiles/zsh/*.zsh; do
  source "$file"
done

# Source local/personal configs (gitignored, optional)
for file in ~/.dotfiles/zsh/local/*.zsh(N); do
  source "$file"
done
