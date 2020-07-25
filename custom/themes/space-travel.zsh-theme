# space-travel.zsh-theme

if zmodload zsh/terminfo; then
  function tput() {
    echoti "$@"
  }
fi

typeset -AH fg bg
function () {
  emulate -LR zsh
  local -i color="$(( $1 <= 256 ? $1 : 256 ))"
  while (( color-- )); do
    typeset -AgH fg=("${(kv)fg[@]}" "${color}" "$(tput setaf "${color}")")
    typeset -AgH bg=("${(kv)bg[@]}" "${color}" "$(tput setab "${color}")")
  done
  print -v 'fg[-1]' -f '%b' '\e[39m'
  print -v 'bg[-1]' -f '%b' '\e[49m'
} "$(( $(tput colors) ))"

function __shrink_path() {
  function () {
    emulate -LR zsh
    local IFS='/'
    local components=("${(@)${(@s:/:)${(D)^${2:-.}:P}}//\%/%%}")
    components[1,-2]=("%2>*>${(@)^components[1,-2]}")
    print -f '%s\n' -- "${${(%)components[@]}[*]}"
    return "$1"
  } "$?" "$1"
  return "$?"
}

function __git_prompt_info() {
  function () {
    emulate -LR zsh
    setopt promptpercent promptsubst
    git_prompt_info
    return "$1"
  } "$?"
  return "$?"
}

function __virtualenv_prompt_info() {
  function () {
    emulate -LR zsh
    setopt promptpercent promptsubst
    virtualenv_prompt_info
    return "$1"
  } "$?"
  return "$?"
}

function __virtualenv_version_info() {
  function () {
    emulate -LR zsh
    setopt extendedglob
    local -A pyvenvcfg=(${(@f)"${(@f)$(< "${VIRTUAL_ENV}/pyvenv.cfg")}"/ #= #/$'\n'})
    print -f '%s' -- "${pyvenvcfg[version]}" $'\n'
    return "$1"
  } "$?"
  return "$?"
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
  local status_color='${fg[${$(( ($? - 1) % 240 + ($? != 0) ))}]}'
  local normal_color='${fg[-1]}${bg[-1]}'
  PROMPT='%{'"${status_color}"'%}╒(%{'"${normal_color}"'%}%7F%B%n%f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${normal_color}"'%}%5F%B%m%f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${normal_color}"'%}%6F%B$(__shrink_path)%f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${normal_color}"'%}%2F%B%y%f%b%{'"${status_color}"'%})%{'"${normal_color}"'%}${(%%)$(__virtualenv_prompt_info)}${(%%)$(__git_prompt_info)}
%{'"${status_color}"'%}╘(%{'"${normal_color}"'%}%(?.%(!.%7F%B#%f%b.%7F%Bﬦ%f%b).%7F%B%?%f%b)%{'"${status_color}"'%})%{'"${normal_color}"'%} '
  ZSH_THEME_GIT_PROMPT_PREFIX='
%{'"${status_color}"'%}╞(%{'"${normal_color}"'%}%7F%Bgit%f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${normal_color}"'%}%5F%B'
  ZSH_THEME_GIT_PROMPT_SUFFIX='%{'"${status_color}"'%})%{'"${normal_color}"'%}'
  ZSH_THEME_GIT_PROMPT_CLEAN='%f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${normal_color}"'%}${ZSH_THEME_GIT_PROMPT_CLEAN_ICON}'
  ZSH_THEME_GIT_PROMPT_DIRTY='%f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${normal_color}"'%}${ZSH_THEME_GIT_PROMPT_DIRTY_ICON}'
  ZSH_THEME_GIT_PROMPT_CLEAN_ICON='%B%6F%f%b'
  ZSH_THEME_GIT_PROMPT_DIRTY_ICON='%B%1F%f%b'
  ZSH_THEME_VIRTUALENV_PREFIX='
%{'"${status_color}"'%}╞(%{'"${normal_color}"'%}%7F%Benv%f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${normal_color}"'%}%5F%B'
  ZSH_THEME_VIRTUALENV_SUFFIX='%f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${normal_color}"'%}%6F%B$(__shrink_path "${VIRTUAL_ENV:h}")%f%b%{'"${status_color}"'%})${PROMPT_SEP}(%{'"${normal_color}"'%}%2F%B$(__virtualenv_version_info)%f%b%{'"${status_color}"'%})%{'"${normal_color}"'%}'
}

function __virtualenv_prompt_fix() {
  emulate -LR zsh
  if [[ -n ${VIRTUAL_ENV} ]]; then
    typeset -g PROMPT="${PROMPT##[[:blank:]]#[([][[:blank:]]#${VIRTUAL_ENV:t}[[:blank:]]#[])][[:blank:]]#}"
  fi
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
