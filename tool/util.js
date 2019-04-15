const path = require('path');
const execSync = require('child_process').execSync;

exports.logLine = function () {
  console.log(new Array(100).join('-'));
}

exports.execAndLog = function (...args) {
  console.log(execSync(...args).toString());
};

exports.exitWithError = function (err) {
  console.log(err);
  process.exit(1);
}

exports.makeSureInRoot = function () {
  try {
    const appName = require(path.resolve('./package.json')).name;
    if (appName != 'lp_flutter_base') {
      exports.exitWithError('Please work in project root!');
    }
  } catch (e) {
    exports.exitWithError('Please work in project root!');
  }
};

exports.isYarnAvailable = function () {
  if (yarnAvailable != null) {
    return yarnAvailable;
  }
  try {
    execSync('yarn --version');
    yarnAvailable = true
  } catch (err) {}
  yarnAvailable = false;
  return yarnAvailable;
};
