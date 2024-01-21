#!/usr/bin/env zsh
# Install plugins and tools
export FLAG_ZGENOM_INSTALLED="zgenom-installed"

# zgenom and plugins
function _install-zgenom() {
  if has-flag $FLAG_ZGENOM_INSTALLED; then return 0; fi
  if [[ -d "$zenom_dir" ]]; then return 0; fi
  git clone https://github.com/jandamm/zgenom.git "$zgenom_dir"
  wdh-write-flag $FLAG_ZGENOM_INSTALLED
}

# go tools
function _install-go-tools() {
  if no-has-cmd go; then
    # fallback if not downloaded from brew
    curl -LO https://get.golang.org/$(uname)/go_installer && chmod +x go_installer && ./go_installer && rm go_installer
  fi

  go install github.com/cosmtrek/air@latest
  go install github.com/rinchsan/gosimports/cmd/gosimports@latest
}

# fix annoying bonk for 'invalid' shortcuts macOS bug
function _fix-bonk() {
  if is-mac; then
    local key_bindings_dir="$HOME/Library/KeyBindings"
    local key_bindings_file="$key_bindings_dir/DefaultKeyBinding.dict"
    local content='{
    "@^\UF701" = "noop:";
    "@^\UF702" = "noop:";
    "@^\UF703" = "noop:";
}'
    mkdir -p "$key_bindings_dir"
    echo "$content" >"$key_bindings_file"
  fi
}

export FLAG_MACHINE_SETUP="machine-setup"
export FLAG_MACHINE_SETUP_SKIPPED="machine-setup-skipped"

# initializize everything that needs to be on a new machine
function wdh-init() {
  cd $HOME # don't know if this is necessary but it doesn't hurt
  # make sure all functions are defined
  if is-mac; then
    source $ZSHDIR/init_machine-mac.zsh
  fi
  source $ZSHDIR/load_zgenom.zsh
  # source $ZSHDIR/init_shell.zsh

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
    _set-login-shell
    wdh-install-colemakdh
    _fix-bonk
  fi

  _install-zgenom

  _install-go-tools
  ## Configure ##

  load-zgenom

  echo
  echo "Base machine setup complete."
  echo "Your shell should be ready to go."
  echo
  echo "If not, to start a new shell, run:"
  echo
  echo 'exec zsh'

  wdh-write-flag $FLAG_MACHINE_SETUP

  unset -f wdh-init
}

wdh-init
