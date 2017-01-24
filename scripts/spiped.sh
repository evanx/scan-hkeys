(
  set -u -e -x
  mkdir -p tmp
  dd if=/dev/urandom bs=32 count=1 > tmp/test-spiped-keyfile
  docker network create -d bridge test-hkeys-network
  redisContainer=`docker run --network=test-hkeys-network \
      --name test-hkeys-redis -d tutum/redis`
  password=`docker logs $redisContainer | grep '^\s*redis-cli -a' |
      sed -e 's/^\s*redis-cli -a \(\w*\) .*$/\1/'`
  redisHost=`docker inspect $redisContainer |
      grep '"IPAddress":' | tail -1 | sed 's/.*"\([0-9\.]*\)",/\1/'`
  decipherContainer=`docker run --network=test-hkeys-network \
    --name test-decipher -d -v tmp/test-spiped-keyfile:/spiped/key:ro \
    -p 6444:6444 spiped \
    -d -s "[0.0.0.0]:6444" -t "[$redisHost]:6379"`
  decipherHost=`docker inspect $decipherContainer |
    grep '"IPAddress":' | tail -1 | sed 's/.*"\([0-9\.]*\)",/\1/'`
  encipherContainer=`docker run --network=test-hkeys-network \
    --name test-encipher -e -v tmp/test-spiped-keyfile:/spiped/key:ro \
    -p 6379:6379 spiped \
    -d -s "[0.0.0.0]:6379" -t "[$decipherHost]:6444"`
  encipherHost=`docker inspect $encipherContainer |
    grep '"IPAddress":' | tail -1 | sed 's/.*"\([0-9\.]*\)",/\1/'`
  redis-cli -a $password -h $encipherHost hset mytest:64:h name 'Pottery Place'
  redis-cli -a $password -h $encipherHost hset mytest:64:h address '48 High Street'
  docker run --network=test-hkeys-network \
    -e host=$encipherHost -e password=$password \
    -e pattern=mytest:*:h evanxsummers/scan-hkeys
  docker rm -f `docker ps -q -f name=test-redis-hkeys`
  docker network rm test-hkeys-network
)
