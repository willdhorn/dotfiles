# Install plugins and tools
export FLAG_ZGENOM_INSTALLED="zgenom-installed"

# zgenom and plugins
function _install-zgenom() {
  git clone https://github.com/jandamm/zgenom.git "$zgenom_dir"
  wdh-write-flag $FLAG_ZGENOM_INSTALLED
}

# go tools
function _install-go-tools() {
  go install github.com/cosmtrek/air@latest
}

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
  fi

  _install-zgenom

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
