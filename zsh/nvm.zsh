# nvm (Node Version Manager) - installed via Homebrew
export NVM_DIR="$HOME/.nvm"

# Loading nvm takes about a quarter of a second, so a new shell only puts the
# default Node on the PATH. The default is whatever `nvm alias default` set,
# and the newest installed version of it wins.
default_node_dirs=("$NVM_DIR"/versions/node/v$(<"$NVM_DIR/alias/default")*(Nn))
export PATH="${default_node_dirs[-1]}/bin:$PATH"
unset default_node_dirs

# The first nvm call loads the real nvm, which replaces this function.
nvm() {
    unfunction nvm
    source /opt/homebrew/opt/nvm/nvm.sh
    source /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm
    nvm "$@"
}
