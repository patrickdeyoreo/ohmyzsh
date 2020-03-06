#!/usr/bin/env zsh
# Provides shell functions to create directories and enter them

#######################################
# mkcd - create a directory and cd into it
# USAGE:
#   mkcd [mkdir-options ...] directory
# ARGUMENTS:
#   mkdir-options: options for mkdir
#   directory: path of the directory
#######################################
function mkcd
{
  if [[ $# -gt 0 ]]
  then
    mkdir "$@" && cd -- "${(P)#}"
  else
    printf '%s: usage: %s [mkdir-options] directory\n' "$0" "$0"
  fi
}

#######################################
# mkpu - create a directory and pushd into it
# USAGE:
#   mkpu [mkdir-options ...] directory
# ARGUMENTS:
#   mkdir-options: options for mkdir
#   directory: path of the directory
#######################################
function mkpu
{
  if [[ $# -gt 0 ]]
  then
    mkdir "$@" && pushd -- "${(P)#}"
  else
    printf '%s: usage: %s [mkdir-options] directory\n' "$0" "$0"
  fi
}
