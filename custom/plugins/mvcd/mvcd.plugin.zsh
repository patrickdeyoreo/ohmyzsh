#!/usr/bin/env zsh
# Provides shell functions to move files to directories and enter them

#######################################
# mvcd - move files into a directory and cd into it
# USAGE:
#   mvcd [mv-options ...] source ... destination
# ARGUMENTS:
#   mv-options: options for mv
#   source: source file(s)
#   destination: target directory
#######################################
function mvcd
{
  if [[ $# -gt 1 ]]
  then
    mv "$@" && cd -- "${(P)#}"
  else
    printf '%s: usage: %s [mv-options ...] source ... destination\n' "$0" "$0"
  fi
}

#######################################
# mvpu - move files into a directory and pushd into it
# USAGE:
#   mvpu [mv-options ...] source ... destination
# ARGUMENTS:
#   mv-options: options for mv
#   source: source file(s)
#   destination: target directory
#######################################
function mvpu
{
  if [[ $# -gt 1 ]]
  then
    mv "$@" && pushd -- "${(P)#}"
  else
    printf '%s: usage: %s [mv-options ...] source ... destination\n' "$0" "$0"
  fi
}
