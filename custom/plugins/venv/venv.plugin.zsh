# venv.plugin.zsh

# Find the nearest ancestor of a directory with a virtual env as a child.
# If called with no arguments, operate on the current working directory.
# Upon success, the result is appended to the ``reply'' array.
function __nearest_venv_root ()
{
  emulate -LR zsh
  setopt extendedglob globassign noglobsubst
  local REPLY
  [[ -d ${1-.} ]] || return
  REPLY=${1-.}/(../)#(|.)venv/bin/activate(.NY1:A)
  [[ -n $REPLY ]] || return
  reply+=("$REPLY")
}

# venv chpwd hook
function __chpwd_venv_activate ()
{
  emulate -L zsh
  setopt extendedglob noglobsubst noksharrays unset
  local REPLY
  local reply=( )
  if [[ -v VIRTUAL_ENV ]]
  then
    return
  fi
  if ! __nearest_venv_root
  then
    if command -v activate > /dev/null
    then
      unset -f activate
    fi
    return
  fi
  if command -v activate > /dev/null
  then
    if __nearest_venv_root "$OLDPWD" && [[ $reply[1] = $reply[2] ]]
    then
      return
    fi
    unset -f activate
  fi
  trap '
  case $? in
    (*)
      print
      PROMPT_EOL_MARK='"${(q)PROMPT_EOL_MARK}"'
      ;|
    (0)
      print source -- '"${(q)reply[1]}"'
      source -- '"${(q)reply[1]}"'
      ;;
    (*)
      function activate ()
      {
        unset -f activate
        emulate -L zsh
        print source -- '"${(q)reply[1]}"'
        source '"${(q)reply[1]}"'
      }
      print "Run '\''activate'\'' to load the virtual environment"
      ;;
  esac
  ' EXIT
  PROMPT_EOL_MARK=$'\n'
  print 'Found virtual environment in' "${(q)reply[1]:h:h}"
  while print -n 'Activate? [Y/n] ' && read -k 1 -r
  do
    case "${(U)REPLY}" in
      (Y) return 0 ;;
      (N) return 1 ;;
    esac
    echoti el1
    echoti hpa 0
  done
  return 2
}


chpwd_functions+=(__chpwd_venv_activate)
