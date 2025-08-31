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
alias dn='dotnet'
alias exz='exec zsh'

# general
# ls
alias ll='ls -lh'
alias lht='ls -lht'
alias la='ls -A'
# mkdir
alias mkdir='mkdir -pv'
function mcd() {
  command mkdir -pv "$1" && cd "$1"
}
# chmod
alias chx='chmod +x'

# node
alias ncu="npx npm-check-updates"

# pnpm
alias pn="pnpm"
alias pnr="pnpm run"

# digital ocean
alias droplets='doctl compute droplet list --format Name,PublicIPv4 --no-header'