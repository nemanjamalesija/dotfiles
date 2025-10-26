export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export EDITOR="nvim"
export VISUAL="nvim"


slugify() {
    echo "$1" | \
    tr '[:upper:]' '[:lower:]' | \
    sed -E 's/[_ ]+/-/g' | \
    sed -E 's/[^a-z0-9-]//g' | \
    sed -E 's/-+/-/g' | \
    sed -E 's/^-|-$//g'
}

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
alias zsource='source ~/.zshrc'

alias gcfg='nvim ~/.dotfiles/.gitconfig'
alias vcfg='cd ~/.dotfiles && nvim nvim'
alias wcfg='nvim ~/.dotfiles/wezterm.lua'
alias acfg="nvim /Users/nemanjamalesija/.config/alacritty/alacritty.toml"

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
alias gpl='git pull -r' 
alias gcp='git cherry-pick'
alias greset-hard='git reset --hard @{u}'
alias grevert-cm='git reset --soft HEAD~1'  
alias greset-one='git reset --hard HEAD^'  
alias grebase='git rebase'  
alias grestore='git restore'  
alias cls="clear"
grebase-n() {
    git rebase -i HEAD~$1
}

alias nj='cd ~/Desktop/projekti/njuskalo-hr'
alias njv='cd ~/Desktop/projekti/njuskalo-hr && nvim'
alias amr='cd ~/Desktop/projekti/web-app/amr-web'
alias amrv='cd ~/Desktop/projekti/web-app/amr-web && nvim'

alias dlog='rm -f var/logs/dev.log'
alias dzlog='rm -f var/logs/zira/dev.log'

alias wold='docker/node npm run watch:development'
alias pbc='docker/node npm run pb:watch:client:development'
alias pbs='docker/node npm run pb:watch:server:development'
alias pbdbg='docker/node npm run pb:watch:server:development:debugger'
alias pbgt='docker/node npm run pb:generate:translations'
alias borders='nvim ~/.dotfiles/borders/bordersrc'
alias borders-start='brew services start felixkratz/formulae/borders' 
alias borders-stop='brew services stop felixkratz/formulae/borders'
alias borders-restart='brew services restart felixkratz/formulae/borders'



zstyle ':prompt:pure:execution_time' show false
zstyle ':prompt:pure:execution_time' threshold 0

fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -U promptinit; promptinit
prompt pure
