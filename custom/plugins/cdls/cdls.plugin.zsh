#!/usr/bin/env zsh
# Provides shell functions to enter directories list their contents

#######################################
# cdls - cd into a directory and list its contents
# USAGE:
#   cdls [ls-options ...] directory
# ARGUMENTS:
#   ls-options: options for ls
#   directory: path of the directory
#######################################
function cdls
{
  if (( $# ))
  then
    cd -- "${(P)#}" && ls "${@:1:-1}"
  else
    cd && ls
  fi
}

#######################################
# puls - pushd into a directory and list its contents
# USAGE:
#   puls [ls-options ...] directory
# ARGUMENTS:
#   ls-options: options for ls
#   directory: path of the directory
#######################################
function puls
{
  if [[ $# -gt 0 ]]
  then
    pushd -- "${(P)#}" && ls "${@:1:-1}"
  else
    printf '%s: usage: %s [ls-options] directory\n' "$0" "$0"
  fi
}
