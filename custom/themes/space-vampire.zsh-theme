# space-travel.zsh-theme

zmodload zsh/terminfo

() {
  local -i index
  emulate -L zsh
  index=$(echoti colors)
  while ((index--)); do
    fg[$((index))]=$(echoti setaf "$((index))")
  done
}

function __git_prompt_info {
  local retval=$?
  emulate -LR zsh
  setopt promptbang promptpercent promptsubst
  print -P "$(git_prompt_info; exit "$retval")"
  return "$retval"
}

function __virtualenv_prompt_info {
  local retval=$?
  emulate -LR zsh
  setopt promptbang promptpercent promptsubst
  print -P "$(virtualenv_prompt_info; exit "$retval")"
  return "$retval"
}

function __virtualenv_version_info {
  local retval=$?
  emulate -LR zsh
  setopt promptbang promptpercent promptsubst
  local -A pyvenvcfg=("${(@)=${(@ps.\n.)$(< $VIRTUAL_ENV/pyvenv.cfg)}/ = / }")
  print "$pyvenvcfg[version]"
  return "$retval"
}

function __shrink_path {
  local retval=$?
  emulate -LR zsh
  setopt extendedglob promptpercent
  local match mbegin mend
  local prefix=${${(D)1-${(%)$(cat <<<%~)}}%%/*}
  local suffix=${${(D)1-${(%)$(cat <<<%~)}}##$prefix(*/)#}
  local middle=${${${(D)1-${(%)$(cat <<<%~)}}/#%(#b)$prefix(*)$suffix/$match[1]}:W:/:s/#%(#b)(??)??##/$match[1]*}
  print "$prefix$middle$suffix"
  return "$retval"
}

status_color='$fg[$(( $? ? ($? - 1) % 6 + 1 : 141 ))]'

PROMPT='%{'"$status_color"'%}╒(%{'"$reset_color"'%}%121F%B%n%121f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%212F%B%m%212f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%117F%B$(() { setopt noincappendhistory; return "$1"; } "$?"; __shrink_path)%117f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%228F%B%y%228f%b%{'"$status_color"'%})%{'"$reset_color"'%}$(() { setopt noincappendhistory; return "$1"; } "$?"; __virtualenv_prompt_info)$(() { setopt noincappendhistory; return "$1"; } "$?"; __git_prompt_info)
%{'"$status_color"'%}╘(%{'"$reset_color"'%}%(?.%(!.%121F%B#%121f%b.%121F%Bﬦ%121f%b).%121F%B%?%121f%b)%{'"$status_color"'%})%{'"$reset_color"'%} '

ZSH_THEME_GIT_PROMPT_CLEAN_ICON='%B%117F%117f%b'
ZSH_THEME_GIT_PROMPT_DIRTY_ICON='%B%215F%215f%b'
ZSH_THEME_GIT_PROMPT_PREFIX='
%{'"$status_color"'%}╞(%{'"$reset_color"'%}%121F%Bgit%121f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%212F%B'
ZSH_THEME_GIT_PROMPT_SUFFIX='%{'"$status_color"'%})%{'"$reset_color"'%}'
ZSH_THEME_GIT_PROMPT_CLEAN='%212f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}${ZSH_THEME_GIT_PROMPT_CLEAN_ICON}'
ZSH_THEME_GIT_PROMPT_DIRTY='%212f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}${ZSH_THEME_GIT_PROMPT_DIRTY_ICON}'

ZSH_THEME_VIRTUALENV_PREFIX='
%{'"$status_color"'%}╞(%{'"$reset_color"'%}%121F%Benv%121f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%212F%B'
ZSH_THEME_VIRTUALENV_SUFFIX='%212f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%117F%B$(__shrink_path "$VIRTUAL_ENV:h")%117f%b%{'"$status_color"'%})═(%{'"$reset_color"'%}%228F%B$(__virtualenv_version_info)%228f%b%{'"$status_color"'%})%{'"$reset_color"'%}'

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
