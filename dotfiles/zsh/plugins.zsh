# configuration for djui/alias-tips
# function configure-plugin-alias-tips() {
#   export ZSH_PLUGINS_ALIAS_TIPS_TEXT="Alias tip: "
#   export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES="u"
#   # When enabled, a tip will be shown when there is a more concise
#   # alias, even if the command contains an alias.
#   export ZSH_PLUGINS_ALIAS_TIPS_EXPAND=1
#   # When enabled, this will cause alias-tips to abort the command
#   # you have entered if there exists an alias for it.
#   export ZSH_PLUGINS_ALIAS_TIPS_FORCE=0

#   # When enabled, this will reveal the command corresponding to the alias used.
#   export ZSH_PLUGINS_ALIAS_TIPS_REVEAL=1
#   export ZSH_PLUGINS_ALIAS_TIPS_REVEAL_TEXT="Alias tip: "
#   export ZSH_PLUGINS_ALIAS_TIPS_REVEAL_EXCLUDES=(_ ll vi)
# }

# configuration for decayofmind/zsh-fast-alias-tips
function _configure-plugin-fast-alias-tips() {
  export ZSH_FAST_ALIAS_TIPS_EXCLUDES="u"
  export ZSH_FAST_ALIAS_TIPS_PREFIX="💡 $(tput bold)"
  export ZSH_FAST_ALIAS_TIPS_SUFFIX="$(tput sgr0)"
}

# # configuration for fzf-history-search
# function configure-plugin-fzf-history-search() {
#   export ZSH_FZF_HISTORY_SEARCH_BIND='^r'            # Keybind to trigger fzf reverse search
#   export ZSH_FZF_HISTORY_SEARCH_FZF_EXTRA_ARGS=''    # Extra arguments to pass to fzf
#   export ZSH_FZF_HISTORY_SEARCH_END_OF_LINE=''       # Put the cursor on at the end of the line after completion, empty=false
#   export ZSH_FZF_HISTORY_SEARCH_EVENT_NUMBERS=1      # Include event numbers in search. Set to 0 to remove event numbers from the search.
#   export ZSH_FZF_HISTORY_SEARCH_DATES_IN_SEARCH=1    # Include ISO8601 timestamps in search. Set to 0 to remove them from the search.
#   export ZSH_FZF_HISTORY_SEARCH_REMOVE_DUPLICATES='' # Remove duplicate entries from search. Only makes sense with EVENT_NUMBERS and DATE_INSEARCH 0 (false).
# }

# configuration for code completion
# these are not specific to any plugin, but instead
# global zsh options
function _configure-completion-options() {
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
}

function configure-plugins() {
  _configure-plugin-fast-alias-tips
  _configure-completion-options
}
