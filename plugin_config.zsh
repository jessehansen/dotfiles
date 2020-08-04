export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=magenta,bg=cyan,bold,underline"
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_HISTORY_IGNORE="(gc -m *|git commit -m *)"

ENABLE_CORRECTION="false"

zstyle ':bracketed-paste-magic' active-widgets '.self-*'
