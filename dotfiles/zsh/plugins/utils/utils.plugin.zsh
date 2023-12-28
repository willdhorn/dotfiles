#!/usr/bin/env zsh

# I don't actually know if this is needed or the way do do it
# but it seems to be the structure of every other plugin
# I mean this file, not the evals.
# This is a mess.
eval $(cat $ZSHDIR/plugins/utils/opts/editor.zsh)
eval $(cat $ZSHDIR/plugins/utils/opts/history.zsh)
eval $(cat $ZSHDIR/plugins/utils/opts/completion.zsh)
