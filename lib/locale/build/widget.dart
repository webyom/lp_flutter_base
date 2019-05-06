import 'package:json_annotation/json_annotation.dart';
import '../locale.dart';

part 'widget.g.dart';

@JsonLiteral('../src/en-US/widget.json', asConst: true)
Map<String, dynamic> get localeWidgetENUS => _$localeWidgetENUSJsonLiteral;

@JsonLiteral('../src/id-ID/widget.json', asConst: true)
Map<String, dynamic> get localeWidgetIDID => _$localeWidgetIDIDJsonLiteral;

@JsonLiteral('../src/zh-CN/widget.json', asConst: true)
Map<String, dynamic> get localeWidgetZHCN => _$localeWidgetZHCNJsonLiteral;

class LocaleWidget {
  static LocaleGetter of(String code) {
    switch (code) {
      case 'id-ID':
        return LocaleGetter(localeWidgetIDID);
      case 'zh-CN':
        return LocaleGetter(localeWidgetZHCN);
      default:
        return LocaleGetter(localeWidgetENUS);
    }
  }
}
