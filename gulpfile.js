const requireAll = require('require-all')

/**
 *  This will load all js files in the gulp directory
 *  in order to load all gulp tasks
 */
requireAll({
  dirname: __dirname + '/node_modules/app-node-tool/gulp',
  filter: /(.*)\.js$/,
  recursive: true
});
