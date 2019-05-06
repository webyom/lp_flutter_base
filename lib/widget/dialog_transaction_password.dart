import 'package:flutter/material.dart';
import '../util/util.dart';
import '../util/i18n.dart';
import '../config.dart';
import 'widget.dart';

typedef void OnTransactionPasswordSuccess(String pwd);

class TransactionPasswordDialogWidget extends StatefulWidget {
  final VoidCallback onTapClose;
  final OnTransactionPasswordSuccess onSuccess;

  TransactionPasswordDialogWidget({
    Key key,
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

  void _doInput(String n) async {
    if (_inputs.length >= _pwdLength) {
      return;
    }
    _inputs.add(n);
    setState(() {});
    if (_inputs.length == _pwdLength) {
      try {
        final pwd = _inputs.join('');
        final res = await LpHttp().post(
          '/client/v1/membership/user/validate-trans-password',
          data: {
            'transactionPassword': pwd,
          },
        );
        if (res.data['data'] as int == 1) {
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
    return LpDialog(
      height: 420.0,
      borderRadius: 0,
      title: _failed
          ? $i18n('transaction.msg.wrongPassword')
          : $i18n('transaction.msg.inputPassword'),
      titleColor: _failed ? Colors.red : Colors.black,
      titleFontSize: 13.0,
      titleBorderWidth: 0,
      onTapClose: widget.onTapClose,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
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
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Text(
                  'Forget Transaction Password?',
                  style: TextStyle(
                    color: COLOR_PRIMARY_LIGHT,
                    fontSize: 12.0,
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
