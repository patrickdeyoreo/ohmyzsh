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

function docker-krm
{
  docker kill "$@" &> /dev/null
  docker rm "$@"
}

function docker-krm-all
{
  local containers=( )
  local id=''

  while read -r id
  do
    containers+=("${id}")
  done < <(docker ps -aq)
  if (( ${#containers[@]} ))
  then
    docker kill "${containers[@]}" > /dev/null 2>&1
    docker rm "${containers[@]}" 2> /dev/null
  fi
}
