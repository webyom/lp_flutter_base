
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
  final locale = AppInfo.locale;
  final name = parts.removeAt(0);
  LocaleGetter localeGetter = _localeMap[name + '_' + locale] ?? _localeMap[name];
  if (localeGetter != null) {
    return localeGetter.i18n(parts);
  }
  return '';
}
