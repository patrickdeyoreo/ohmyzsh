# space-travel.zsh-theme

if zmodload zsh/terminfo; then
  function tinfo() { echoti "$@"; }
else
  function tinfo() { tput "$@"; }
fi

typeset -A -H fg
typeset -A -H bg

function () {
  emulate -LR zsh
  local -i color="$(( $(($1)) <= 256 ? $(($1)) : 256 ))"
  while (( color-- )); do
    fg[$(( color ))]="$(tinfo setaf "$(( color ))")"
    bg[$(( color ))]="$(tinfo setab "$(( color ))")"
  done
  print -v 'fg[reset]' -f '%b' '\e[39m'
  print -v 'bg[reset]' -f '%b' '\e[49m'
} "$(tinfo colors)"

function __git_prompt_info() {
  local retval="$?"
  emulate -LR zsh
  setopt promptpercent promptsubst
  print -P "$(__rainbow "$(git_prompt_info; exit "$retval")" 1o; exit "$retval")"
  return "$retval"
}

function __virtualenv_prompt_info() {
  local retval="$?"
  emulate -LR zsh
  setopt promptpercent promptsubst
  print -P "$(__rainbow "$(virtualenv_prompt_info; exit "$retval")" 1o; exit "$retval")"
  return "$retval"
}

function __virtualenv_version_info() {
  local retval="$?"
  emulate -LR zsh
  setopt extendedglob
  local -A pyvenvcfg=(${(@f)"${(@f)$(< "$VIRTUAL_ENV/pyvenv.cfg")}"/ #= #/$'\n'})
  print -f '%s\n' "$(__rainbow "${pyvenvcfg[version]}" 1o; exit "$retval")"
  return "$retval"
}

function __virtualenv_prompt_fix() {
  emulate -LR zsh
  setopt extendedglob
  if (( ${+VIRTUAL_ENV} ))
  then
    PROMPT="${PROMPT## #\( #${VIRTUAL_ENV:t} #\) #}"
  fi
}

function __rainbow() {
  local retval="$?"
  emulate -LR zsh
  setopt promptpercent promptsubst
  local -a rainbow=(
    "$fg[154]" "$fg[148]" "$fg[184]" "$fg[178]" "$fg[214]" "$fg[208]"
    "$fg[209]" "$fg[203]" "$fg[204]" "$fg[198]" "$fg[199]" "$fg[163]"
    "$fg[164]" "$fg[128]" "$fg[129]" "$fg[93]"  "$fg[99]"  "$fg[63]"
    "$fg[69]"  "$fg[33]"  "$fg[39]"  "$fg[38]"  "$fg[44]"  "$fg[43]" 
    "$fg[49]"  "$fg[48]"  "$fg[84]"  "$fg[83]"  "$fg[119]" "$fg[118]"
  )
  local string="${(%)1}"
  local result=''
  local -i idx='0'
  local -i phi="$2"
  while ((idx++ < $#string)); do
    result+="%{$rainbow[(idx + phi) % $#rainbow]%}$string[idx]"
  done
  print -P "$result%{$reset_color%}"
  return "$retval"
}

function __shrink_path() {
  local retval="$?"
  emulate -LR zsh
  setopt extendedglob histsubstpattern
  local match mbegin mend
  local curdir="${(D)${1:-.}:P}"
  local prefix="${curdir%%/*}" 
  curdir="${curdir#${prefix}}"
  local suffix="${curdir##*/}"
  curdir="${curdir%${suffix}}"
  print -f '%s\n' "${prefix}${curdir:W:/:s/#%(#b)(??)??*/${match[1]}*}${suffix}"
  return "$retval"
}

status_color='${fg[${${?:/0/$(( ($? - 1) % 6 ))/}:/7/reset}]}'
reset_color='${fg[reset]}${bg[reset]}'
prompt_sep=$'\u2550'

PROMPT='%{'"$status_color"'%}╒(%{'"$reset_color"'%}%B$(function () { setopt noincappendhistory; return "$1"; } "$?"; __rainbow "%n" 10)%b%{'"$status_color"'%})${prompt_sep}(%{'"$reset_color"'%}%B$(function () { setopt noincappendhistory; return "$1"; } "$?"; __rainbow "%m" 10)%b%{'"$status_color"'%})${prompt_sep}(%{'"$reset_color"'%}%B$(function () { setopt noincappendhistory; return "$1"; } "$?"; __rainbow "$(function () { setopt noincappendhistory; return "$1"; } "$?"; __shrink_path)" 10)%b%{'"$status_color"'%})${prompt_sep}(%{'"$reset_color"'%}%B$(function () { setopt noincappendhistory; return "$1"; } "$?"; __rainbow "%y" 10)%b%{'"$status_color"'%})%{'"$reset_color"'%}%{'"$reset_color"'%}%{'"$reset_color"'%}
%{'"$status_color"'%}╘(%{'"$reset_color"'%}%(?.%(!.%7F%B#%7f%b.%7F%B$(function () { setopt noincappendhistory; return "$1"; } "$?"; __rainbow "ﬦ" 10)%7f%b).%7F%B$(function () { setopt noincappendhistory; return "$1"; } "$?"; __rainbow "%?" 10)%7f%b)%{'"$status_color"'%})%{'"$reset_color"'%} '
ZSH_THEME_GIT_PROMPT_CLEAN_ICON='%B%6F%6f%b' # ﭾ  
ZSH_THEME_GIT_PROMPT_DIRTY_ICON='%B%3F%3f%b' # ﮊ ﮏ 
ZSH_THEME_GIT_PROMPT_PREFIX='
%{'"$status_color"'%}╞(%{'"$reset_color"'%}$(function () { setopt noincappendhistory; return "$1"; } "$?"; __rainbow "git" 10)%{'"$status_color"'%})${prompt_sep}(%{'"$reset_color"'%}%5F%B'
ZSH_THEME_GIT_PROMPT_SUFFIX='%{'"$status_color"'%})%{'"$reset_color"'%}'
ZSH_THEME_GIT_PROMPT_CLEAN='%5f%b%{'"$status_color"'%}'
ZSH_THEME_GIT_PROMPT_DIRTY='%5f%b%{'"$status_color"'%})${prompt_sep}(%{'"$reset_color"'%}${ZSH_THEME_GIT_PROMPT_DIRTY_ICON}'

ZSH_THEME_VIRTUALENV_PREFIX='
%{'"$status_color"'%}╞(%{'"$reset_color"'%}$(function () { setopt noincappendhistory; return "$1"; } "$?"; __rainbow "env" 10)%{'"$status_color"'%})${prompt_sep}(%{'"$reset_color"'%}%5F%B'
ZSH_THEME_VIRTUALENV_SUFFIX='%5f%b%{'"$status_color"'%})${prompt_sep}(%{'"$reset_color"'%}$(function () { setopt noincappendhistory; return "$1"; } "$?"; __rainbow "$(__shrink_path "$VIRTUAL_ENV:h")" 10)%{'"$status_color"'%})${prompt_sep}(%{'"$reset_color"'%}$(__virtualenv_version_info)%{'"$status_color"'%})%{'"$reset_color"'%}'

unset -v status_color

precmd_functions+=(__virtualenv_prompt_fix)

# ╒╤═╤╤╕
# ╞╧╡╞╧╛
# ╞╡╞╧╛
# │╞╧╛
# ╞╧╛
# ╘╛
#
# vi:et:ft=zsh:sts=2:sw=2:tw=0
