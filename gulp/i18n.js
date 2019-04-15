const path = require('path'),
  gulp = require('gulp'),
  htmlI18n = require('gulp-html-i18n'),
  through = require('through2');

// validate consistence between each lang version
gulp.task('i18n:validate:consistence', function () {
  return gulp.src(['lib/locale/src/**/*.json']).pipe(
    htmlI18n.validateJsonConsistence({
      langDir: 'lib/locale/src'
    })
  );
});

// validate all the i18n key used by dart is define in json
gulp.task('i18n:validate:defined', ['i18n:validate:consistence'], function () {
  return gulp.src(['lib/**/*.dart']).pipe(
    through.obj(function (file, enc, next) {
      const content = file.contents.toString();
      content.replace(/\$i18n\s*\(\s*(['"])(.*?)\1\s*\)/g, function (full, quote, key) {
        key = key.trim();
        if (!key) {
          raiseError();
        }
        const parts = key.split('.');
        const fileName = path.resolve(`lib/locale/src/en-US/${parts.shift()}.json`);
        let jsonObj;
        try {
          jsonObj = require(fileName);
        } catch (err) {
          raiseError();
        }
        while (parts.length) {
          jsonObj = jsonObj[parts.shift()];
        }
        if (typeof jsonObj != 'string') {
          if (jsonObj == null) {
            raiseError();
          } else {
            raiseError(`Must be "String" type.`);
          }
        }
        function raiseError(detail = '') {
          throw new Error(`Invalid i18n key "${key}" in file ${file.path}. ${detail}`);
        }
      });
      next();
    })
  );
});

// sort key in lang json
// caution!!! this will overwrite the source file in src folder!!!
gulp.task('i18n:sort', ['i18n:validate:consistence'], function () {
  return gulp
    .src(['lib/locale/src/**/*.json'])
    .pipe(
      htmlI18n.jsonSortKey({
        endWithNewline: true
      })
    )
    .pipe(gulp.dest('lib/locale/src'));
});
