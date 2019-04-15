const requireAll = require('require-all')

/**
 *  This will load all js files in the gulp directory
 *  in order to load all gulp tasks
 */
requireAll({
  dirname: __dirname + '/gulp',
  filter: /(.*)\.js$/,
  recursive: true
});
