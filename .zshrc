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

alias v='nvim'
alias dot='cd ~/.dotfiles'

alias zcfg='nvim ~/.dotfiles/.zshrc'
alias zsource='source ~/.zshrc'

alias gcfg='nvim ~/.dotfiles/.gitconfig'
alias vcfg='cd ~/.dotfiles && nvim nvim'
alias wcfg='nvim ~/.dotfiles/wezterm.lua'
alias acfg="nvim /Users/nemanjamalesija/.config/alacritty/alacritty.toml"
alias tcfg="nvim ~/.tmux.conf"
alias tsource="tmux source ~/.tmux.conf"
alias ghostty='/Applications/Ghostty.app/Contents/MacOS/ghostty'
alias gcfg="nvim ~/.dotfiles/ghostty-config"

# Theme switcher - syncs Ghostty and Neovim colorschemes
# Usage: theme light  (Builtin Solarized Light + Everforest)
#        theme dark   (Catppuccin Macchiato + Catppuccin)
theme() {
    local mode="$1"
    local ghostty_config="$HOME/.dotfiles/ghostty-config"

    if [[ "$mode" != "light" && "$mode" != "dark" ]]; then
        echo "Usage: theme [light|dark]"
        echo "  light - Builtin Solarized Light (Ghostty) + Everforest (Neovim)"
        echo "  dark  - Catppuccin Macchiato (Ghostty) + Catppuccin (Neovim)"
        return 1
    fi

    # Write theme mode for Neovim to read
    echo "$mode" > "$HOME/.theme-mode"

    if [[ "$mode" == "light" ]]; then
        sed -i '' 's/^theme = .*/theme = Builtin Solarized Light/' "$ghostty_config"
        sed -i '' 's/^background-opacity = .*/background-opacity = 1.0/' "$ghostty_config"
        echo "Switched to light theme (Solarized light + Everforest, opaque)"
    else
        sed -i '' 's/^theme = .*/theme = Catppuccin Macchiato/' "$ghostty_config"
        sed -i '' 's/^background-opacity = .*/background-opacity = 0.98/' "$ghostty_config"
        echo "Switched to dark theme (Catppuccin Macchiato, transparent)"
    fi

    # Reload Ghostty config (Cmd+Shift+,)
    osascript -e 'tell application "System Events" to keystroke "," using {command down, shift down}'
}

toggleTheme() {
  theme_file="$HOME/.theme-mode"
  # Default to dark if file is missing or empty
  if [ ! -f "$theme_file" ]; then
      theme light 
      return
  fi
  mode="$(cat "$theme_file")"
  if [[ "$mode" == "light" ]]; then
    theme dark
  else
    theme light
  fi
}

alias tt=toggleTheme

alias borders='nvim ~/.dotfiles/borders/bordersrc'
alias borders-start='brew services start felixkratz/formulae/borders' 
alias borders-stop='brew services stop felixkratz/formulae/borders'
alias borders-restart='brew services restart felixkratz/formulae/borders'

alias notes='nvim ~/vaults/njuskalo'
alias cls="clear"

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
grebase-n() {
    git rebase -i HEAD~$1
}

alias nj='cd ~/Desktop/projekti/njuskalo-hr'
alias njv='cd ~/Desktop/projekti/njuskalo-hr && nvim'
alias amr='cd ~/Desktop/projekti/web-app/amr-web'
alias amrv='cd ~/Desktop/projekti/web-app/amr-web && nvim'
alias beaver='cd ~/Desktop/projekti/beaver-iot-web'
alias beaverv='cd ~/Desktop/projekti/beaver-iot-web && nvim'
alias total='cd ~/Desktop/Learning/"Total Typescript"/pro-essentials-workshop'

alias dlog='rm -f var/logs/dev.log'
alias dzlog='rm -f var/logs/zira/dev.log'
alias dlsplog="rm ~/.local/state/nvim/lsp.log"

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


