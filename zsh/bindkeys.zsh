bindkey -v                              # vi mode
bindkey '^K' kill-whole-line            # ctrl-k
bindkey '^[[3~' delete-char
bindkey -a '^[[3~' delete-char
bindkey '^ ' autosuggest-accept         # ctrl+<space>
bindkey '^j' autosuggest-accept         # ctrl+j (because I'm used to copilot mapping)
bindkey '^[[[CE' autosuggest-execute    # ctrl+<enter> (remapped with terminal, see kitty.conf)
