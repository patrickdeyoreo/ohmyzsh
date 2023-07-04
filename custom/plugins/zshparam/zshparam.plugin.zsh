# zsh parameters
# see zshparam(1)

typeset -g LISTMAX=0
typeset -g DIRSTACKSIZE=0
typeset -g CORRECT_IGNORE='_*'
typeset -g CORRECT_IGNORE_FILE='*~'
typeset -g HISTSIZE=10000
typeset -g SAVEHIST=10000
typeset -g NULLCMD="${NULLCMD:-cat}"
typeset -g READNULLCMD="${READNULLCMD:-cat}"
typeset -g PROMPT_EOL_MARK='%S@%s'
typeset -g sprompt=(
'%1N:'
'%1F'"'"'${${:-%%R}//'"'"'/'"'"''''"'""'"'}'"'"'%1f:'
'perhaps you meant'
'%2F'"'"'${${:-%%r}//'"'"'/'"'"''''"'""'"'}'"'"'%2f'
'%8F[%8f%7Fy%7f%8F/%8f%7Fn%7f%8F/%8f%7Fe%7f%8F/%8f%7Fa%7f%8F]%8f: '
)
typeset -gH SPROMPT='${(%%)sprompt[*]}'
