(
  set -u -e 
  if docker network ls | grep test-hkeys-network
  then
    for container in `docker ps -q -f name=test-hkeys-redis`
    do
      docker rm -f $container
    done
    for name in `docker network inspect test-hkeys-network | jq '.[].Containers' | grep 'Name' | sed 's/^.* "\(.*\)",$/\1/'`
    do
      echo 'Try:'
      echo "  docker rm -f $name"
    done
    docker network rm test-hkeys-network
  else
    echo "no such network"
  fi
)
