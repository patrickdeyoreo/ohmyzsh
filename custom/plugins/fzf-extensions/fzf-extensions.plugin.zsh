#!/usr/bin/env zsh
# see fzf(1), rg(1)

# find files with fzf and ripgrep
function fif
{
  emulate -L zsh
  if ! (( $# ))
  then
    print >&2 -f 'usage: %s pattern ...\n' "$0"
    return 1
  fi 
  local IFS=' '
  local rg_options=(
    "--files-with-matches"
    "--hidden"
    "--no-line-number"
    "--no-messages"
    "--no-heading"
    "--smart-case"
  )
  local fzf_options=(
    "--color=header:212,info:121,pointer:117,prompt:141,gutter:232"
    "--color=bg:232,bg+:232,fg:141,fg+:117,hl:117,hl+:228"
    "--color=border:121,marker:121,spinner:212,preview-bg:232,preview-fg:228"
    "--bind abort:ctrl-c"
  )
  if command -v bat
  then
    local preview="bat --style=grid --color=always --paging=never -- {}"
  elif command -v highlight
  then
    local preview="highlight --force --line-numbers --out-format=xterm256 --style=golden --wrap-no-numbers -- {}"
  else
    local preview="cat -b -- {}"
  fi > /dev/null

  rg "${(@)rg_options}" -- "$@" | fzf "${(@)fzf_options}" --preview="${preview} |
    rg --color=always --column --heading --hidden --no-line-number --smart-case --context=40 -- ${${(@q)@}[*]} ||
    rg --color=always --column --heading --hidden --no-line-number --smart-case --context=40 -- ${${(@q)@}[*]} {}"
}
