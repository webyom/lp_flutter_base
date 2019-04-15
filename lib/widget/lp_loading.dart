import 'package:flutter/material.dart';

class LpLoadingIcon extends StatefulWidget {
  final Brightness brightness;

  LpLoadingIcon({
    Key key,
    this.brightness = Brightness.light,
  }) : super(key: key);

  @override
  _LpLoadingIconState createState() => _LpLoadingIconState();
}

class _LpLoadingIconState extends State<LpLoadingIcon>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: Image.asset(
        'assets/images/icon_loading_${widget.brightness == Brightness.dark ? 'dark' : 'light'}.png',
        package: 'lp_flutter_base',
      ),
      builder: (BuildContext context, Widget widget) {
        return Transform.rotate(
          angle: animationController.value * 6.3,
          child: widget,
        );
      },
    );
  }
}

class LpLoading extends StatelessWidget {
  final bool visible;

  LpLoading({Key key, this.visible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return visible
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
                  child: Container(
                    color: Color(0x00000000),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 100.0,
                      height: 90.0,
                      child: LpLoadingIcon(),
                      decoration: BoxDecoration(
                        color: Color(0xaa000000),
                        borderRadius: BorderRadius.all(
                          const Radius.circular(7.0),
                        ),
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(30.0, 25.0, 30.0, 25.0),
                    ),
                  ),
                )
              ],
              fit: StackFit.expand,
            ),
          )
        : Container();
  }
}
