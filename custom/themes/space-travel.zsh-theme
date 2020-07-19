# space-travel.zsh-theme

if zmodload zsh/terminfo; then
  function tput() {
    echoti "$@"
  }
fi

function __keep_exit_status() {
  function () {
    "${@:2}"
    return "$1"
  } "$?" "$@"
}

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

function shrink_path() {
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
  setopt promptbang promptpercent promptsubst noincappendhistory
  local -A color=(
    on  '${fg[${$(( ($? - 1) % 240 + ($? != 0) ))}]}'
    off "${fg[-1]}${bg[-1]}"
  )
  PROMPT='%{'"${color[on]}"'%}╒(%{'"${color[off]}"'%}%7F%B%n%f%b%{'"${color[on]}"'%})${PROMPT_SEP}(%{'"${color[off]}"'%}%5F%B%m%f%b%{'"${color[on]}"'%})${PROMPT_SEP}(%{'"${color[off]}"'%}%6F%B$(shrink_path)%f%b%{'"${color[on]}"'%})${PROMPT_SEP}(%{'"${color[off]}"'%}%2F%B%y%f%b%{'"${color[on]}"'%})%{'"${color[off]}"'%}${(%%)$(__virtualenv_prompt_info)}${(%%)$(__git_prompt_info)}
%{'"${color[on]}"'%}╘(%{'"${color[off]}"'%}%(?.%(!.%7F%B#%f%b.%7F%Bﬦ%f%b).%7F%B%?%f%b)%{'"${color[on]}"'%})%{'"${color[off]}"'%} '
  ZSH_THEME_GIT_PROMPT_PREFIX='
%{'"${color[on]}"'%}╞(%{'"${color[off]}"'%}%7F%Bgit%f%b%{'"${color[on]}"'%})${PROMPT_SEP}(%{'"${color[off]}"'%}%5F%B'
  ZSH_THEME_GIT_PROMPT_SUFFIX='%{'"${color[on]}"'%})%{'"${color[off]}"'%}'
  ZSH_THEME_GIT_PROMPT_CLEAN='%f%b%{'"${color[on]}"'%}'
  ZSH_THEME_GIT_PROMPT_DIRTY='%f%b%{'"${color[on]}"'%})${PROMPT_SEP}(%{'"${color[off]}"'%}${ZSH_THEME_GIT_PROMPT_DIRTY_ICON}'
  ZSH_THEME_GIT_PROMPT_CLEAN_ICON='%B%6F%f%b' # ﭾ  
  ZSH_THEME_GIT_PROMPT_DIRTY_ICON='%B%1F%f%b' # ﮊ ﮏ 
  ZSH_THEME_VIRTUALENV_PREFIX='
%{'"${color[on]}"'%}╞(%{'"${color[off]}"'%}%7F%Benv%f%b%{'"${color[on]}"'%})${PROMPT_SEP}(%{'"${color[off]}"'%}%5F%B'
  ZSH_THEME_VIRTUALENV_SUFFIX='%f%b%{'"${color[on]}"'%})${PROMPT_SEP}(%{'"${color[off]}"'%}%6F%B$(shrink_path "$VIRTUAL_ENV:h")%f%b%{'"${color[on]}"'%})${PROMPT_SEP}(%{'"${color[off]}"'%}%2F%B$(__virtualenv_version_info)%f%b%{'"${color[on]}"'%})%{'"${color[off]}"'%}'
}

function __virtualenv_prompt_fix() {
  emulate -LR zsh
  setopt extendedglob
  if (( ${+VIRTUAL_ENV} )); then
    typeset -g PROMPT="${PROMPT## #\( #${VIRTUAL_ENV:t} #\) #}"
  fi
}
precmd_functions+=(__virtualenv_prompt_fix)

function sgr0() {
  tput sgr0
}
preexec_functions+=(sgr0)

# ╒╤═╤╤╕
# ╞╧╡╞╧╛
# ╞╡╞╧╛
# │╞╧╛
# ╞╧╛
# ╘╛
#
# vi:et:ft=zsh:sts=2:sw=2:tw=0
