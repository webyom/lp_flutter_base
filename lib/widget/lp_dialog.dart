import 'package:flutter/material.dart';
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
    animationController.animateTo(1.0, curve: Curves.linear);
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
      animationController.animateTo(0, curve: Curves.linear);
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
  final AlignmentGeometry titleAlignment;
  final AlignmentGeometry alignment;

  LpDialog({
    Key key,
    this.width = double.infinity,
    this.height = 400.0,
    this.borderRadius = 12.0,
    this.titleBorderWidth = 1.0,
    this.titleFontSize = 16.0,
    this.noHeader,
    this.title = '',
    this.icon,
    this.child,
    this.onTapClose,
    this.titleAlignment = Alignment.centerLeft,
    this.alignment = Alignment.bottomCenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Expanded(
        child: child,
      )
    ];
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
      child: Row(
        children: <Widget>[
          icon == null ? Container() : icon,
          Container(
            width: icon == null ? 0.0 : 13.0,
          ),
          Expanded(
            child: Align(
              alignment: titleAlignment,
              child: Text(
                title,
                style: TextStyle(fontSize: titleFontSize),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(17.0, 0),
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
    return LpDialogAnimator(
      distance: alignment == Alignment.bottomCenter ? height : 0,
      child: Align(
        alignment: alignment,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: alignment == Alignment.bottomCenter
                ? BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  )
                : BorderRadius.all(Radius.circular(borderRadius)),
          ),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }
}

class LpDialogContainer extends StatefulWidget {
  final bool visible;
  final Widget child;
  final VoidCallback onTapCover;

  LpDialogContainer({
    Key key,
    this.visible,
    this.child,
    this.onTapCover,
  }) : super(key: key);

  @override
  _LpDialogContainerState createState() => _LpDialogContainerState();

  static _LpDialogContainerState of(BuildContext context) {
    return context
        .ancestorStateOfType(const TypeMatcher<_LpDialogContainerState>());
  }
}

class _LpDialogContainerState extends State<LpDialogContainer>
    with SingleTickerProviderStateMixin {
  bool _animating = false;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  @override
  void didUpdateWidget(LpDialogContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
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
                      if (widget.onTapCover != null) {
                        widget.onTapCover();
                      }
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
        : Container();
  }
}
