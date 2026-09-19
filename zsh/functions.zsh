# General functions

slugify() {
    echo "$1" | \
    tr '[:upper:]' '[:lower:]' | \
    sed -E 's/[_ ]+/-/g' | \
    sed -E 's/[^a-z0-9-]//g' | \
    sed -E 's/-+/-/g' | \
    sed -E 's/^-|-$//g'
}

grebase-n() {
    git rebase -i HEAD~$1
}

# Points Sublime Merge at one of the two themes in ~/.dotfiles/sublime-merge.
# Sublime Merge watches this file, so a running app re-themes itself right away.
_theme_set_sublime_merge() {
    local prefs="$1"
    local ui_theme="$2"
    local color_scheme="$3"

    # Sublime Merge is optional, skip it on a machine that doesn't have it
    [ -f "$prefs" ] || return 0

    local setting key value tmp
    for setting in "theme=$ui_theme" "color_scheme=$color_scheme"; do
        key="${setting%%=*}"
        value="${setting#*=}"

        if grep -q "\"$key\"" "$prefs"; then
            sed -i '' -E "s|(\"$key\"[[:space:]]*:[[:space:]]*)\"[^\"]*\"|\1\"$value\"|" "$prefs"
        else
            tmp="$(mktemp)"
            awk -v line="	\"$key\": \"$value\"," \
                '/^\}/ && !added { print line; added = 1 } { print }' \
                "$prefs" > "$tmp" && mv "$tmp" "$prefs"
        fi
    done
}

# Flips the macOS system appearance. Native apps (System Settings, Finder, Mail)
# and Chrome all read it themselves, so they follow within a second. Needs
# Ghostty allowed to control System Events under Privacy & Security, Automation.
_theme_set_macos_appearance() {
    local dark_mode="false"
    if [[ "$1" == "dark" ]]; then
        dark_mode="true"
    fi

    osascript -e "tell application \"System Events\" to tell appearance preferences to set dark mode to $dark_mode"
}

