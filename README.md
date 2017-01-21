# scan-hkeys

Containerized utility to scan Redis keys and print hkeys of any hashes.

<img src='https://raw.githubusercontent.com/evanx/scan-hkeys/master/docs/readme/images/options.png'>


## Config

See `app/config.js`
```javascript
    pattern: {
        description: 'the matching pattern for Redis scan',
        example: '*'
    },
    port: {
        description: 'the Redis port',
        default: 6379
    },
    host: {
        description: 'the Redis host',
        default: 'localhost'
    },
```
where the default Redis `host` is `localhost`

## Implementation

See `app/index.js`
```javascript
```

## Docker

```shell
docker build -t hget https://github.com/evanx/scan-hkeys.git
```
where tagged as image `scan-hkeys`

```shell
docker run --network=host -e pattern='*' scan-hkeys
```
where `--network-host` connects the container to your `localhost` bridge. The default Redis host `localhost` works in that case.

As such, you should inspect the source:
```shell
git clone https://github.com/evanx/scan-hkeys.git
cd hget
cat Dockerfile
```
```
FROM node:7.4.0
ADD package.json .
RUN npm install
ADD components components
ADD app app
ENV NODE_ENV production
CMD ["node", "--harmony", "app/index.js"]
```

Having reviewed the code, you can also execute as follows:
```
cat package.json
npm install
pattern='*' npm start
```

https://twitter.com/@evanxsummers
