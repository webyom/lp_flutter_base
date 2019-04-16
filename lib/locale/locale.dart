import 'package:lp_flutter_base/lp_flutter_base.dart';
import 'build/common.dart';

Map<String, LocaleGetter> _localeMap = {
  'common_id-ID': LocaleCommon.of('id-ID'),
  'common_zh-CN': LocaleCommon.of('zh-CN'),
  'common': LocaleCommon.of('en-US'),
};

class LocaleGetter {
  final Map<String, dynamic> localeMap;

  LocaleGetter(this.localeMap);

  String i18n(List<String> parts) {
    dynamic res = localeMap;
    while (res != null && parts.length > 0) {
      res = res[parts.removeAt(0)];
    }
    return (res ?? '').toString();
  }
}

String getLocaleStringByKey(String key) {
  final parts = key.split('.');
  if (parts.length <= 1) {
    return '';
  }
  final locale = AppInfo.locale ?? '';
  final name = parts.removeAt(0);
  LocaleGetter localeGetter = _localeMap[name + '_' + locale] ?? _localeMap[name];
  if (localeGetter != null) {
    return localeGetter.i18n(parts);
  }
  return '';
}

