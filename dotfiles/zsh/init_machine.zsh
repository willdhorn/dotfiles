# Install plugins and tools
export FLAG_ZGENOM_INSTALLED="zgenom-installed"

# zgenom and plugins
function _install-zgenom() {
  git clone https://github.com/jandamm/zgenom.git "$zgenom_dir"
  wdh-write-flag $FLAG_ZGENOM_INSTALLED
}
function _install-alias-maker() {
  git clone https://github.com/MefitHp/alias-maker.git "$plugins_dir/alias-maker"
}
# fzf
function _install-fzf() {
  if is-mac; then
    no-has-cmd fzf 'brew install fzf'
  else
    no-has-cmd fzf 'apt install fzf'
  fi
}
function _update-fzf() {
  if is-mac; then
    brew upgrade fzf
  else
    apt upgrade fzf
  fi
}

# edgedb
function _install-edgedb() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.edgedb.com | sh -- -y
}

# go tools
function _install-go-tools() {
  go install github.com/cosmtrek/air@latest
}

# function _check-installed() {
#   # check brew
#   if is-mac; then
#     no-has-cmd "brew" _install-brew 'installing brew'
#   fi
#   # check zgenom
#   no-has-dir "$zgenom_dir" _install-zgenom 'installing zgenom'
#   # chech fzf
#   no-has-cmd fzf _install-fzf 'installing fzf'
#   # check edgedb
#   no-has-cmd "edgedb" _install-edgedb 'installing edgedb-cli'
#   # intall go tools
#   has-cmd "go" "_install-go-tools"
# }

export FLAG_MACHINE_SETUP="machine-setup"
export FLAG_MACHINE_SETUP_SKIPPED="machine-setup-skipped"

# initializize everything that needs to be on a new machine
function wdh-init() {
  cd $HOME # don't know if this is necessary but it doesn't hurt
  # make sure all functions are defined
  source $ZSHDIR/init_machine-mac.zsh
  source $ZSHDIR/init_machine.zsh
  source $ZSHDIR/init_shell.zsh

  # get sudo
  # this is required because brew resets the sudo timestamp
  # before exiting if it wasn't active prior, and we need sudo privliges to
  # set the login shell after brew installs zsh
  echo "Setting the login shell to the brew version of zsh requires sudo privileges"
  sudo echo "Installing brew"
  ## Install ##

  if is-mac; then
    wdh-install-clt
    _install-brew
    # source $HOME/.zshrc # homebre unsources everything for some reason
    wdh-install-brew-shelltools
    wdh-install-brew-devtools

    _set-login-shell
    _install-fonts
  fi

  _install-zgenom
  _install-alias-maker

  _install-fzf

  _install-edgedb

  _install-go-tools
  ## Configure ##

  load-zgenom
  no-has-cmd "configure-plugins" "source $ZSHDIR/plugins.zsh"
  configure-plugins

  echo
  echo "Base machine setup complete."
  echo "If this is a Mac anc you would like to install the apps listed in $ZSHDIR/brewfiles/personal-macapps.brewfile"
  echo "you should run 'wdh-install-brew-macapps'"
  echo
  echo "To start a new shell, run 'exec zsh'"

  wdh-write-flag $FLAG_MACHINE_SETUP

  unset -f wdh-init
}

function wdh-skip-init() {
  wdh-write-flag $FLAG_MACHINE_SETUP
  wdh-write-flag $FLAG_MACHINE_SETUP_SKIPPED
  echo "Skipping base machine setup. If you would like to initialize later run:\n\n 'wdh-init'"
  unset -f wdh-skip-init
}
