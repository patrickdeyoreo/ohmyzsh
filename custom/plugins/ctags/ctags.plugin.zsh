#!/usr/bin/env zsh
# Provides shell functions to generate tags files

#######################################
# ctags-all - recursively generate '.tags' files
# USAGE:
#   ctags-all [directory]
# ARGUMENTS:
#   directory: the directory to operate on (default '.')
#######################################
function ctags-all()
(
  emulate -R zsh
  dirs -- "${1:-.}"
  while popd -q 2> /dev/null
  do
    if files=(./**/*.*(.)) 2> /dev/null
    then
      dirstack+=(*(/-N:a))
      ctags -f .tags "${files[@]}"
    fi
  done
)
