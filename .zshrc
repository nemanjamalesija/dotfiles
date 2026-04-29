autoload -Uz compinit
compinit

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

# MFA code lookup from Redis (dev helper)
mfa() { docker exec emasys-dev-redis-1 redis-cli hget "auth-mfa:$1" code; }

# Add required zsh plugins if not already present
if [[ ! " ${plugins[@]} " =~ " zsh-syntax-highlighting " ]]; then
    plugins+=(zsh-syntax-highlighting)
fi

RPROMPT=''
