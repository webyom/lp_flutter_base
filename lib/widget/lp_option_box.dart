import 'package:flutter/material.dart';
import '../config.dart';

class LpOptionBox extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  LpOptionBox(
    this.text, {
    Key key,
    this.active = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final extraBorderWidth = active ? 0.5 : 0;
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(
          16.0 - extraBorderWidth,
          10.0 - extraBorderWidth,
          16.0 - extraBorderWidth,
          10.0 - extraBorderWidth,
        ),
        decoration: BoxDecoration(
          color: active
              ? const Color.fromRGBO(245, 239, 233, 1)
              : const Color(0xfff5f5f5),
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
          border: Border.all(
            width: 0.5 + extraBorderWidth,
            color: active
                ? const Color.fromRGBO(229, 172, 99, 1)
                : const Color(0xffdddddd),
          ),
        ),
        margin: EdgeInsets.fromLTRB(0, 0, 16.0, 16.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12.0,
            color: active
                ? const Color.fromRGBO(235, 138, 51, 1)
                : COLOR_GRAY_TEXT,
          ),
        ),
      ),
    );
  }
}
