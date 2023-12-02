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
function wdh_install-brew-shelltools() {
  brew bundle --file="$ZSHDIR/brewfiles/shelltools.brewfile"
  wdh-write-flag $FLAG_BREW_SHELLTOOLS
}
function wdh_install-brew-devtools() {
  brew bundle --file="$ZSHDIR/brewfiles/devtools.brewfile"
  wdh-write-flag $FLAG_BREW_DEVTOOLS
}
function wdh_install-brew-macapps() {
  brew bundle --file="$ZSHDIR/brewfiles/macapps.brewfile"
  if is-silicon-mac; then
    brew bundle --file="$ZSHDIR/brewfiles/macapps-silicon.brewfile"
  fi
  wdh-write-flag $FLAG_BREW_MACAPPS
}

function wdh_install-clt() {
  xcode-select --install
  wdh-write-flag $FLAG_CLT_INSTALLED
}
# set the login shell to the brew version of zsh
function _set-login-shell() {
  local brewzsh="$(brew --prefix)/bin/zsh"
  if [[ $(which zsh) == "$brewzsh" ]]; then
    # already set
    return 0
  fi
  if no-has-file "$brewzsh"; then
    echo "Unable to set login shell to homebrew version of zsh: $brewzsh does not exist"
    return 1
  fi
  echo "Setting login shell to brew version of zsh"
  echo "This may ask for your password"
  sudo chsh -s $brewzsh $USER
  echo "Login shell is now $brewzsh"
  wdh-write-flag $FLAG_LOGIN_SHELL
}
# unpack fonts and install in ~/Library/Fonts
function _install-fonts() {
  mkdir -p ~/Library/Fonts
  tar xf $HOME/.fonts/CascadiaCode.tgz --directory=$HOME/Library/Fonts
  tar xf $HOME/.fonts/MesloLGS_NF.tgz --directory=$HOME/Library/Fonts
  wdh-write-flag $FLAG_FONTS_INSTALLED
}
