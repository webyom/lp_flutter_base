import 'package:flutter/material.dart';
import 'package:hybrid_stack_manager/hybrid_stack_manager_plugin.dart';
import '../config.dart';

class LpDialogAnimator extends StatefulWidget {
  final Widget child;
  final double distance;

  LpDialogAnimator({
    @required this.child,
    @required this.distance,
    Key key,
  }) : super(key: key);

  @override
  _LpDialogAnimatorState createState() => _LpDialogAnimatorState();
}

class _LpDialogAnimatorState extends State<LpDialogAnimator>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  AnimationController containerAnimationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animationController.animateTo(1.0, curve: Curves.ease);
    containerAnimationController =
        LpDialogContainer.of(context).animationController;
    containerAnimationController
        .addStatusListener(onContainerAnimationStatusChange);
  }

  @override
  void dispose() {
    animationController.dispose();
    containerAnimationController
        .removeStatusListener(onContainerAnimationStatusChange);
    containerAnimationController = null;
    super.dispose();
  }

  void onContainerAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.reverse) {
      animationController.animateTo(0, curve: Curves.ease.flipped);
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = widget.child;
    final distance = widget.distance;
    return AnimatedBuilder(
      animation: animationController,
      child: child,
      builder: (BuildContext context, Widget widget) {
        if (distance == 0) {
          return Transform.scale(
            scale: animationController.value,
            child: widget,
          );
        } else {
          return Transform.translate(
            offset: Offset(0, distance - animationController.value * distance),
            child: widget,
          );
        }
      },
    );
  }
}

class LpDialogBtn extends StatelessWidget {
  final String text;
  final bool primary;
  final bool first;
  final bool last;
  final Color textColor;
  final Color borderColor;
  final VoidCallback onPressed;

