export HYPHEN_INSENSITIVE="true" # Disable hyphen-sensitive completion.
export COMPLETION_WAITING_DOTS="true"

setopt AUTO_CD          # Perform cd to path if it's not a command and is a directory
setopt ALWAYS_TO_END    # Move cursor to the end of a completed word.
setopt AUTO_MENU        # Show completion menu on a successive tab press.
setopt AUTO_LIST        # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH # If completed parameter is a directory, add a trailing slash.
setopt COMPLETE_IN_WORD # Complete from both ends of a word.
setopt EXTENDED_GLOB    # Needed for file modification glob modifiers with compinit
unsetopt MENU_COMPLETE  # Do not autoselect the first completion entry.
unsetopt FLOW_CONTROL   # Disable start/stop characters in shell editor.

FPATH="~/.zfunc:${FPATH}"
