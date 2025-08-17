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

alias zcfg='nvim ~/.dotfiles/.zshrc'
alias gcfg='nvim ~/.dotfiles/.gitconfig'

alias vcfg='nvim ~/.dotfiles/vimrc'
alias wcfg='nvim ~/.dotfiles/wezterm.lua'
alias ghostty='/Applications/Ghostty.app/Contents/MacOS/ghostty'

alias wold='docker/node npm run watch:development'
alias pbc='docker/node npm run pb:watch:client:development'
alias pbs='docker/node npm run pb:watch:server:development'
alias pbdbg='docker/node npm run pb:watch:server:development:debugger'
alias pbgt='docker/node npm run pb:generate:translations'
