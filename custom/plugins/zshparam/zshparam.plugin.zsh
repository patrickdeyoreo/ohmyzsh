# zsh parameters
# see zshparam(1)

LISTMAX=0
DIRSTACKSIZE=0
CORRECT_IGNORE='_*'
CORRECT_IGNORE_FILE='*~'
HISTSIZE=10000
SAVEHIST=10000
NULLCMD="${NULLCMD:-cat}"
READNULLCMD="${READNULLCMD:-cat}"
PROMPT_EOL_MARK='%S@%s'
sprompt=(
'%N:'
'%1F'"'"'${${:-%%R}//'"'"'/'"'"''''"'""'"'}'"'"'%1f:'
'perhaps you meant'
'%2F'"'"'${${:-%%r}//'"'"'/'"'"''''"'""'"'}'"'"'%2f'
'%8F[%8f%7Fy%7f%8F/%8f%7Fn%7f%8F/%8f%7Fe%7f%8F/%8f%7Fa%7f%8F]%8f: '
)
typeset -H SPROMPT='${(%%)sprompt[*]}'
