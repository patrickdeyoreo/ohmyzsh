#!/usr/bin/env zsh
# Provides a shell functions to make a target directory then move stuff into it

#######################################
# mkmv - create a directory and cd into it
# USAGE:
#   mkmv [mv-options ...] sources ... directory
# ARGUMENTS:
#   mkdir-options: options for mkdir
#   directory: path of the directory
#######################################
function mkmv
{
  if [[ $# -gt 0 ]]
  then
    mkdir -- "${(P)#}" && mv "$@"
  else
    printf '%s: usage: %s [mv-options] sources directory\n' "$0" "$0"
  fi
}
