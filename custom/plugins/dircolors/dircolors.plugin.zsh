#!/usr/bin/env zsh
# Define and execute a function to load LS_COLORS

typeset -Tx 'LS_COLORS' 'ls_colors' ':'

# Load LS_COLORS from the nearest `dircolors' file
# usage: load_ls_colors [DIRECTORY ...]
function load_ls_colors()
{
  emulate -L zsh
  set -- "${^@}"/(|.)dircolors(NY1:A)
  if (( $# ))
  then
    LS_COLORS="${${(@fs"'")$(dircolors -b -- "$1")}[2]}"
  else
    LS_COLORS="${${(@fs"'")$(dircolors -b)}[2]}"
  fi
}
load_ls_colors "${XDG_CONFIG_HOME:-${HOME}/.config}" "${HOME}"
