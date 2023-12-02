zgenom_dir="$ZSHDIR/zgenom"
plugins_dir="$ZSHDIR/plugins"
iterm_dir="$ZSHDIR/iterm"

# Load plugins and tools

function load-zgenom() {
  # load zgenom
  source "$zgenom_dir/zgenom.zsh"

  # Check for plugin and zgenom updates every 7 days
  # This does not increase the startup time.
  zgenom autoupdate --background

  # only runs when .zgenom/sources/init.zsh doesn't exist
  # use zgenom reset to delete init.zsh
  if ! zgenom saved; then
    echo "Creating a zgenom save"
    # adds run command to zgenom for running commands in the root of a plugin directory.
    zgenom load jandamm/zgenom-ext-run

    # Add this if you experience issues with missing completions or errors mentioning compdef.
    # zgenom compdef

    # Ohmyzsh base library
    # You can also cherry pick just parts of the base library.
    # Not loading the base set of ohmyzsh libraries might lead to issues.
    # While you can do it, I won't recommend it unless you know how to fix
    # those issues yourself.
    zgenom ohmyzsh

    # Plugins

    zgenom load romkatv/powerlevel10k powerlevel10k
    zgenom load zsh-users/zsh-completions src
    # zgenom load chr-fritz/docker-completion.zshplugin # loads docker completions from the mac app
    # zgenom run chr-fritz/docker-completion.zshplugin "sudo zsh docker-completion.zshplugin"
    # zgenom load joshskidmore/zsh-fzf-history-search
    zgenom load unixorn/fzf-zsh-plugin
    zgenom load Aloxaf/fzf-tab # NOTE: fzf-tab needs to be loaded after compinit, but before plugins which will wrap widgets, such as zsh-autosuggestions or fast-syntax-highlighting!!
    zgenom load zpm-zsh/colorize
    zgenom load chrissicool/zsh-256color # 256 color support
    zgenom load mafredri/zsh-async
    zgenom load decayofmind/zsh-fast-alias-tips # gives hints/reminders after using a command that's been aliased
    zgenom run decayofmind/zsh-fast-alias-tips "make build"

    # Very cool plugin that generates zsh completion functions for commands
    # if they have getopt-style help text. It doesn't generate them on the fly,
    # you'll have to explicitly generate a completion, but it's still quite cool.
    # zgenom load RobSis/zsh-completion-generator

    # alias-maker
    no-has-dir "$ZSHDIR/plugins" install-alias-maker
    zgenom load "$plugins_dir/alias-maker"

    # local plugins copied from zsh-utlis
    zgenom load "$plugins_dir/utils/editor"
    zgenom load "$plugins_dir/utils/history"

    zgenom load zsh-users/zsh-autosuggestions
    # always load syntax highlighting at the end
    zgenom load zdharma-continuum/fast-syntax-highlighting
    # zgenom load zsh-users/zsh-syntax-highlighting # NOTE zsh-syntax-highlighting must be the last plugin loaded

    zgenom save
  fi
}

function shellinit_zgenom() {
  has-dir "$zgenom_dir" load-zgenom
}

# miscellaneous things that i don't know where else to put
function shellinit_miscellanea() {
  # bind cmd+backspace to delete line
  bindkey "^U" backward-kill-line
  # don't know if this is necessary since its in my .gitconfig.
  # git config --global core.excludesFile "$GITDIR/gitignore"
}