  LpDialogBtn({
    Key key,
    @required this.text,
    this.primary = false,
    this.first = false,
    this.last = false,
    Color textColor,
    this.borderColor = COLOR_GRAY_BORDER,
    this.onPressed,
  })  : this.textColor =
            textColor ?? (primary ? COLOR_PRIMARY_LIGHT : COLOR_GRAY_TEXT),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      color: borderColor,
      width: 0.5,
    );

    return Expanded(
      flex: 1,
      child: Container(
        height: 42.0,
        decoration: BoxDecoration(
          border: last
              ? Border(top: border)
              : Border(
                  top: border,
                  right: border,
                ),
        ),
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: first && last
                ? BorderRadius.only(
                    bottomLeft: const Radius.circular(12.0),
                    bottomRight: const Radius.circular(12.0),
                  )
                : last
                    ? BorderRadius.only(
                        bottomRight: const Radius.circular(12.0),
                      )
                    : BorderRadius.only(
                        bottomLeft: const Radius.circular(12.0),
                      ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: textColor,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class LpDialog extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double titleBorderWidth;
  final double titleFontSize;
  final bool noHeader;
  final String title;
  final Widget icon;
  final Widget child;
  final VoidCallback onTapClose;
  final Color titleColor;
  final TextAlign titleTextAlignment;
  final AlignmentGeometry alignment;

  LpDialog({
    Key key,
    double width,
    double height,
    this.borderRadius = 12.0,
    this.titleBorderWidth = 1.0,
    this.titleFontSize = 16.0,
    this.noHeader = false,
    this.title = '',
    this.icon,
    this.child,
    this.onTapClose,
    this.titleColor,
    TextAlign titleTextAlignment,
  })  : assert(width != double.infinity),
        assert(height != double.infinity),
        this.height = height,
        this.width = width ?? (height == null ? 300.0 : double.infinity),
        this.alignment = height == null || width != null
            ? Alignment.center
            : Alignment.bottomCenter,
        this.titleTextAlignment = titleTextAlignment ??
            (icon == null ? TextAlign.center : TextAlign.left),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[height != null ? Expanded(child: child) : child];
    final header = Container(
      margin: EdgeInsets.symmetric(horizontal: 17.0),
      height: 50.0,
      decoration: BoxDecoration(
        border: title == '' || titleBorderWidth == 0
            ? null
            : Border(
                bottom: BorderSide(
                  color: COLOR_GRAY_BORDER,
                  width: titleBorderWidth,
                ),
              ),
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Row(
            children: <Widget>[
              icon == null ? Container() : icon,
              Container(
                width: icon == null ? 0.0 : 13.0,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      titleTextAlignment == TextAlign.center ? 15.0 : 0,
                      0,
                      15.0,
                      0),
                  child: Text(
                    title,
                    textAlign: titleTextAlignment,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: titleColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            right: -17.0,
            top: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (onTapClose != null) {
                  onTapClose();
                }
              },
              child: SizedBox.fromSize(
                size: Size(50.0, 50.0),
                child: Icon(Icons.close),
              ),
            ),
          ),
        ],
      ),
    );
    if (!noHeader) {
      children.insert(0, header);
    }
    final dialogBorderRadius = alignment == Alignment.bottomCenter
        ? BorderRadius.only(
            topLeft: Radius.circular(borderRadius),
            topRight: Radius.circular(borderRadius),
          )
        : BorderRadius.all(Radius.circular(borderRadius));
    return LpDialogAnimator(
      distance: alignment == Alignment.bottomCenter ? (height ?? 0) : 0,
      child: Align(
        alignment: alignment,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: dialogBorderRadius,
              ),
              child: Material(
                color: Colors.white,
                borderRadius: dialogBorderRadius,
                child: Column(
                  children: children,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/// return false if do not close
typedef bool LpDialogCloseCallback({
  @required bool byPressBack,
  @required bool byTapCover,
});

class LpDialogContainer extends StatefulWidget {
  final String routeName;
  final bool visible;
  final Widget child;
  final LpDialogCloseCallback onClose;

  LpDialogContainer({
    Key key,
    this.routeName,
    this.visible,
    this.child,
    @required this.onClose,
  }) : super(key: key);

  @override
  _LpDialogContainerState createState() => _LpDialogContainerState();

  static _LpDialogContainerState of(BuildContext context) {
    return context
        .ancestorStateOfType(const TypeMatcher<_LpDialogContainerState>());
  }

  static int visibleAmount() {
    return _LpDialogContainerState.visibleAmount();
  }

  static bool closeAllVisible({
    bool byPressBack = false,
    bool byTapCover = false,
  }) {
    return _LpDialogContainerState.closeAllVisible(
      byPressBack: byPressBack,
      byTapCover: byTapCover,
    );
  }
}

class _LpDialogContainerState extends State<LpDialogContainer>
    with SingleTickerProviderStateMixin {
  bool visible;
  bool _animating = false;
  AnimationController animationController;

  static final List<_LpDialogContainerState> _allDialogStates = [];

  static void _add(_LpDialogContainerState state) {
    _allDialogStates.add(state);
  }

  static void _remove(_LpDialogContainerState state) {
    _allDialogStates.removeWhere((st) => st == state);
  }

  static int visibleAmount() {
    return _allDialogStates
        .where((st) =>
            st.visible && st.widget.routeName == Router.currentRouteName)
        .length;
  }

  static bool closeAllVisible({
    bool byPressBack = false,
    bool byTapCover = false,
  }) {
    var res = true;
    for (final state in _allDialogStates) {
      if (state.visible && state.widget.routeName == Router.currentRouteName) {
        final oneRes = state.widget.onClose(
          byPressBack: byPressBack,
          byTapCover: byTapCover,
        );
        if (res && !oneRes) {
          res = false;
        }
      }
    }
    return res;
  }

  void checkGestureBack() {
    HybridStackManagerPlugin.hybridStackManagerPlugin.toggleGestureBack(LpDialogContainer.visibleAmount() == 0);
  }

  @override
  void initState() {
    super.initState();
    visible = widget.visible;
    _add(this);
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    animationController.addStatusListener(onAnimationStatusChange);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(onAnimationStatusChange);
    animationController.dispose();
    _remove(this);
    checkGestureBack();
    super.dispose();
  }

  @override
  void didUpdateWidget(LpDialogContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    visible = widget.visible;
    if (!oldWidget.visible && widget.visible) {
      animationController.forward();
    } else if (oldWidget.visible && !widget.visible) {
      animationController.reverse();
    }
  }

  void onAnimationStatusChange(AnimationStatus status) {
    final animating = status != AnimationStatus.completed &&
        status != AnimationStatus.dismissed;
    setState(() {
      _animating = animating;
    });
  }

  @override
  Widget build(BuildContext context) {
    checkGestureBack();
    return widget.visible || _animating
        ? Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: GestureDetector(
                    onTap: () {
                      widget.onClose(
                        byTapCover: true,
                        byPressBack: false,
                      );
                    },
                    child: AnimatedBuilder(
                      animation: animationController,
                      child: Container(
                        color: const Color.fromRGBO(0, 0, 0, 0.5),
                      ),
                      builder: (BuildContext context, Widget widget) {
                        return Container(
                          color: Color.fromRGBO(
                              0, 0, 0, 0.5 * animationController.value),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: widget.child,
                )
              ],
              fit: StackFit.expand,
            ),
          )
        : Positioned(
            width: 0,
            height: 0,
            child: Container(),
          );
  }
}

Future showLpDialog({
  @required BuildContext context,
  WidgetBuilder builder,
}) {
  HybridStackManagerPlugin.hybridStackManagerPlugin.toggleGestureBack(false);
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: builder,
  );
}

void hideLpDialog(BuildContext context) {
  var popped = false;
  Navigator.of(context, rootNavigator: true).popUntil((route) {
    if (popped || route is XMaterialPageRoute) {
      return true;
    }
    popped = true;
    if (LpDialogContainer.visibleAmount() == 0) {
      HybridStackManagerPlugin.hybridStackManagerPlugin.toggleGestureBack(true);
    }
    return false;
  });
}
