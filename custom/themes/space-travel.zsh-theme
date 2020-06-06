# space-travel.zsh-theme

zmodload zsh/terminfo

() {
  emulate -L zsh
  local index="$(echoti colors)"
  while ((index--)); do
    fg[$((index))]="$(echoti setaf "$((index))")"
    bg[$((index))]="$(echoti setab "$((index))")"
  done
}

function __git_prompt_info {
  local retval=$?
  emulate -LR zsh
  setopt promptpercent promptsubst
  print -P "$(git_prompt_info; exit "$retval")"
  return "$retval"
}

function __virtualenv_prompt_info {
  local retval=$?
  emulate -LR zsh
  setopt promptpercent promptsubst
  print -P "$(virtualenv_prompt_info; exit "$retval")"
  return "$retval"
}

function __virtualenv_version_info {
  local retval=$?
  emulate -LR zsh
  local -A pyvenvcfg=("${(@)=${(@ps.\n.)$(< $VIRTUAL_ENV/pyvenv.cfg)}/ = / }")
  print "$pyvenvcfg[version]"
  return "$retval"
}

function __shrink_path {
  local retval=$?
  emulate -LR zsh
  setopt histsubstpattern extendedglob
  local match mbegin mend
  local curdir="${(D)${1:-.}:P}"
  local prefix="${curdir%%/*}" 
  curdir="${curdir#${prefix}/#}"
  local suffix="${curdir##*/}"
  curdir="${curdir%/#${suffix}}"
  print -f '%s\n' "${prefix}${curdir:W:/:s/#%(#b)(??)??*/${match[1]}*}${suffix}"
  return "$retval"
}


status_color='$fg[$(( $? ? ($? - 1) % 6 + 9 : 7 ))]'

PROMPT='%{'"$status_color"'%}╒(%{'"$reset_color"'%}%7F%B%n%7f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%5F%B%m%5f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%6F%B$(() { setopt noincappendhistory; return "$1"; } "$?"; __shrink_path)%6f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%2F%B%y%2f%b%{'"$status_color"'%})%{'"$reset_color"'%}$(() { setopt noincappendhistory; return "$1"; } "$?"; __virtualenv_prompt_info)$(() { setopt noincappendhistory; return "$1"; } "$?"; __git_prompt_info)
%{'"$status_color"'%}╘(%{'"$reset_color"'%}%(?.%(!.%7F%B#%7f%b.%7F%Bﬦ%7f%b).%7F%B%?%7f%b)%{'"$status_color"'%})%{'"$reset_color"'%} '

ZSH_THEME_GIT_PROMPT_CLEAN_ICON='%B%6F%6f%b'
ZSH_THEME_GIT_PROMPT_DIRTY_ICON='%B%3F%3f%b'
ZSH_THEME_GIT_PROMPT_PREFIX='
%{'"$status_color"'%}╞(%{'"$reset_color"'%}%7F%Bgit%7f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%5F%B'
ZSH_THEME_GIT_PROMPT_SUFFIX='%{'"$status_color"'%})%{'"$reset_color"'%}'
ZSH_THEME_GIT_PROMPT_CLEAN='%5f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}${ZSH_THEME_GIT_PROMPT_CLEAN_ICON}'
ZSH_THEME_GIT_PROMPT_DIRTY='%5f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}${ZSH_THEME_GIT_PROMPT_DIRTY_ICON}'

ZSH_THEME_VIRTUALENV_PREFIX='
%{'"$status_color"'%}╞(%{'"$reset_color"'%}%7F%Benv%7f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%5F%B'
ZSH_THEME_VIRTUALENV_SUFFIX='%5f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%6F%B$(__shrink_path "$VIRTUAL_ENV:h")%6f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%2F%B$(__virtualenv_version_info)%2f%b%{'"$status_color"'%})%{'"$reset_color"'%}'

unset -v status_color

# function __virtualenv_prompt_fix {
#   if [[ -v VIRTUAL_ENV ]]
#   then
#     PROMPT="${${PROMPT#"${PROMPT%%[^[:space:]]*}"}#"($VIRTUAL_ENV:t)"}"
#     PROMPT="${PROMPT#"${PROMPT%%[^[:space:]]*}"}"
#   fi
# }
# precmd_functions+=(__virtualenv_prompt_fix)

# ╒╤═╤╤══
# ╞╧╡╞╧╛
# ╞╡╞╧╛
# │╞╧╛
# ╞╧╛
# ╘╛
# vim:ft=zsh:tw=0
