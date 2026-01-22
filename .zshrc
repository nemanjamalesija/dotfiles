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
        echo "Switched to light theme (Solarized light + Everforest)"
    else
        sed -i '' 's/^theme = .*/theme = Catppuccin Macchiato/' "$ghostty_config"
        sed -i '' 's/^background-opacity = .*/background-opacity = 0.95/' "$ghostty_config"
        echo "Switched to dark theme (Catppuccin Macchiato)"
    fi

    # Reload Ghostty config (Cmd+Shift+,)
    osascript -e 'tell application "System Events" to keystroke "," using {command down, shift down}'

    # Reload tmux config if tmux is running
    if command -v tmux &> /dev/null && tmux list-sessions &> /dev/null 2>&1; then
        tmux source-file ~/.tmux.conf
        echo "Reloaded tmux configuration"
    fi
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
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local NC='\033[0m'

    # Capture memory before cleanup
    local MEM_BEFORE=$(ps -A -o rss= | awk '{sum+=$1} END {print sum/1024}')

    echo -e "${YELLOW}Starting cleanup...${NC}\n"

    # Step 1: Gracefully close Neovim instances in tmux sessions
    echo -e "${YELLOW}Attempting to close Neovim gracefully in tmux sessions...${NC}"
    if tmux list-sessions &>/dev/null; then
        tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index}' | while read pane; do
            tmux send-keys -t "$pane" Escape 2>/dev/null
            tmux send-keys -t "$pane" ':qa!' Enter 2>/dev/null
        done
        echo -e "${GREEN}Sent close commands to all tmux panes${NC}"
        sleep 2
    else
        echo -e "${GREEN}No tmux sessions running${NC}"
    fi

    # Step 2: Kill Copilot processes (major memory leaker)
    echo -e "\n${YELLOW}Killing Copilot processes...${NC}"
    COPILOT_PIDS=$(pgrep -f "copilot|github.copilot")
    if [ -n "$COPILOT_PIDS" ]; then
        echo "$COPILOT_PIDS" | xargs kill -15 2>/dev/null
        sleep 1
        # Force kill if still running
        pgrep -f "copilot|github.copilot" | xargs kill -9 2>/dev/null
        echo -e "${GREEN}Killed Copilot: $(echo $COPILOT_PIDS | wc -w | tr -d ' ') processes${NC}"
    else
        echo -e "${GREEN}No Copilot processes running${NC}"
    fi

    # Step 3: Kill LSP servers (including vtsls)
    echo -e "\n${YELLOW}Killing LSP servers...${NC}"
    LSP_PIDS=$(pgrep -f "language-server|tsserver|vtsls|vue-language-server|eslint")
    if [ -n "$LSP_PIDS" ]; then
        echo "$LSP_PIDS" | xargs kill -15 2>/dev/null
        sleep 1
        pgrep -f "language-server|tsserver|vtsls|vue-language-server|eslint" | xargs kill -9 2>/dev/null
        echo -e "${GREEN}Killed LSP servers: $(echo $LSP_PIDS | wc -w | tr -d ' ') processes${NC}"
    else
        echo -e "${GREEN}No LSP servers running${NC}"
    fi

    # Step 4: Kill orphaned node processes from LSP/Copilot
    echo -e "\n${YELLOW}Killing orphaned node processes...${NC}"
    NODE_PIDS=$(pgrep -f "node.*mason|node.*copilot|node.*typescript")
    if [ -n "$NODE_PIDS" ]; then
        echo "$NODE_PIDS" | xargs kill -15 2>/dev/null
        sleep 1
        pgrep -f "node.*mason|node.*copilot|node.*typescript" | xargs kill -9 2>/dev/null
        echo -e "${GREEN}Killed orphaned node: $(echo $NODE_PIDS | wc -w | tr -d ' ') processes${NC}"
    else
        echo -e "${GREEN}No orphaned node processes${NC}"
    fi

    # Step 5: Kill any remaining Neovim processes
    echo -e "\n${YELLOW}Killing remaining Neovim processes...${NC}"
    NVIM_PIDS=$(pgrep nvim)
    if [ -n "$NVIM_PIDS" ]; then
        echo "$NVIM_PIDS" | xargs kill -9 2>/dev/null
        echo -e "${GREEN}Killed Neovim: $(echo $NVIM_PIDS | wc -w | tr -d ' ') processes${NC}"
    else
        echo -e "${GREEN}No Neovim processes running${NC}"
    fi

    # Step 6: Kill tmux server
    echo -e "\n${YELLOW}Killing tmux server...${NC}"
    if tmux list-sessions &>/dev/null; then
        tmux kill-server 2>/dev/null
        echo -e "${GREEN}Tmux server killed${NC}"
    else
        echo -e "${GREEN}Tmux server not running${NC}"
    fi

    # Step 7: Clean logs and state
    echo -e "\n${YELLOW}Cleaning logs and state...${NC}"
    local CLEANED_SIZE=0

    # LSP log
    if [ -f "$HOME/.local/state/nvim/lsp.log" ]; then
        CLEANED_SIZE=$((CLEANED_SIZE + $(stat -f%z "$HOME/.local/state/nvim/lsp.log" 2>/dev/null || echo 0)))
        rm -f "$HOME/.local/state/nvim/lsp.log"
    fi

    # Neovim shada (can grow large)
    if [ -f "$HOME/.local/state/nvim/shada/main.shada" ]; then
        local SHADA_SIZE=$(stat -f%z "$HOME/.local/state/nvim/shada/main.shada" 2>/dev/null || echo 0)
        if [ "$SHADA_SIZE" -gt 10485760 ]; then  # >10MB
            CLEANED_SIZE=$((CLEANED_SIZE + SHADA_SIZE))
            rm -f "$HOME/.local/state/nvim/shada/main.shada"
            echo -e "${GREEN}Cleaned oversized shada file${NC}"
        fi
    fi

    echo -e "${GREEN}Cleaned $((CLEANED_SIZE / 1024 / 1024))MB of logs/state${NC}"

    # Step 8: Final verification and memory report
    echo -e "\n${YELLOW}Verifying cleanup...${NC}"
    sleep 1

    local MEM_AFTER=$(ps -A -o rss= | awk '{sum+=$1} END {print sum/1024}')
    local MEM_FREED=$(echo "$MEM_BEFORE - $MEM_AFTER" | bc)

    REMAINING_NVIM=$(pgrep nvim | wc -l | tr -d ' ')
    REMAINING_LSP=$(pgrep -f "language-server|tsserver|vtsls|copilot" | wc -l | tr -d ' ')

    if [ "$REMAINING_NVIM" -eq 0 ] && [ "$REMAINING_LSP" -eq 0 ]; then
        echo -e "${GREEN}Cleanup successful!${NC}"
        echo -e "${GREEN}Memory freed: ${MEM_FREED%.*}MB${NC}\n"
    else
        echo -e "${RED}Warning: Some processes may still be running:${NC}"
        [ "$REMAINING_NVIM" -gt 0 ] && echo -e "${RED}  - Neovim: $REMAINING_NVIM processes${NC}"
        [ "$REMAINING_LSP" -gt 0 ] && echo -e "${RED}  - LSP/Copilot: $REMAINING_LSP processes${NC}"
        echo -e "${YELLOW}Memory freed: ${MEM_FREED%.*}MB${NC}\n"
    fi
} 
export PATH="$HOME/.local/bin:$PATH"
