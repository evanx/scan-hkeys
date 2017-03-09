FROM mhart/alpine
ADD package.json .
RUN npm install --silent
ADD components components
ADD lib lib
CMD ["node", "--harmony", "lib/index.js"]
