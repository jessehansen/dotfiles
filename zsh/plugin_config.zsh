typeset -g ZSH_AUTOSUGGEST_STRATEGY=(history completion)
typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=magenta,bg=cyan,bold,underline"
typeset -g ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
typeset -g ZSH_AUTOSUGGEST_USE_ASYNC=1
typeset -g ZSH_AUTOSUGGEST_HISTORY_IGNORE="(gc -m *|git commit -m *)"
typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1  # make prompt faster
typeset -g DISABLE_MAGIC_FUNCTIONS=true     # make pasting into terminal faster

typeset -g ENABLE_CORRECTION="false"

zstyle ':bracketed-paste-magic' active-widgets '.self-*'
