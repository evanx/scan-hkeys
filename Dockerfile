FROM mhart/alpine-node
ADD package.json .
RUN npm install --silent
ADD lib lib
CMD ["node", "lib/index.js"]
