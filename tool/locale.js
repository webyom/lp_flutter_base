#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const del = require('del');
const util = require('./util');

const EOL = '\n';
const LOCALE_DIR = 'lib/locale';
const SRC_DIR = path.join(LOCALE_DIR, 'src');
const BUILD_DIR = path.join(LOCALE_DIR, 'build');
const DEFAULT_LOCALE = 'en-US';

util.makeSureInRoot();

function toCamelCase(str) {
  return str.split(/[\-_]/g).map(function (item, i) {
    if (!item) {
      return '';
    }
    return item[0].toUpperCase() + item.slice(1);
  }).join('');
}

function getLocaleName(locale) {
  return locale.replace(/[\-_]/g, '').toUpperCase();
}

function getLocaleDef(locale, camelName, relativePath) {
  relativePath = relativePath.replace(/\\/g, '/'); // fix windows path
  const localeName = getLocaleName(locale);
  return [
    `@JsonLiteral('${relativePath}', asConst: true)`,
    `Map<String, dynamic> get locale${camelName}${localeName} => _$locale${camelName}${localeName}JsonLiteral;`
  ].join(EOL);
}

const localeList = fs.readdirSync(SRC_DIR);
console.log('Locales: ' + localeList.join(', '));
if (!localeList.includes(DEFAULT_LOCALE)) {
  console.log(`DEFAULT_LOCALE '${DEFAULT_LOCALE}' does not exist!`);
  process.exit(1);
} else {
  console.log(`Default locale: ${DEFAULT_LOCALE}`);
}

util.execAndLog('npx gulp i18n:validate:defined');

console.log("Deleting 'build'");

del([
  `${BUILD_DIR}/**`
]).then(function () {
  fs.mkdirSync(BUILD_DIR);

  const localeExports = ["import '../util/util.dart';"];
  const localeMapEntries = [];

  fs.readdirSync(path.join(SRC_DIR, DEFAULT_LOCALE)).forEach(file => {
    const fileName = file.split('.')[0];
    const name = fileName.replace(/\-/g, '_').toLowerCase();
    const camelName = toCamelCase(name);
    const dartFile = path.join(BUILD_DIR, name + '.dart');
    const contents = [
      "import 'package:json_annotation/json_annotation.dart';",
      "import '../locale.dart';",
      "",
      `part '${name}.g.dart';`,
      ""
    ];
    const defs = [];
    const getter = [
      `class Locale${camelName} {`,
      '  static LocaleGetter of(String code) {',
      '    switch (code) {'
    ];
    localeList.forEach(locale => {
      const srcFile = path.join(SRC_DIR, locale, file);
      if (!fs.existsSync(srcFile)) {
        return;
      }
      const relativePath = path.relative(path.dirname(dartFile), srcFile);
      defs.push(getLocaleDef(locale, camelName, relativePath));
      if (locale != DEFAULT_LOCALE) {
        getter.push(`      case '${locale}':`);
        getter.push(`        return LocaleGetter(locale${camelName}${getLocaleName(locale)});`);
        localeMapEntries.push(`  '${fileName}_${locale}': Locale${camelName}.of('${locale}'),`);
      }
    });
    getter.push(`      default:`);
    getter.push(`        return LocaleGetter(locale${camelName}${getLocaleName(DEFAULT_LOCALE)});`);
    getter.push('    }');
    getter.push('  }');
    getter.push('}');
    localeMapEntries.push(`  '${fileName}': Locale${camelName}.of('${DEFAULT_LOCALE}'),`);
    contents.push(defs.join(EOL + EOL) + EOL);
    contents.push(getter.join(EOL) + EOL);
    fs.writeFileSync(dartFile, contents.join(EOL));
    localeExports.push(`import 'build/${name}.dart';`);
  });

  localeExports.push('');
  localeExports.push('Map<String, LocaleGetter> _localeMap = {');
  localeExports.push(localeMapEntries.join(EOL));
  localeExports.push('};');
  localeExports.push(fs.readFileSync('tool/locale-getter.tpl'));

  fs.writeFileSync(path.join(LOCALE_DIR, 'locale.dart'), localeExports.join(EOL) + EOL);

  util.execAndLog('flutter packages pub run build_runner build');

  console.log("Build locale finished!");
});
