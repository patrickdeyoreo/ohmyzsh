# docker-shortcuts.plugin.zsh

function docker-kill-all
{
  local containers=( )
  local id=''

  while read -r id
  do
    containers+=("${id}")
  done < <(docker ps -aq)
  if (( ${#containers[@]} ))
  then
    docker kill "${containers[@]}" 2> /dev/null
  fi
}

function docker-rm-all
{
  local containers=( )
  local id=''

  while read -r id
  do
    containers+=("${id}")
  done < <(docker ps -aq)
  if (( ${#containers[@]} ))
  then
    docker rm "${containers[@]}" 2> /dev/null
  fi
}

function docker-kill-rm
{
  docker kill "$@" &> /dev/null
  docker rm "$@"
}

function docker-kill-rm-all
{
  local containers=( )
  local id=''

  while read -r id
  do
    containers+=("${id}")
  done < <(docker ps -aq)
  if (( ${#containers[@]} ))
  then
    docker kill "${containers[@]}" &> /dev/null
    docker rm "${containers[@]}" 2> /dev/null
  fi
}

function docker-rm-exited
{
  local containers=( )
  local id=''

  while read -r id
  do
    containers+=("${id}")
  done < <(docker ps -q --filter 'status=exited')
  if (( "${#containers[@]}" ))
  then
    docker rm "${containers[@]}" 2> /dev/null
  fi
}
