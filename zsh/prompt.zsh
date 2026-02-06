# Pure prompt
zstyle ':prompt:pure:execution_time' show true
zstyle ':prompt:pure:execution_time' threshold 5

fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -U promptinit; promptinit
prompt pure
