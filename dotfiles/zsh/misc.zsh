#!/usr/bin/env zsh
# Miscellaneous things that i don't know where else to put

# bind cmd+backspace to delete line
bindkey "^U" backward-kill-line

# docker completions
source <(docker completion zsh)
