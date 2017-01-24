(
  set -u -e -x
  dd if=/dev/urandom bs=32 count=1 > ~/tmp/test-redis-spiped-keyfile
  docker network create -d bridge test-hkeys-network
  container=`docker run --network=test-hkeys-network \
    --name test-redis-hkeys -d tutum/redis`
  spipedEncryptingContainer=`docker run --network=test-hkeys-network \
      --name test-docker run -d -v ~/tmp/test-redis-spiped-keyfile:/spiped/key:ro \
      --network=host -p 6334:6334 spiped \
      -d -s "[0.0.0.0]:6334" -t "[127.0.0.1]:6379"`
  password=`docker logs $container | grep '^\s*redis-cli -a' |
    sed -e 's/^\s*redis-cli -a \(\w*\) .*$/\1/'`
  redisHost=`docker inspect $container |
    grep '"IPAddress":' | tail -1 | sed 's/.*"\([0-9\.]*\)",/\1/'`
  redis-cli -a $password -h $redisHost hset mytest:64:h name 'Pottery Place'
  redis-cli -a $password -h $redisHost hset mytest:64:h address '48 High Street'
  docker run --network=test-hkeys-network \
    -e host=$redisHost -e password=$password \
    -e pattern=mytest:*:h evanxsummers/scan-hkeys
  docker rm -f `docker ps -q -f name=test-redis-hkeys`
  docker network rm test-hkeys-network
)
