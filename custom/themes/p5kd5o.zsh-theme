# p5kd5o.zsh-theme
# smooth multi-line prompt

zmodload zsh/terminfo

typeset -AH fg
typeset -AH bg

function () {
  emulate -LR zsh
  local -i color="$(( ($1) < 256 ? ($1) : 256 ))"
  while (( color-- )); do
    typeset -g fg["${color}"]="$(tput setaf "${color}")"
    typeset -g bg["${color}"]="$(tput setab "${color}")"
  done
  print -v 'fg[reset]' -f '%b' '\e[39m'
  print -v 'bg[reset]' -f '%b' '\e[49m'
} "$(( $(tput colors) ))"

function __shrink_path() {
  local retval="$?"
  emulate -LR zsh
  local components=("${(@)${(@s:/:)${(D)^${1:-.}:P}}//\%/%%}")
  components[1,-2]=("${(%)${(@A):-"%2>*>${(@A)^components[1,-2]}"}[@]}")
  print -f %s\\n -- "${(j:/:)components[@]}"
  return "${retval}"
}

function __git_prompt_info() {
  local retval="$?"
  emulate -LR zsh
  setopt promptpercent promptsubst
  2> /dev/null git_prompt_info
  return "${retval}"
}

function __virtualenv_prompt_info() {
  local retval="$?"
  emulate -LR zsh
  setopt promptpercent promptsubst
  2> /dev/null virtualenv_prompt_info
  return "${retval}"
}

function __virtualenv_version_info() {
  local retval="$?"
  emulate -LR zsh
  setopt extendedglob
  local -A pyvenvcfg=()
  if 2> /dev/null pyvenvcfg=(${(@f)"${(@f)$(< "${VIRTUAL_ENV}/pyvenv.cfg")}"/ #= #/$'\n'})
  then
    print -f '%s' -- "${pyvenvcfg[version]}" $'\n'
  else
    print '?.?.?'
  fi
  return "${retval}"
}

function __virtualenv_prompt_fix() {
  emulate -LR zsh
  setopt extendedglob
  if [[ -n ${VIRTUAL_ENV} ]]; then
    typeset -g PROMPT="${PROMPT##[[:blank:]]#[([][[:blank:]]#${VIRTUAL_ENV:t}[[:blank:]]#[])][[:blank:]]#}"
  fi
}

precmd_functions+=(__virtualenv_prompt_fix)

PROMPT=''
PROMPT_SEP=':'
ZSH_THEME_GIT_PROMPT_PREFIX=''
ZSH_THEME_GIT_PROMPT_SUFFIX=''
ZSH_THEME_GIT_PROMPT_CLEAN=''
ZSH_THEME_GIT_PROMPT_DIRTY=''
ZSH_THEME_GIT_PROMPT_CLEAN_ICON=''
ZSH_THEME_GIT_PROMPT_DIRTY_ICON=''
ZSH_THEME_VIRTUALENV_PREFIX=''
ZSH_THEME_VIRTUALENV_SUFFIX=''

# ╭─(pat@xps:~)
# ├─(git:main:✓)
# ├─(venv:~/Code/project/venv:3.10.4)
# ╰% ls -l

function () {
  emulate -LR zsh

  local status_color='${fg[$(( status ? (status - 1) % 6 + 1 : -1 ))]}'
  local normal_color='${fg[reset]}${bg[reset]}'

  typeset -g PROMPT='%{'"${status_color}"'%}╭─(%{'"${normal_color}"'%}%10F%n%f%{'"${status_color}"'%}@%{'"${normal_color}"'%}%14F%m%f%{'"${status_color}"'%}${PROMPT_SEP}%{'"${normal_color}"'%}%13F$(__shrink_path)%f%{'"${status_color}"'%})%{'"${normal_color}"'%}${(%%)$(__virtualenv_prompt_info)}${(%%)$(__git_prompt_info)}
%{'"${status_color}"'%}╰%{'"${normal_color}"'%}%(?.%15F%#%f.%{'"${status_color}"'%}%#%{'"${normal_color}"'%} %15F%?%f %{'"${status_color}"'%}%#%{'"${normal_color}"'%}) '

  typeset -g ZSH_THEME_GIT_PROMPT_PREFIX='
%{'"${status_color}"'%}├─(%{'"${normal_color}"'%}%10Fgit%f%{'"${status_color}"'%}${PROMPT_SEP}%{'"${normal_color}"'%}%14F'

  typeset -g ZSH_THEME_GIT_PROMPT_CLEAN='%f%{'"${status_color}"'%}${PROMPT_SEP}%{'"${normal_color}"'%}${ZSH_THEME_GIT_PROMPT_CLEAN_ICON}'
  typeset -g ZSH_THEME_GIT_PROMPT_CLEAN_ICON='%12F✓%f'
  #typeset -g ZSH_THEME_GIT_PROMPT_CLEAN_ICON='%6F%f'
  typeset -g ZSH_THEME_GIT_PROMPT_DIRTY='%f%{'"${status_color}"'%}${PROMPT_SEP}%{'"${normal_color}"'%}${ZSH_THEME_GIT_PROMPT_DIRTY_ICON}'
  typeset -g ZSH_THEME_GIT_PROMPT_DIRTY_ICON='%9F✗%f'
  #typeset -g ZSH_THEME_GIT_PROMPT_DIRTY_ICON='%1F%f'

  typeset -g ZSH_THEME_GIT_PROMPT_SUFFIX='%{'"${status_color}"'%})%{'"${normal_color}"'%}'

  typeset -g ZSH_THEME_VIRTUALENV_PREFIX='
%{'"${status_color}"'%}├─(%{'"${normal_color}"'%}%10Fenv%f%{'"${status_color}"'%}${PROMPT_SEP}%{'"${normal_color}"'%}%14F'

  typeset -g ZSH_THEME_VIRTUALENV_SUFFIX='%f%{'"${status_color}"'%}${PROMPT_SEP}%{'"${normal_color}"'%}%13F$(__shrink_path "${VIRTUAL_ENV:h}")%f%{'"${status_color}"'%}${PROMPT_SEP}%{'"${normal_color}"'%}%11F$(__virtualenv_version_info)%f%{'"${status_color}"'%})%{'"${normal_color}"'%}'
}

# ╒╤═╤╤╕
# ╞╧╡╞╧╛
# ╞╡╞╧╛
# │╞╧╛
# ╞╧╛
# ╘╛
#
# vi:et:ft=zsh:sts=2:sw=2:tw=0
