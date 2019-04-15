import 'package:flutter/material.dart';
import '../util/i18n.dart';
import '../config.dart';

class LpError extends StatelessWidget {
  final String msg;

  LpError({this.msg});

  @override
  Widget build(BuildContext context) {
    final displayMsg = msg == null ? $i18n('common.msg.svrErr') : msg;
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/system_busy.png',
            package: 'lp_flutter_base',
            width: 260.0,
          ),
          Center(
            child: Text(
              displayMsg,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: COLOR_GRAY_TEXT,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
