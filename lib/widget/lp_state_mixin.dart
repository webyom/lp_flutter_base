import 'package:flutter/material.dart';
import 'lp_loading.dart';
import 'lp_dialog.dart';

mixin LpStateMixin<T extends StatefulWidget> on State<T> {
  var _loading = false;

  get loading {
    return _loading;
  }

  void showLoading() {
    setState(() {
      _loading = true;
    });
  }

  void hideLoading() {
    setState(() {
      _loading = false;
    });
  }

  Widget buildLoading({Key key, @required bool visible}) {
    return LpLoading(
      key: key,
      visible: visible,
    );
  }

  Widget buildDialog({
    Key key,
    @required bool visible,
    @required Widget child,
    VoidCallback onTapCover,
  }) {
    return LpDialogContainer(
      key: key,
      visible: visible,
      child: child,
      onTapCover: onTapCover,
    );
  }

  Widget buildStack(List<Widget> children, {Key key}) {
    return Stack(
      key: key,
      children: children.where((item) => item != null).toList(),
      fit: StackFit.expand,
    );
  }
}
