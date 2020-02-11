# custom zsh completion settings

# rehash upon completion so programs are found immediately after installation
function _force_rehash {
    if (( CURRENT == 1 )); then
      rehash
    fi
    return 1
}

zstyle ':completion:*'  completer _list _expand _force_rehash _complete _match _ignored _correct _approximate _files _prefix
zstyle ':completion:*'  completions true
zstyle ':completion:*'  condition false
zstyle ':completion:*'  expand prefix suffix

# use safe path for completing sudo commands
zstyle ':completion:*:sudo:*' environ PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*'       tag-order all-expansions

zstyle ':completion:*:history-words'  list false

# ignore duplicate entries
zstyle ':completion:*:history-words'  stop yes
zstyle ':completion:*:history-words'  remove-all-dups yes

zstyle ':completion:*' file-sort name
zstyle ':completion:*' glob true
zstyle ':completion:*' ignore-parents parent pwd .. directory

# start menu completion only if no unambiguous initial string was found
zstyle ':completion:*:correct:*'  insert-unambiguous true
zstyle ':completion:*:correct:*'  original true

# activate color-completion
zstyle ':completion:*'  list-colors "${(s.:.)LS_COLORS}"

zstyle ':completion:*'  list-prompt '%S[%p] -- TAB for more --%s'
zstyle ':completion:*'  matcher-list 'm:{[:lower:]}={[:upper:]}'
zstyle ':completion:*'  match-original both

# separate matches into groups
zstyle ':completion:*:matches'  group 'yes'
#zstyle ':completion:*'          group-name ''

zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches%{\e[0m%}'

# describe options in full
zstyle ':completion:*:options'  auto-description '%d'
zstyle ':completion:*:options'  description 'yes'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*'  tag-order indexes parameters

# define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*' ignored-patterns '(*~|*.zwc)'

# Ignore completion functions for commands you don't have:
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '[_.]*'

# allow one error for every three characters typed in correct and approximate completers
zstyle ':completion:*:approximate:*'  max-errors 'reply=( $((($#PREFIX + $#SUFFIX) / 3)) not-numeric )'
zstyle ':completion:*:correct:*'      max-errors 'reply=( $((($#PREFIX + $#SUFFIX) / 3)) not-numeric )'
zstyle ':completion:*:correct'        prompt 'Correct to: %e'

# don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

zstyle ':completion:*' menu select=3
zstyle ':completion:*' old-menu false
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt '%S[%m]%s'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' verbose true
zstyle ':completion:*' word true

zstyle ':compinstall' filename "$0"
autoload -U -z compinit
compinit -i -C
