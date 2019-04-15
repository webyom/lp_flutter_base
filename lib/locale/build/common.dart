import 'package:json_annotation/json_annotation.dart';
import '../locale.dart';

part 'common.g.dart';

@JsonLiteral('../src/en-US/common.json', asConst: true)
Map<String, dynamic> get localeCommonENUS => _$localeCommonENUSJsonLiteral;

@JsonLiteral('../src/id-ID/common.json', asConst: true)
Map<String, dynamic> get localeCommonIDID => _$localeCommonIDIDJsonLiteral;

@JsonLiteral('../src/zh-CN/common.json', asConst: true)
Map<String, dynamic> get localeCommonZHCN => _$localeCommonZHCNJsonLiteral;

class LocaleCommon {
  static LocaleGetter of(String code) {
    switch (code) {
      case 'id-ID':
        return LocaleGetter(localeCommonIDID);
      case 'zh-CN':
        return LocaleGetter(localeCommonZHCN);
      default:
        return LocaleGetter(localeCommonENUS);
    }
  }
}
