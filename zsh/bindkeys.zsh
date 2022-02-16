bindkey -v                              # vi mode
bindkey '^K' kill-whole-line            # ctrl-k
bindkey '^[[3~' delete-char
bindkey -a '^[[3~' delete-char
bindkey '^ ' autosuggest-accept         # ctrl+<space>
bindkey '^[[[CE' autosuggest-execute    # ctrl+<enter> (remapped with iterm)