# Theme switcher - syncs Ghostty, Neovim, tmux, delta, Sublime Merge and the
# macOS system appearance
# Usage: theme light  (iTerm2 Solarized Light + Everforest)
#        theme dark   (TokyoNight Moon + TokyoNight Moon)
theme() {
    local mode="$1"
    local ghostty_config="$HOME/.dotfiles/ghostty-config"
    local delta_theme_link="$HOME/.dotfiles/delta/theme.gitconfig"
    local sublime_merge_prefs="$HOME/Library/Application Support/Sublime Merge/Packages/User/Preferences.sublime-settings"

    if [[ "$mode" != "light" && "$mode" != "dark" ]]; then
        echo "Usage: theme [light|dark]"
        echo "  light - iTerm2 Solarized Light (Ghostty) + Everforest (Neovim) + Solarized Light (delta)"
        echo "  dark  - TokyoNight Moon (Ghostty) + TokyoNight Moon (Neovim) + Visual Studio Dark+ (delta)"
        return 1
    fi

    # Write theme mode for Neovim to read
    echo "$mode" > "$HOME/.theme-mode"

    # One call themes every native app and Chrome at once
    _theme_set_macos_appearance "$mode"

    if [[ "$mode" == "light" ]]; then
        # Ghostty light theme
        sed -i '' 's/^theme = .*/theme = iTerm2 Solarized Light/' "$ghostty_config"
        sed -i '' 's/^background-opacity = .*/background-opacity = 1.0/' "$ghostty_config"
        sed -i '' 's/^cursor-color = .*/cursor-color = #bf68d9/' "$ghostty_config"

        # Delta light theme
        ln -sf "$HOME/.dotfiles/delta/light.gitconfig" "$delta_theme_link"

        # Sublime Merge light theme
        _theme_set_sublime_merge "$sublime_merge_prefs" "Merge.sublime-theme" "Packages/User/Solarized Light.sublime-color-scheme"

        echo "Switched to light theme (Solarized Light + Everforest)"
    else
        # Ghostty dark theme
        sed -i '' 's/^theme = .*/theme = TokyoNight Moon/' "$ghostty_config"
        sed -i '' 's/^background-opacity = .*/background-opacity = 0.95/' "$ghostty_config"
        sed -i '' 's/^cursor-color = .*/cursor-color = #00ff41/' "$ghostty_config"

        # Delta dark theme
        ln -sf "$HOME/.dotfiles/delta/dark.gitconfig" "$delta_theme_link"

        # Sublime Merge dark theme
        _theme_set_sublime_merge "$sublime_merge_prefs" "Merge Dark.sublime-theme" "Packages/User/TokyoNight Moon.sublime-color-scheme"

        echo "Switched to dark theme (TokyoNight Moon)"
    fi

    # Reload Ghostty config (Cmd+Shift+,) — sent to whatever app is frontmost,
    # which is Ghostty when you're running `tt` from a shell prompt.
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

# Closes the tmux session tree and whatever it leaves behind. Safe to run with
# other apps and editors open: nothing outside tmux and its leftovers is touched.
cleanup() {
    local GREEN='\033[0;32m'
    local YELLOW='\033[1;33m'
    local NC='\033[0m'

    echo -e "${YELLOW}Cleaning up...${NC}\n"

    if tmux list-sessions &>/dev/null; then
        # Quit Neovim itself first so it saves its shada file and leaves no swap
        # files behind. Only panes actually running nvim get the keys, a shell
        # pane would just run ':qa!' as a command.
        local NVIM_PANES=$(tmux list-panes -a -F '#{pane_id} #{pane_current_command}' | awk '$2 == "nvim" { print $1 }')
        if [ -n "$NVIM_PANES" ]; then
            echo "$NVIM_PANES" | while read pane; do
                tmux send-keys -t "$pane" Escape 2>/dev/null
                tmux send-keys -t "$pane" ':qa!' Enter 2>/dev/null
            done
            echo -e "${GREEN}Closed Neovim in $(echo $NVIM_PANES | wc -w | tr -d ' ') pane(s)${NC}"
            sleep 2
        fi

        tmux kill-server 2>/dev/null
        echo -e "${GREEN}Tmux server stopped${NC}"
    else
        echo -e "${GREEN}No tmux sessions running${NC}"
    fi

    # Language servers and node helpers get handed over to launchd (parent PID 1)
    # when the editor that started them dies, so a parentless one is a leftover.
    # Anything with a live parent still belongs to something you are using.
    echo -e "\n${YELLOW}Looking for leftover language servers...${NC}"
    local ORPHANS=()
    for pid in $(pgrep -f "language-server|tsserver|vtsls|vue-language-server|eslint|node.*mason|node.*typescript"); do
        if [ "$(ps -o ppid= -p $pid | tr -d ' ')" = "1" ]; then
            local command_path=$(ps -o comm= -p $pid)
            echo -e "${GREEN}  - ${command_path##*/}${NC}"
            ORPHANS+=($pid)
        fi
    done

    if [ ${#ORPHANS[@]} -gt 0 ]; then
        kill -15 $ORPHANS 2>/dev/null
        echo -e "${GREEN}Closed ${#ORPHANS[@]} leftover process(es)${NC}"
    else
        echo -e "${GREEN}Nothing left over${NC}"
    fi

    # These two are the only nvim logs that grow without bound, and nothing
    # reads them once the session is over.
    for log in "$HOME/.local/state/nvim/lsp.log" "$HOME/.local/state/nvim/log"; do
        if [ -f "$log" ]; then
            echo -e "\n${GREEN}Deleted $(basename $log) ($(du -h "$log" | cut -f1))${NC}"
            rm -f "$log"
        fi
    done
}

# Declared empty here so the lookup below works with no private config file.
# Without the declaration zsh reads a host that looks like an IP address as a
# number and errors out.
typeset -gA GITLAB_HOST_ALIASES

# The web address of the current repo, worked out from the git remote. Two
# remote shapes show up, "git@host:group/project.git" and the one with an ssh
# port, "ssh://git@host:port/group/project.git".
_gitlab_project_url() {
    local host_and_path=$(git remote get-url origin | sed -E 's|^(ssh://)?git@||; s|:[0-9]+/|/|; s|:|/|; s|\.git$||')
    local host=${host_and_path%%/*}
    local path=${host_and_path#*/}

    # Some git servers answer on a different address than their GitLab
    # website. Those pairs are personal, so a private config file fills
    # GITLAB_HOST_ALIASES.
    local website_host=${GITLAB_HOST_ALIASES[$host]}
    [[ -n $website_host ]] && host=$website_host

    local scheme=https

    echo "$scheme://$host/$path"
}

# Push the current branch and set its upstream, then open its merge request in
# the browser. A branch with no merge request opens the create form instead.
gu() {
    # Reading the exit status needs its own line. On a "local x=$(...)" line the
    # status belongs to local, not to the command inside it.
    local push_output
    push_output=$(git push --set-upstream origin HEAD 2>&1)
    local push_status=$?
    echo "$push_output"

    if [ $push_status -ne 0 ]; then
        return $push_status
    fi

    # A push that carries commits gets a link back from GitLab, either the
    # merge request for the branch or the create form when there is none.
    local merge_request_url=$(echo "$push_output" | grep -oE 'https?://[^[:space:]]+/merge_requests/(new[^[:space:]]*|[0-9]+)')

    if [ -z "$merge_request_url" ]; then
        # Nothing was pushed, so GitLab sent no link. Every open merge request
        # has a ref on the server pointing at its branch tip, so the ref that
        # matches HEAD carries the merge request number for this branch.
        local merge_request_number=$(git ls-remote origin 'refs/merge-requests/*/head' 2>/dev/null \
            | grep "^$(git rev-parse HEAD)" \
            | sed -E 's|.*/merge-requests/([0-9]+)/head|\1|' \
            | sort -n | tail -1)

        local project_url=$(_gitlab_project_url)
        if [ -n "$merge_request_number" ]; then
            merge_request_url="$project_url/-/merge_requests/$merge_request_number"
        else
            merge_request_url="$project_url/-/merge_requests/new?merge_request%5Bsource_branch%5D=$(git rev-parse --abbrev-ref HEAD)"
        fi
    fi

    open "$merge_request_url"
}
