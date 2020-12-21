#!/usr/bin/env zsh
# see fzf(1), rg(1)


# find files with fzf and ripgrep
function fzg() {

  emulate -LR zsh

  local -xT FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}" fzf_default_opts ' '
  local -xT FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND}" fzf_default_command ' '
  local -a rg=(
    rg --color=never --no-column --no-heading --hidden --no-line-number
  )
  local -a fzf=(
    fzf
    --bind="change:reload:${${(q)rg[@]}[*]} --files-with-matches -- {q} ${2+${(q)@:2}}"
    --query="${1:+${(q)1}}"
    --phony
  )
  local -a preview=(
    cat -b
  )
  local IFS=$' \t\n'

  if ! (( $# )); then
    >&2 print -f 'usage: %s SEARCH [PATH ...]\n' -- "$0"
    return 2
  fi 

  if (( ${+tmux_pane} && ${fzf_tmux-0} && ${lines:-40} > 20 )); then
    fzf[1,1]=(fzf-tmux -d "${fzf_tmux_height:-42%}" "${fzf[@]}")
  fi

  if command -v bat; then
    preview=(bat --color='always' --paging='never' --style='numbers')
  elif command -v highlight && [[ ${TERM} == (*-direct|allacrity|linux|st|tmux|xterm)(|-*) ]]; then
    preview=(highlight --force --line-numbers --wrap-no-numbers --out-format='truecolor')
  elif command -v highlight && [[ ${TERM} == *-256color(|-*) ]]; then
    preview=(highlight --force --line-numbers --wrap-no-numbers --out-format='xterm256')
  fi > /dev/null

  fzf+=(--preview="
  { ${${(q)preview[@]}[*]} -- {} |
    ${${(q)rg[@]}[*]} --color=always --passthru -- {q} ||
    ${${(q)rg[@]}[*]} --color=always --passthru -- {q} {}
  } 2> /dev/null")

  fzf_default_opts+=(
    --bind="'"'ctrl-j:replace-query+print-query'"'"
    --bind="'"'ctrl-k:kill-line'"'"
    --bind="'"'ctrl-c:abort'"'"
    --bind="'"'ctrl-x:execute-silent%rifle -- {}%'"'"
    --bind="'"'alt-x:execute-silent%tmux new-window ranger --selectfile={}%'"'"
    --border="'"'sharp'"'"
    --preview-window="'"'top:54%'"'"
    --layout="'"'reverse-list'"'"
  )

  fzf_default_command=(
    "${(q)rg[@]}" '--files-with-matches' '--' "${(q)@}"
  )

  "${fzf[@]}"
}


# kill processes
function fzkill() {

  emulate -LR zsh

  local -xT FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}" fzf_default_opts ' '
  local -xT FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND}" fzf_default_command ' '
  local -a fzf
  local -a ps
  local -a pids
  local -a reply
  local OPTIND=1
  local OPTARG
  local IFS=$' \t\n'

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
      PS_FORMAT="${PS_FORMAT:-}" ps -u "${USER:$(id -nu)}" -w -w --no-headers
      -o 'pid,ppid,sid,tname,stat,user,command'
    )
  else
    ps=(
      PS_FORMAT="${PS_FORMAT:-}" ps -e -w -w --no-headers
      -o 'pid,ppid,sid,tname,stat,user,command'
    )
  fi
  if (( ${+tmux_pane} && ${fzf_tmux-0} && ${lines:-40} > 20 )); then
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

fzman () {

  emulate -LR zsh

  local -xT FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}" fzf_default_opts ' '
  local -xT FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND}" fzf_default_command ' '
  local -a fzf=(
    fzf
    --bind="change:reload:man -k -- {q}"
    --query="${1:+${(q)1}}"
    --phony
    --preview='man -- {1}'
  )
  local selected=''
  local IFS=$' \t\n'

  if ! (( $# )); then
    >&2 print -f 'usage: %s SEARCH\n' -- "$0"
    return 2
  fi 

  if (( ${+tmux_pane} && ${fzf_tmux-0} && ${lines:-40} > 20 )); then
    fzf[1,1]=(fzf-tmux -d "${fzf_tmux_height:-42%}" "${fzf[@]}")
  fi

  fzf_default_opts+=(
    --bind="'"'ctrl-j:replace-query+print-query'"'"
    --bind="'"'ctrl-k:kill-line'"'"
    --bind="'"'ctrl-c:abort'"'"
    --border="'"'sharp'"'"
    --preview-window="'"'top:54%'"'"
    --layout="'"'reverse-list'"'"
  )

  fzf_default_command=(
    'man' '-k' '--' "${(q)@}"
  )

  if [[ -n "${selected::=$("${fzf[@]}")}" ]]; then
    man -- "${selected}"
  fi
}