cleanup() {
    # Colors for output
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local NC='\033[0m' # No Color
    echo -e "${YELLOW}🧹 Starting cleanup...${NC}\n"

    # echo -e "${YELLOW}Cleaning Neovim cache...${NC}\n"
    # rm -rf ~/.cache/nvim ~/.local/share/nvim/ ~/.local/state/nvim
     
    # Step 1: Gracefully close Neovim instances in tmux sessions
    echo -e "${YELLOW}📝 Attempting to close Neovim gracefully in tmux sessions...${NC}"
    if tmux list-sessions &>/dev/null; then
        # Send :qa! command to all tmux panes that might have Neovim
        tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}' | while read pane; do
            # Try to close Neovim gracefully
            tmux send-keys -t "$pane" Escape 2>/dev/null
            tmux send-keys -t "$pane" ':qa!' Enter 2>/dev/null
        done
        
        echo -e "${GREEN}✓ Sent close commands to all tmux panes${NC}"
        sleep 2  # Give Neovim time to close gracefully
    else
        echo -e "${GREEN}✓ No tmux sessions running${NC}"
    fi
    # Step 2: Kill LSP servers
    echo -e "\n${YELLOW}🔧 Killing LSP servers...${NC}"
    LSP_PIDS=$(pgrep -f "language-server|tsserver" | grep -v grep)
    if [ -n "$LSP_PIDS" ]; then
        echo "$LSP_PIDS" | xargs kill -9 2>/dev/null
        echo -e "${GREEN}✓ Killed LSP servers: $(echo $LSP_PIDS | wc -w | tr -d ' ') processes${NC}"
    else
        echo -e "${GREEN}✓ No LSP servers running${NC}"
    fi
    # Step 3: Kill any remaining Neovim processes
    echo -e "\n${YELLOW}📋 Killing remaining Neovim processes...${NC}"
    NVIM_PIDS=$(pgrep nvim)
    if [ -n "$NVIM_PIDS" ]; then
        echo "$NVIM_PIDS" | xargs kill -9 2>/dev/null
        echo -e "${GREEN}✓ Killed Neovim: $(echo $NVIM_PIDS | wc -w | tr -d ' ') processes${NC}"
    else
        echo -e "${GREEN}✓ No Neovim processes running${NC}"
    fi
    # Step 4: Kill tmux server
    echo -e "\n${YELLOW}🖥️  Killing tmux server...${NC}"
    if tmux list-sessions &>/dev/null; then
        tmux kill-server 2>/dev/null
        echo -e "${GREEN}✓ Tmux server killed${NC}"
    else
        echo -e "${GREEN}✓ Tmux server not running${NC}"
    fi
    # Step 5: Clean LSP log
    echo -e "\n${YELLOW}📄 Cleaning LSP log...${NC}"
    LOG_PATH="$HOME/.local/state/nvim/lsp.log"
    if [ -f "$LOG_PATH" ]; then
        LOG_SIZE=$(du -h "$LOG_PATH" | cut -f1)
        rm "$LOG_PATH"
        echo -e "${GREEN}✓ Deleted LSP log (was $LOG_SIZE)${NC}"
    else
        echo -e "${GREEN}✓ No LSP log to clean${NC}"
    fi
    # Step 6: Final verification
    echo -e "\n${YELLOW}🔍 Verifying cleanup...${NC}"
    sleep 1
    REMAINING_NVIM=$(pgrep nvim | wc -l | tr -d ' ')
    REMAINING_LSP=$(pgrep -f "language-server|tsserver" | wc -l | tr -d ' ')
    if [ "$REMAINING_NVIM" -eq 0 ] && [ "$REMAINING_LSP" -eq 0 ]; then
        echo -e "${GREEN}✅ Cleanup successful! All processes terminated.${NC}\n"
    else
        echo -e "${RED}⚠️  Warning: Some processes may still be running:${NC}"
        [ "$REMAINING_NVIM" -gt 0 ] && echo -e "${RED}  - Neovim: $REMAINING_NVIM processes${NC}"
        [ "$REMAINING_LSP" -gt 0 ] && echo -e "${RED}  - LSP: $REMAINING_LSP processes${NC}"
        echo ""
    fi
} 
export PATH="$HOME/.local/bin:$PATH"
