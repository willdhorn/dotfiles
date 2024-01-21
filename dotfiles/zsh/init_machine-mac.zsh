source $ZSHDIR/dotfile_util.zsh

# brew
export FLAG_BREW_INSTALLED="brew-installed"
export FLAG_BREW_SHELLTOOLS="brew-shelltools-installed"
export FLAG_BREW_DEVTOOLS="brew-devtools-installed"
export FLAG_BREW_MACAPPS="brew-macapps-installed"

export FLAG_CLT_INSTALLED="clt-installed"
export FLAG_LOGIN_SHELL="login-shell-set"
export FLAG_FONTS_INSTALLED="fonts-installed"

# install brew and package install helpers
function _install-brew() {
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
  wdh-write-flag $FLAG_BREW_INSTALLED
}
function wdh-install-brew-shelltools() {
  brew bundle --file="$ZSHDIR/brewfiles/shelltools.brewfile"
  wdh-write-flag $FLAG_BREW_SHELLTOOLS
}
function wdh-install-brew-devtools() {
  brew bundle --file="$ZSHDIR/brewfiles/devtools.brewfile"
  wdh-write-flag $FLAG_BREW_DEVTOOLS
}
function wdh-install-brew-macapps() {
  brew bundle --file="$ZSHDIR/brewfiles/macapps.brewfile"
  if is-silicon-mac; then
    brew bundle --file="$ZSHDIR/brewfiles/macapps-silicon.brewfile"
  fi
  wdh-write-flag $FLAG_BREW_MACAPPS
}
function wdh-sync-brew() {
  wdh-install-brew-shelltools
  wdh-install-brew-devtools
  has-flag $FLAG_BREW_MACAPPS wdh-install-brew-macapps
}

# set the login shell to the brew version of zsh
function _set-login-shell() {
  local brewzsh="$(brew --prefix)/bin/zsh"
  if [[ $(which zsh) == "$brewzsh" ]]; then
    echo "$brewzsh is already the login shell"
    return 0
  fi
  if no-has-file "$brewzsh"; then
    echo "Unable to set login shell to homebrew version of zsh: $brewzsh does not exist"
    return 1
  fi
  echo "Setting login shell to $brewzsh"
  echo "This may ask for your password"
  sudo chsh -s $brewzsh $USER
  echo "Login shell is now $brewzsh"
  wdh-write-flag $FLAG_LOGIN_SHELL
}

function wdh-install-clt() {
  xcode-select --install
  wdh-write-flag $FLAG_CLT_INSTALLED
}

function wdh-install-colemakdh() {
  sudo cp "$DOTFILES/misc/colemakdh/Colemak\ DH.bundle" "/Library/Keyboard Layouts/"
}