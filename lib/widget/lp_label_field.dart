import 'package:flutter/material.dart';
import '../config.dart';

class LpLabelFieldOption {
  final int flex;
  final Widget child;
  final String text;
  final TextStyle textStyle;

  LpLabelFieldOption({
    this.flex = 1,
    this.child,
    this.text,
    this.textStyle,
  }) : assert(
            child == null || text == null && !(child == null && text == null));
}

class LpLabelFieldWidget extends StatelessWidget {
  final BorderSide bottomBorder;
  final EdgeInsetsGeometry padding;
  final LpLabelFieldOption label;
  final LpLabelFieldOption field;

  LpLabelFieldWidget({
    Key key,
    this.bottomBorder = const BorderSide(
      width: 0.5,
      color: COLOR_GRAY_BORDER,
    ),
    this.padding = const EdgeInsets.symmetric(vertical: 16.0, horizontal: 0),
    @required this.label,
    @required this.field,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        border: Border(
          bottom: bottomBorder,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: label.flex,
            child: label.child ??
                Text(
                  label.text,
                  style: label.textStyle ??
                      TextStyle(
                        fontSize: 14.0,
                      ),
                ),
          ),
          Expanded(
            flex: field.flex,
            child: field.child ??
                Text(
                  field.text,
                  textAlign: TextAlign.right,
                  style: field.textStyle ??
                      TextStyle(
                        fontSize: 16.0,
                      ),
                ),
          ),
        ],
      ),
    );
  }
}
