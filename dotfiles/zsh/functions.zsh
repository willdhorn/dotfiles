# ignore leading dollar signs from copy-pasted commands
$ () {
  "$@"
}

# make accitentally typing ' u' run the last command (happens due to binding QMK nav layer to space and 'up' to NAV('u')
u () { 
  fc -s 
}

if has-cmd "fzf"; then
  # h - fzf History - Repeat command history history
  function h() {
    print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
  }
  # fzf-tab select with tab
  zstyle ':fzf-tab:*' fzf-flags --bind 'tab:accept'
fi

# ping function that recognizes ssh hosts and aliases
realping=$(which ping)
ping()
{
    # Process args
    local i=0
    local options=""
    local host=""
    for arg
    do
        i=$(($i+1))
        if [ "$i" -lt "$#" ]
        then
            options="${options} ${arg}"
        else
            host="${arg}"
        fi
    done

    # Find host
    local hostname=$(awk "\$1==\"Host\" {host=\$2} \$1==\"HostName\" && host==\"${host}\" {print \$2}" "$HOME/.ssh/config")
    if [ -z "$hostname" ]
    then
        hostname="$host"
    fi

    # Run ping
    $realping $options $hostname
}
