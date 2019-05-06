import 'package:flutter/material.dart';
import 'package:hybrid_stack_manager/router.dart';
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
    String routeName,
    @required bool visible,
    @required Widget child,
    @required LpDialogCloseCallback onClose,
  }) {
    return LpDialogContainer(
      key: key,
      routeName: routeName ?? Router.currentRouteName,
      visible: visible,
      child: child,
      onClose: onClose,
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
