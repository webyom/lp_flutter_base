import 'package:flutter/material.dart';
import '../config.dart';

class LpButton extends StatelessWidget {
  final Widget child;
  final String text;
  final Color textColor;
  final Color borderColor;
  final Color color;
  final Color highlightColor;
  final Color splashColor;
  final Gradient gradient;
  final double width;
  final double height;
  final double fontSize;
  final bool disabled;
  final bool small;
  final bool expand;
  final EdgeInsetsGeometry margin;
  final VoidCallback onPressed;

  LpButton({
    Key key,
    Gradient gradient,
    this.child,
    this.text = 'OK',
    this.textColor = Colors.white,
    this.borderColor,
    this.color,
    this.highlightColor = Colors.white10,
    this.splashColor = Colors.white10,
    this.width = double.infinity,
    this.height,
    this.fontSize,
    this.disabled,
    this.small = false,
    this.expand = false,
    this.margin,
    this.onPressed,
  })  : this.gradient = gradient ??
            LinearGradient(
              colors: <Color>[
                disabled == true
                    ? COLOR_DISABLED
                    : color ?? const Color(0xfff38b34),
                disabled == true
                    ? COLOR_DISABLED
                    : color ?? const Color(0xffff581d)
              ],
            ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var useHeight = height ?? (small ? 29.0 : 45.0);
    var useFontSize = fontSize ?? (small ? 12.0 : 16.0);

    return Container(
      margin: margin,
      constraints: BoxConstraints(
        minWidth: width != double.infinity ? width : 0.0,
        maxWidth: width != double.infinity ? width : double.infinity,
        minHeight: useHeight,
        maxHeight: useHeight,
      ),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(useHeight),
        border: disabled != true && borderColor != null
            ? Border.all(color: borderColor)
            : null,
      ),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(useHeight),
        ),
        color: Colors.transparent,
        child: InkWell(
          highlightColor: highlightColor,
          splashColor: splashColor,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(useHeight),
          ),
          onTap: disabled == true ? null : onPressed,
          child: Center(
            widthFactor: expand ? null : 1.0,
            heightFactor: 1.0,
            child: Container(
              padding:
                  EdgeInsets.fromLTRB(useHeight / 3, 0.0, useHeight / 3, 0.0),
              child: child ??
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: disabled == true ? Colors.white : textColor,
                      fontSize: useFontSize,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
