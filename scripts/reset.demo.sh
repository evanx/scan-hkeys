(
  set -u -e -x
  docker rm -f `docker ps -q -f name=test-hkeys-redis`
  docker network rm test-hkeys-network
)
