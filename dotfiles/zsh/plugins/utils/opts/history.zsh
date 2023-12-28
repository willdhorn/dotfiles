#!/usr/bin/env zsh
# Original: https://github.com/belak/zsh-utils/blob/main/history/history.plugin.zsh

hist_data_dir="$HOME/.local/share/zsh"
hist_file="$hist_data_dir/history"

[[ -d "$hist_data_dir" ]] || mkdir -p "$hist_data_dir"

# Options

setopt bang_hist              # Treat the '!' character specially during expansion.
setopt extended_history       # Write the history file in the ':start:elapsed;command' format.
setopt inc_append_history     # Write to the history file immediately, not when the shell exits.
unsetopt share_history        # Keep history for different sessions separate.
setopt hist_expire_dups_first # Expire a duplicate event first when trimming history.
setopt hist_ignore_dups       # Do not record an event that was just recorded again.
setopt hist_ignore_all_dups   # Delete an old recorded event if a new event is a duplicate.
setopt hist_find_no_dups      # Do not display a previously found event.
setopt hist_ignore_space      # Do not record an event starting with a space.
setopt hist_save_no_dups      # Do not write a duplicate event to the history file.
setopt hist_verify            # Do not execute immediately upon history expansion.
setopt hist_beep              # Beep when accessing non-existent history.

# Variables

HISTFILE="$hist_file"
HISTSIZE=10000 # The maximum number of events to save in the internal history.
SAVEHIST=10000 # The maximum number of events to save in the history file.

# Aliases

# Lists the ten most used commands.
alias most-used-cmds="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

# Cleanup

unset hist_data_dir hist_file
