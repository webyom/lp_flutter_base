import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';
import 'package:hybrid_stack_manager/hybrid_stack_manager_plugin.dart';
import 'package:flutter/rendering.dart';
import 'app_info.dart';

export 'app_info.dart';
export 'i18n.dart' show clearBaseI18nCache;
export 'lp_http.dart';
export 'lp_data_cache.dart';
export 'route.dart';
export 'toast.dart';

void configDebug({
  bool paintSizeEnabled,
  bool paintBaselinesEnabled,
  bool paintPointersEnabled,
  bool paintLayerBordersEnabled,
  bool repaintRainbowEnabled,
}) {
  debugPaintSizeEnabled = paintSizeEnabled ?? false;
  debugPaintBaselinesEnabled = paintBaselinesEnabled ?? false;
  debugPaintPointersEnabled = paintPointersEnabled ?? false;
  debugPaintSizeEnabled = paintSizeEnabled ?? false;
  debugPaintLayerBordersEnabled = paintLayerBordersEnabled ?? false;
  debugRepaintRainbowEnabled = repaintRainbowEnabled ?? false;
}

Future callNativeMethod(String method, [Map params]) async {
  return HybridStackManagerPlugin.hybridStackManagerPlugin
      .callNativeMethod(method, params);
}

String md5str(String str) {
  return md5.convert(Utf8Encoder().convert(str)).toString();
}

String formatCurrency(
  num amount, {
  int digits,
  String currency = 'Rp',
}) {
  if (digits == null) {
    if (currency == 'Rp') {
      digits = 0;
    } else {
      digits = 2;
    }
  }
  final digitsFormat =
      digits > 0 ? '.' + List<String>.filled(digits + 1, '').join('0') : '';
  return (currency != '' ? (currency + ' ') : '') +
      NumberFormat('#,##0$digitsFormat', AppInfo.locale).format(amount);
}

abstract class DtFormat {
  static const DATE = 'dd/MM/yyyy';
  static const DATE_WITHOUT_YEAR = 'dd/MM';
  static const DATE_TIME = 'dd/MM/yyyy HH:mm';
  static const DATETIME_WITHOUT_YEAR = 'dd/MM HH:mm';
  static const DATETIME_WITHOUT_YEAR_WITH_SECONDS = 'dd/MM HH:mm:ss';
  static const DATETIME_WITH_SECONDS = 'dd/MM/yyyy HH:mm:ss';
  static const TIME = 'HH:mm';
  static const TIME_WITH_SECONDS = 'HH:mm:ss';
}

String formatDateTime({
  int ms,
  DateTime dateTime,
  String format = DtFormat.DATE_TIME,
}) {
  DateTime dt;
  if (ms != null) {
    dt = DateTime.fromMillisecondsSinceEpoch(ms);
  } else if (dateTime != null) {
    dt = dateTime;
  } else {
    dt = DateTime.now();
  }
  return DateFormat(format).format(dt);
}

String interpolateTemplate(
  String tpl,
  Map<String, dynamic> data, {
  String open = '{{',
  String close = '}}',
}) {
  assert(open != close,
      'interpolateTemplate: open tag and close tag must not be same!');
  List<String> res = [];
  dynamic safeAccess(String key, String defaultItem) {
    final parts = key.split('.');
    if (parts.length == 0) {
      return defaultItem;
    }
    dynamic res = data;
    while (res != null && parts.length > 0) {
      res = res[parts.removeAt(0)];
    }
    return res ?? defaultItem;
  }

  tpl.split(open).asMap().forEach((i, part) {
    if (i == 0) {
      res.add(part);
      return;
    }
    final parts = part.split(close);
    final len = parts.length;
    String key, item;
    if (len == 1) {
      item = open + part;
    } else if (len == 2) {
      key = parts[0];
      item = safeAccess(key.trim(), open + key + close).toString() + parts[1];
    } else {
      key = parts.removeAt(0);
      item = safeAccess(key.trim(), open + key + close).toString() +
          parts.join(close);
    }
    res.add(item);
  });
  return res.join('');
}
