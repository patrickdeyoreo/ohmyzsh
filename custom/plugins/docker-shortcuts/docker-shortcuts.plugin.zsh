# docker-shortcuts.plugin.zsh

function docker-kill-all
{
  local containers=( )
  IFS=' \t' read -r -A containers < <(docker ps -aq)
  (( $#containers == 0 )) || docker kill "$containers[@]" 2> /dev/null
}

function docker-rm-all
{
  local containers=( )
  IFS=' \t' read -r -A containers < <(docker ps -aq)
  (( $#containers == 0 )) || docker rm "$containers[@]" 2> /dev/null
}

function docker-krm
{
  docker kill "$@" &> /dev/null
  docker rm "$@"
}

function docker-krm-all
{
  local containers=( )
  IFS=' \t' read -r -A containers < <(docker ps -aq)
  (( $#containers == 0 )) || docker-krm "$containers[@]" 2> /dev/null
}
