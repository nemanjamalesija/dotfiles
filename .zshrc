export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export EDITOR="nvim"
export VISUAL="nvim"

njuBranch () {
    echo "Please provide a JIRA ID:"
    read JIRA_ID
    echo "Please provide a branch name:"
    read BRANCH_NAME
    local SLUGIFIED_BRANCH_NAME=$(slugify ${BRANCH_NAME})
    git checkout -b "${JIRA_ID}-${SLUGIFIED_BRANCH_NAME}"
}

alias dot='cd ~/.dotfiles'

alias zcfg='nvim ~/.dotfiles/.zshrc'
alias gcfg='nvim ~/.dotfiles/.gitconfig'

alias vcfg='cd ~/.dotfiles && nvim nvim'
alias wcfg='nvim ~/.dotfiles/wezterm.lua'
alias ghostty='/Applications/Ghostty.app/Contents/MacOS/ghostty'

alias gdiff='git diff' 
alias gs='git status' 
alias ga='git add' 
alias gcm='git commit -m'
alias gcma='git commit --amend -m'
alias gco='git checkout'  
alias gcb='git checkout -b'
alias gp='git push' 
alias gplease='git push --force-with-lease'
alias gpull='git pull -r' 
alias greset-hard='git reset --hard @{u}'
alias grevert-cm='git reset --soft HEAD~1'  
alias greset-one='git reset --hard HEAD^'  
alias grebase='git rebase'  
grebase-n() {
    git rebase -i HEAD~$1
}

alias nju='cd ~/Desktop/projekti/njuskalo-hr'
alias njun='cd ~/Desktop/projekti/njuskalo-hr && nvim'

alias dlog='rm -f var/logs/dev.log'
alias dzlog='rm -f var/logs/zira/dev.log'

alias wold='docker/node npm run watch:development'
alias pbc='docker/node npm run pb:watch:client:development'
alias pbs='docker/node npm run pb:watch:server:development'
alias pbdbg='docker/node npm run pb:watch:server:development:debugger'
alias pbgt='docker/node npm run pb:generate:translations'


zstyle ':prompt:pure:execution_time' show false
zstyle ':prompt:pure:execution_time' threshold 0

fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -U promptinit; promptinit
prompt pure
