zgenom_dir="$ZSHDIR/zgenom"
plugins_dir="$ZSHDIR/plugins"

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
    # adds eval command to zgenom for creating plugins inline.
    zgenom load jandamm/zgenom-ext-eval

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

    # Completions
    zgenom load zsh-users/zsh-completions src
    # Very cool plugin that generates zsh completion functions for commands
    # if they have getopt-style help text. It doesn't generate them on the fly,
    # you'll have to explicitly generate a completion, but it's still quite cool.
    zgenom load RobSis/zsh-completion-generator

    # fzf
    local pkgmgr
    if is-mac; then
      pkgmgr="brew"
    else
      pkgmgr="apt"
    fi
    zgenom eval --name fzf '
      if ! command -v fzf &> /dev/null; then
        if command -v '$pkgmgr' &> /dev/null; then
          $pkgmgr install fzf
        else
          echo "fzf not installed, '$pkgmgr' not found"
        fi
      fi
    '
    zgenom load unixorn/fzf-zsh-plugin
    export FZF_PREVIEW_ADVANCED=true
    export FZF_PREVIEW_WINDOW='right:65%:nohidden'

    zgenom load Aloxaf/fzf-tab          # NOTE: fzf-tab needs to be loaded after compinit, but before plugins which will wrap widgets, such as zsh-autosuggestions or fast-syntax-highlighting!!
    zgenom load Freed-Wu/fzf-tab-source # adds file previews to fzf-tab

    # zsh-autosuggestions [must be loaded after fzf-tab]
    zgenom load zsh-users/zsh-autosuggestions # NOTE: zsh-autosuggestions needs to be loaded after all plugins that trigger complutions (i think...mainly fzf-tab)

    # Color
    zgenom load zpm-zsh/colorize
    zgenom load chrissicool/zsh-256color # 256 color support

    # Alias
    zgenom load decayofmind/zsh-fast-alias-tips # gives hints/reminders after using a command that's been aliased
    zgenom run decayofmind/zsh-fast-alias-tips "make build"
    export ZSH_FAST_ALIAS_TIPS_EXCLUDES="u"
    export ZSH_FAST_ALIAS_TIPS_PREFIX="💡 $(tput bold)"
    export ZSH_FAST_ALIAS_TIPS_SUFFIX="$(tput sgr0)"

    no-has-dir "$ZSHDIR/plugins" "git clone https://github.com/MefitHp/alias-maker.git ${plugins_dir}/alias-maker"
    zgenom load "$plugins_dir/alias-maker"

    # various zsh
    zgenom load mafredri/zsh-async
    zgenom load agkozak/zsh-z # like jump
    export ZSHZ_TILDE=1
    export ZSHZ_CASE=smart

    # local plugins copied from zsh-utlis
    zgenom load "$plugins_dir/utils"

    # * Completions

    # edgedb
    zgenom eval --name edgedb-cli '
      if ! command -v edgedb &> /dev/null; then
        /bin/sh -c $(curl --proto '=https' --tlsv1.2 -sSf https://sh.edgedb.com) -- -y
      fi
      if [[ ! -f $HOME/.zfunc/_edgedb ]]; then
        edgedb _gen_completions --shell zsh > $HOME/.zfunc/_edgedb
      fi
    '

    # docker
    zgenom eval --name docker-completions '
      if [[ ! -f $HOME/.zfunc/_docker ]]; then
        docker completion zsh > $HOME/.zfunc/_docker
      fi
    '

    # doppler
    zgenom eval --name doppler-completions '
      if [[ ! -f $HOME/.zfunc/_doppler ]]; then
        doppler completion zsh > $HOME/.zfunc/_doppler
      fi
    '

    # ipinfo
    zgenom eval --name ipinfo-completions '
      if [[ -f /opt/homebrew/bin/ipinfo ]]; then
        complete -o default -C /opt/homebrew/bin/ipinfo ipinfo
      fi
    '

    # always load syntax highlighting at the end
    zgenom load zdharma-continuum/fast-syntax-highlighting

    zgenom save

    exec zsh
  fi
}
