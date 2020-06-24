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
  local -i color="$(( $1 <= 256 ? $1 : 256 ))"
  while (( color-- )); do
    fg[$(( color ))]="$(tinfo setaf "$(( color ))")"
    bg[$(( color ))]="$(tinfo setab "$(( color ))")"
  done
  print -v 'fg[reset]' -f '%b' '\e[39m'
  print -v 'bg[reset]' -f '%b' '\e[49m'
} "$(( $(tinfo colors) ))"

function __git_prompt_info() {
  local retval="$?"
  emulate -LR zsh
  setopt promptpercent promptsubst
  print -P "$(git_prompt_info; exit "$retval")"
  return "$retval"
}

function __virtualenv_prompt_info() {
  local retval="$?"
  emulate -LR zsh
  setopt promptpercent promptsubst
  print -P "$(virtualenv_prompt_info; exit "$retval")"
  return "$retval"
}

function __virtualenv_version_info() {
  local retval="$?"
  emulate -LR zsh
  setopt extendedglob
  local -A pyvenvcfg=(${(@f)"${(@f)$(< "$VIRTUAL_ENV/pyvenv.cfg")}"/ #= #/$'\n'})
  print -f '%s\n' "${pyvenvcfg[version]}"
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


PROMPT=''
PROMPT_SEP=$'\u2550'
ZSH_THEME_GIT_PROMPT_PREFIX=''
ZSH_THEME_GIT_PROMPT_SUFFIX=''
ZSH_THEME_GIT_PROMPT_CLEAN=''
ZSH_THEME_GIT_PROMPT_DIRTY=''
ZSH_THEME_GIT_PROMPT_CLEAN_ICON=''
ZSH_THEME_GIT_PROMPT_DIRTY_ICON=''
ZSH_THEME_VIRTUALENV_PREFIX=''
ZSH_THEME_VIRTUALENV_SUFFIX=''

function () {
  emulate -LR zsh
  setopt promptbang promptpercent promptsubst noincappendhistory
  local status_color='${fg[${$(( ($?) ? ($? - 1) % 6 + 1 : 0 )):/0/reset}]}'
  local reset_color="${fg[reset]}${bg[reset]}"

  PROMPT='%{'"${status_color}"'%}╒(%{'"${reset_color}"'%}%7F%B%n%7f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${reset_color}"'%}%5F%B%m%5f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${reset_color}"'%}%6F%B$(__shrink_path)%6f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${reset_color}"'%}%2F%B%y%2f%b%{'"${status_color}"'%})%{'"${reset_color}"'%}$(__virtualenv_prompt_info)$(__git_prompt_info)
%{'"${status_color}"'%}╘(%{'"${reset_color}"'%}%(?.%(!.%7F%B#%7f%b.%7F%Bﬦ%7f%b).%7F%B%?%7f%b)%{'"${status_color}"'%})%{'"${reset_color}"'%} '
  ZSH_THEME_GIT_PROMPT_PREFIX='
%{'"${status_color}"'%}╞(%{'"${reset_color}"'%}%7F%Bgit%7f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${reset_color}"'%}%5F%B'
  ZSH_THEME_GIT_PROMPT_SUFFIX='%{'"${status_color}"'%})%{'"${reset_color}"'%}'
  ZSH_THEME_GIT_PROMPT_CLEAN='%5f%b%{'"${status_color}"'%}'
  ZSH_THEME_GIT_PROMPT_DIRTY='%5f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${reset_color}"'%}${ZSH_THEME_GIT_PROMPT_DIRTY_ICON}'
  ZSH_THEME_GIT_PROMPT_CLEAN_ICON='%B%6F%6f%b' # ﭾ  
  ZSH_THEME_GIT_PROMPT_DIRTY_ICON='%B%1F%1f%b' # ﮊ ﮏ 

  ZSH_THEME_VIRTUALENV_PREFIX='
%{'"${status_color}"'%}╞(%{'"${reset_color}"'%}%7F%Benv%7f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${reset_color}"'%}%5F%B'
  ZSH_THEME_VIRTUALENV_SUFFIX='%5f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${reset_color}"'%}%6F%B$(__shrink_path "$VIRTUAL_ENV:h")%6f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${reset_color}"'%}%2F%B$(__virtualenv_version_info)%2f%b%{'"${status_color}"'%})%{'"${reset_color}"'%}'
}

precmd_functions+=(__virtualenv_prompt_fix)

# ╒╤═╤╤╕
# ╞╧╡╞╧╛
# ╞╡╞╧╛
# │╞╧╛
# ╞╧╛
# ╘╛
#
# vi:et:ft=zsh:sts=2:sw=2:tw=0
