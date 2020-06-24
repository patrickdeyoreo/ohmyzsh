#!/usr/bin/env zsh
# see fzf(1), rg(1)


# find files with fzf and ripgrep
function fzrg() {

  emulate -LR zsh

  local IFS=$' \t\n'
  local -a rg
  local -a fzf
  local -a preview
  local -xT FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}" fzf_default_opts ' '
  local -xT FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND}" fzf_default_command ' '

  if ! (( $# )); then
    >&2 print -f 'usage: %s PATTERN [PATH ...]\n' "$0"
    return 2
  fi 
  rg=(rg --color=never --no-column --no-heading --hidden --no-line-number)
  if (( ${+TMUX_PANE} && $(( FZF_TMUX )) && $(( ${LINES:-40} )) > 20 )); then
    fzf=(fzf-tmux -d "${FZF_TMUX_HEIGHT:-40%}")
  else
    fzf=(fzf)
  fi
  fzf+=(
    --bind="change:reload:${${(q)rg[@]}[*]} --files-with-matches -- {q} ${2+${(q)@:2}}"
    --query="${1:+${(q)1}}"
    --phony
  )
  if command -v bat; then
    preview=(bat --color='always' --paging='never' --style='numbers')
  elif command -v highlight; then
    preview=(highlight --force --line-numbers --wrap-no-numbers --style='golden')
    if [[ "${TERM}" == (*-direct|allacrity|linux|st|tmux|xterm)(|-*) ]]; then
      preview+=(-out-format='truecolor')
    elif [[ "${TERM}" == *-256color(|-*) ]]; then
      preview+=(--out-format='xterm256')
    fi
  else
    preview=(cat -b)
  fi > /dev/null
  fzf+=(--preview="{
  ${${(q)preview[@]}[*]} -- {} |
  ${${(q)rg[@]}[*]} --color=always --passthru -- {q} ||
  ${${(q)rg[@]}[*]} --color=always --passthru -- {q} {}
} 2> /dev/null")
  fzf_default_opts+=(
    --bind="'"'insert:replace-query'"'"
    --bind="'"'ctrl-\:print-query'"'"
    --bind="'"'ctrl-b:page-up'"'"
    --bind="'"'ctrl-f:page-down'"'"
    --bind="'"'ctrl-j:replace-query+print-query'"'"
    --bind="'"'ctrl-k:kill-line'"'"
    --bind="'"'ctrl-o:execute-silent(printf %s {} | xclip -selection clipboard)'"'"
    --bind="'"'ctrl-c:abort'"'"
    --border="'"'sharp'"'"
    --preview-window="'"'top:62%'"'"
    --layout="'"'reverse-list'"'"
  )
  fzf_default_command=("${(q)rg[@]}" '--files-with-matches' '--' "${(q)@}")
  "${fzf[@]}"
}


# kill processes
function fzkill() {

  emulate -LR zsh

  local IFS=$' \t\n'
  local OPTARG
  local OPTIND=1
  local -a fzf
  local -a ps
  local -a pids
  local -a reply
  local -x PS_FORMAT="${PS_FORMAT:-}"
  local -xT FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}" fzf_default_opts ' '
  local -xT FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND}" fzf_default_command ' '

  while getopts ':s:n:l:h' _; do
    case "${opt}" in
      (h)
        kill -h
        return
        ;;
      (l)
        kill -l "${OPTARG}" "${@[OPTIND,-1]}"
        ;;
      (:)
        kill "${@[OPTIND,-1]}"
        ;;
    esac
  done
  if (( UID )); then
    ps=(
      ps -u "${USER:$(id -nu)}" -w -w --no-headers
      -o 'pid,ppid,sid,tname,stat,user,command'
    )
  else
    ps=(
      ps -e -w -w --no-headers
      -o 'pid,ppid,sid,tname,stat,user,command'
    )
  fi
  if (( ${+TMUX_PANE} && $(( FZF_TMUX )) && $(( ${LINES:-40} )) > 15 )); then
    fzf=(fzf-tmux -d "${FZF_TMUX_HEIGHT:-40%}")
  else
    fzf=(fzf)
  fi
  fzf_default_command=(
    "${(q)ps[@]}"
  )
  fzf_default_opts+=(
    --layout='reverse-list'
  )
  fzf+=(
    --multi
    --bind='change:reload:'"${FZF_DEFAULT_COMMAND}"
    --bind='ctrl-c:abort'
    --query="${argv[OPTIND,-1]}"
    --sort
  )
  while read -r -A reply; do
    pids+=("$((reply[1]))") 2> /dev/null
  done < <("${fzf[@]}")

  if (( ${#pids[@]} )); then
    set -- "${@[1,OPTIND-1]}" "${pids[@]}"
    print -f 'kill %s\n' "${${(q)@}[*]}"
    kill "$@"
  fi
}

# fzman () {
#   if (( ${+TMUX_PANE} && $(( FZF_TMUX )) && $(( ${LINES:-40} )) > 15 ))
#   then
#     local fzf=(fzf-tmux -d "${FZF_TMUX_HEIGHT:-40%}") 
#   else
#     local fzf=(fzf) 
#   fi
#   man -k "$@" | "${fzf[@]}" --border=horizontal --preview-window=bottom --preview='unbuffer sh -c "man {1} | vimpager --force-passthrough --cmd \"set ft=man\" --cmd \"set tw=$((FZF_PREVIEW_COLUMNS))\" -c \"colorscheme squidink\""'
# }
