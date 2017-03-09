
require('redis-app')(
    require('../package'),
    require('./spec'),
    () => require('./main')
).catch(console.error);
