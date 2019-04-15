import 'package:flutter/material.dart';
import '../util/route.dart';
import '../config.dart';

class LpAppBar extends AppBar {
  LpAppBar({
    Key key,
    String titleText = '',
    Color titleColor,
    Color backgroundColor = Colors.white,
    Color bottomBorderColor,
    Brightness brightness = Brightness.light,
    Brightness iconBrightness,
  }) : super(
          key: key,
          leading: FlatButton(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            highlightColor: Color(0x00000000),
            splashColor: Color(0x00000000),
            child: Image.asset(
              'assets/images/head_back_icon_${iconBrightness == Brightness.dark || brightness == Brightness.light && iconBrightness != Brightness.light ? "dark" : "light"}.png',
              width: 15.0,
            ),
            onPressed: () {
              AppRoute.popCurPage();
            },
          ),
          title: Text(
            titleText,
            style: TextStyle(
              color: titleColor ??
                  (brightness == Brightness.light
                      ? Colors.black
                      : Colors.white),
              fontSize: 17.5,
              fontWeight: FontWeight.normal,
            ),
          ),
          centerTitle: true,
          backgroundColor: backgroundColor,
          brightness: brightness,
          elevation: 0.0,
          titleSpacing: 0.0,
          bottom: PreferredSize(
            child: Container(
              color: bottomBorderColor ??
                  (backgroundColor == Colors.white
                      ? COLOR_GRAY_BORDER
                      : backgroundColor),
              height: 0.5,
            ),
            preferredSize: Size.fromHeight(0.5),
          ),
        );
}
