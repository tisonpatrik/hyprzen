# Custom shell functions

function reload {
  source ~/.zshrc
}

# Docker purge function - completely clean Docker system
function docker_purge {
  echo "Purging Docker system completely..."
  docker container rm -f $(docker container ls -aq 2>/dev/null) 2>/dev/null
  docker image rm -f $(docker image ls -aq 2>/dev/null) 2>/dev/null
  docker volume rm -f $(docker volume ls -q 2>/dev/null) 2>/dev/null
  docker network rm $(docker network ls -q | grep -v '^bridge$\|^host$\|^none$') 2>/dev/null
  echo "Done."
}

function mkcd {
  mkdir -p "$1" && cd "$1"
}

function .. {
  local d=""
  local limit=$1
  for ((i=1 ; i <= limit ; i++)); do
    d=$d/..
  done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

function fkill {
  local pid
  if [ "$UID" != "0" ]; then
      pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
  else
      pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  fi

  if [ "x$pid" != "x" ]
  then
      echo $pid | xargs kill -"${1:-9}"
  fi
}
