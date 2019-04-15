#!/usr/bin/env node

const del = require('del');
const util = require('./util');

util.makeSureInRoot();

try {
  util.execAndLog('flutter clean');
} catch(e) {}

console.log("Deleting 'locale'");
del.sync([
  'lib/locale/locale.dart',
  'lib/locale/build/**'
]);

console.log("Clean finished!");
