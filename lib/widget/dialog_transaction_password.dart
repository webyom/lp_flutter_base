import 'package:flutter/material.dart';
import '../util/util.dart';
import '../util/i18n.dart';
import '../config.dart';
import 'widget.dart';

typedef void OnTransactionPasswordSuccess(String pwd);

class TransactionPasswordDialogWidget extends StatefulWidget {
  final bool init;
  final VoidCallback onTapClose;
  final OnTransactionPasswordSuccess onSuccess;

  TransactionPasswordDialogWidget({
    Key key,
    this.init = false,
    @required this.onTapClose,
    @required this.onSuccess,
  }) : super(key: key);

  @override
  _TransactionPasswordDialogWidgetState createState() =>
      _TransactionPasswordDialogWidgetState();
}

class _TransactionPasswordDialogWidgetState
    extends State<TransactionPasswordDialogWidget>
    with LpStateMixin<TransactionPasswordDialogWidget> {
  final _pwdLength = 6;
  bool _failed = false;
  final List<String> _inputs = [];
  String _initPwd;

  void _doInput(String n) async {
    if (_inputs.length >= _pwdLength) {
      return;
    }
    _inputs.add(n);
    setState(() {});
    if (_inputs.length == _pwdLength) {
      final pwd = _inputs.join('');
      if (widget.init) {
        if (_initPwd == null) {
          _initPwd = pwd;
          setState(() {});
        } else {
          // compare two inputed pwd
          if (_initPwd == pwd) {
            setState(() {
              _failed = false;
            });
            widget.onSuccess(pwd);
          } else {
            setState(() {
              _failed = true;
            });
          }
        }
      } else {
        try {
          final res = await LpHttp().post(
            '/client/v1/membership/user/validate-trans-password',
            data: {
              'transactionPassword': pwd,
            },
          );
          if (res.data['data'] as int == 1) {
            setState(() {
              _failed = false;
            });
            widget.onSuccess(pwd);
          } else {
            setState(() {
              _failed = true;
            });
          }
        } on LpHttpError catch (err) {
          showError(err.message);
        } catch (err) {
          showError($i18n('common.msg.svrErr'));
        }
      }
      _clearInput();
    }
  }

  void _clearInput() {
    _inputs.clear();
    setState(() {});
  }

  void _removeLastInput() {
    _inputs.removeLast();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String msg;
    if (widget.init) {
      if (_failed) {
        msg = $i18n('widget.msg.transactionPasswordDifferent');
      } else if (_initPwd == null) {
        msg = $i18n('widget.msg.setTransactionPassword');
      } else {
        msg = $i18n('widget.msg.inputTransactionPasswordAgain');
      }
    } else {
      if (_failed) {
        msg = $i18n('widget.msg.wrongTransactionPassword');
      } else {
        msg = $i18n('widget.msg.inputTransactionPassword');
      }
    }

    return LpDialog(
      height: 425.0,
      borderRadius: 0,
      title: '',
      titleFontSize: 13.0,
      titleBorderWidth: 0,
      onTapClose: widget.onTapClose,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Center(
              child: Text(
                msg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _failed ? Colors.red : Colors.black,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(_pwdLength, (i) {
                return _InputWidget(
                  filled: _inputs.length > i,
                  last: i == _pwdLength - 1,
                );
              }),
            ),
          ),
          Expanded(
            child: Center(
              child: widget.init ? null : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  AppRoute.openUrl(url: '/reset_transaction_password');
                },
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    $i18n('widget.msg.forgotTransactionPassword'),
                    style: TextStyle(
                      color: COLOR_PRIMARY_LIGHT,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _ButtonWidget(
                  text: '1',
                  onTap: () => _doInput('1'),
                ),
              ),
              Expanded(
                child: _ButtonWidget(
                  text: '2',
                  onTap: () => _doInput('2'),
                ),
              ),
              Expanded(
                child: _ButtonWidget(
                  text: '3',
                  onTap: () => _doInput('3'),
                  last: true,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _ButtonWidget(
                  text: '4',
                  onTap: () => _doInput('4'),
                ),
              ),
              Expanded(
                child: _ButtonWidget(
                  text: '5',
                  onTap: () => _doInput('5'),
                ),
              ),
              Expanded(
                child: _ButtonWidget(
                  text: '6',
                  onTap: () => _doInput('6'),
                  last: true,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _ButtonWidget(
                  text: '7',
                  onTap: () => _doInput('7'),
                ),
              ),
              Expanded(
                child: _ButtonWidget(
                  text: '8',
                  onTap: () => _doInput('8'),
                ),
              ),
              Expanded(
                child: _ButtonWidget(
                  text: '9',
                  onTap: () => _doInput('9'),
                  last: true,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: _ButtonWidget(
                  text: 'C',
                  color: Colors.black12,
                  onTap: _clearInput,
                ),
              ),
              Expanded(
                child: _ButtonWidget(
                  text: '0',
                  onTap: () => _doInput('0'),
                ),
              ),
              Expanded(
                child: _ButtonWidget(
                  text: '#',
                  child: Icon(
                    Icons.keyboard_backspace,
                    size: 30,
                  ),
                  color: Colors.black12,
                  onTap: _removeLastInput,
                  last: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ButtonWidget extends StatelessWidget {
  final bool last;
  final String text;
  final Widget child;
  final Color color;
  final VoidCallback onTap;

  _ButtonWidget({
    Key key,
    this.last = false,
    this.text,
    this.child,
    this.color = Colors.white,
    this.onTap,
  })  : assert(text != null || child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
        color: color,
        border: Border(
          top: BorderSide(
            color: COLOR_GRAY_BORDER,
            width: 0.5,
          ),
          right: last
              ? BorderSide.none
              : BorderSide(
                  color: COLOR_GRAY_BORDER,
                  width: 0.5,
                ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: COLOR_GRAY_BG,
          splashColor: Colors.transparent,
          onTap: onTap,
          child: Center(
            child: child ??
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}

class _InputWidget extends StatelessWidget {
  final bool last;
  final bool filled;

  _InputWidget({
    Key key,
    this.last = false,
    this.filled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.0,
      height: 48.0,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: COLOR_GRAY_BORDER, width: 0.5),
          top: BorderSide(color: COLOR_GRAY_BORDER, width: 0.5),
          bottom: BorderSide(color: COLOR_GRAY_BORDER, width: 0.5),
          right: last
              ? BorderSide(color: COLOR_GRAY_BORDER, width: 0.5)
              : BorderSide.none,
        ),
      ),
      child: filled
          ? Center(
              child: Container(
                width: 10.0,
                height: 10.0,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            )
          : null,
    );
  }
}
