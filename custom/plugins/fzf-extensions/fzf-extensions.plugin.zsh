#!/usr/bin/env zsh
# see fzf(1), rg(1)

# find files with fzf and ripgrep
function fif()
{
  emulate -LR zsh

  if ! (( $# ))
  then
    >&2 print -f 'usage: %s PATTERN [PATH ...]\n' "$0"
    return 2
  fi 

  local IFS=$' \t\n'

  if command -v bat
  then
    local preview=(
      bat
      --style=numbers
      --color=always
      --paging=never
    )
  elif command -v highlight
  then
    local preview=(
      highlight
      --force
      --line-numbers
      --out-format=xterm256
      --style=golden
      --wrap-no-numbers
    )
  else
    local preview=(
      cat
      -b
    )
  fi > /dev/null
  local rg=(
    rg
    --color=never
    --no-column
    --no-heading
    --no-line-number
    --no-hidden
    --smart-case
  )
  local fzf=(
    fzf
    --color='fg:4,fg+:6,hl:2,hl+:5,preview-bg:0,preview-fg:7'
    --color='header:1,info:3,pointer:5,prompt:5,gutter:0,border:5,spinner:2'
    --bind='ctrl-c:abort'
    --bind='change:reload:'"${${(q)rg[@]}[*]}"' --files-with-matches -- {q} '"${${(q)@:2}[*]}"
    --no-info
    --phony
    --preview="${${(q)preview[@]}[*]}"' {} |
      '"${${(q)rg[@]}[*]}"' --color=always --colors=match:style:underline --context=$((FZF_PREVIEW_LINES)) -- {q} ||
      '"${${(q)rg[@]}[*]}"' --color=always --colors=match:style:underline --context=$((FZF_PREVIEW_LINES)) -- {q} {}'
    --query="${(q)1}"
  )
  FZF_DEFAULT_COMMAND="${${(q)rg[@]}[*]}"' --files-with-matches -- '"${${(q)@}[*]}" "${(@)fzf}"
}


# kill processes
function fkill() {
  emulate -LR zsh
  local IFS=$' \t\n'
  local ps=(ps -e -j --no-headers)
  local fzf=(fzf -m --sort --bind='change:reload:'"${${(q)ps[@]}[*]}")
  local kill=(kill "$@")
  while read -r
  do
    kill+=("${${=REPLY[@]}[1]}")
  done < <(FZF_DEFAULT_COMMAND="${${(q)ps[@]}[*]}" "${fzf[@]}")
  if (( $# != ${#kill[@]:1} ))
  then
    print -- "${kill[@]}" && "${kill[@]}"
  fi
}
