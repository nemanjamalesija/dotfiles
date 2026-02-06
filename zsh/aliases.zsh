# General aliases

alias v='nvim'
alias dot='cd ~/.dotfiles'
alias cls="clear"

# Config editing
alias zcfg='nvim ~/.dotfiles/.zshrc'
alias zsource='source ~/.zshrc'
alias gcfg="nvim ~/.dotfiles/ghostty-config"
alias vcfg='cd ~/.dotfiles && nvim nvim'
alias tcfg="nvim ~/.tmux.conf"
alias tsource="tmux source ~/.tmux.conf"
alias ghostty='/Applications/Ghostty.app/Contents/MacOS/ghostty'

# Borders
alias borders='nvim ~/.dotfiles/borders/bordersrc'
alias borders-start='brew services start felixkratz/formulae/borders'
alias borders-stop='brew services stop felixkratz/formulae/borders'
alias borders-restart='brew services restart felixkratz/formulae/borders'

# Git
alias smerge='"/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge" .'
alias gdiff='git diff'
alias gs='git status'
alias ga='git add'
alias gcm='git commit -m'
alias gcma='git commit --amend -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gp='git push'
alias gplease='git push --force-with-lease'
alias gpl='git pull -r'
alias gcp='git cherry-pick'
alias greset-hard='git reset --hard @{u}'
alias grevert-cm='git reset --soft HEAD~1'
alias greset-one='git reset --hard HEAD^'
alias grebase='git rebase'
alias grestore='git restore'
alias gdelete='git push origin --delete'
alias gclean='git branch --merged | grep -v "main\|master\|\*" | xargs -n 1 git branch -d'

# Utility
alias dlsplog="rm ~/.local/state/nvim/lsp.log"
alias tt=toggleTheme
