#!/usr/bin/env zsh
# see fzf(1), rg(1)

# find files with fzf and ripgrep
function fif
{
  emulate -L zsh
  if (( $# != 1 ))
  then
    print >&2 -f 'usage: %s pattern\n' "$0"
    return 1
  fi 
  if command -v bat
  then
    local preview=(
      "bat"
      "--style=numbers"
      "--color=always"
      "--paging=never"
    )
  elif command -v highlight
  then
    local preview=(
      "highlight"
      "--force"
      "--line-numbers"
      "--out-format=xterm256"
      "--style=golden"
      "--wrap-no-numbers"
    )
  else
    local preview=(
      "cat"
      "-b"
    )
  fi > /dev/null
  local IFS=$' \t\n'
  local rg=(
    rg
    --color=never
    --no-column
    --no-heading
    --no-line-number
    --smart-case
  )
  local fzf=(
    fzf
    --color="header:221,info:81,pointer:176,prompt:176,gutter:234"
    --color="bg:234,bg+:234,fg:81,fg+:114,hl:176,hl+:81"
    --color="border:176,spinner:210,preview-bg:234,preview-fg:250"
    --bind="ctrl-c:abort"
    --bind="change:reload:${${(@q)rg}[*]} --files-with-matches -- {q}"
    --no-info
    --phony
    --preview="${${(@q)preview}[*]} {} |
      ${${(@q)rg}[*]} --color=always --colors=match:fg:210 --context=\$((FZF_PREVIEW_LINES)) -- {q} ||
      ${${(@q)rg}[*]} --color=always --colors=match:fg:210 --context=\$((FZF_PREVIEW_LINES)) -- {q} {}"
    --query "${(q)1}"
  )
  FZF_DEFAULT_COMMAND="${${(@q)rg}[*]} --files-with-matches -- ${(q)1}" "${(@)fzf}"
}
