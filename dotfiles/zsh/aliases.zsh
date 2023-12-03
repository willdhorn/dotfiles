# This file should contain all paths variables/replacements
if has-cmd "$HOME/go/bin/air"; then
  alias air='~/go/bin/air'
fi
# aliases 'fuck' to correct the previous command
if has-cmd "thefuck"; then
  eval $(thefuck --alias)
fi

# BoxBox
alias -g bb='boxbox'

# personal shorthands
alias chez='chezmoi'
alias edb='edgedb'
alias sync-brew='wdh-sync-brew'
alias zgload='zgenom reset && load-zgenom'
