import '../locale/locale.dart';

Map<String, String> _cache = {};

String $i18n(String key) {
  if (_cache[key] != null) {
    return _cache[key];
  }
  final res = getLocaleStringByKey(key);
  _cache[key] = res;
  return res;
}

void clearBaseI18nCache() {
  _cache = {};
}
