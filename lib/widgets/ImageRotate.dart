import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';

class ImageRotate extends StatefulWidget {
  final bool _overlay;

  /// Will show a white screen with the connect+ logo loading
  const ImageRotate({Key key})
      : _overlay = false,
        super(key: key);

  /// Will overlay the current screen with the connect+ logo loading
  const ImageRotate.overlay({
    Key key,
  })  : _overlay = true,
        super(key: key);

  @override
  _ImageRotateState createState() => new _ImageRotateState();
}

class _ImageRotateState extends State<ImageRotate>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(seconds: 7),
    );

    animationController.repeat();
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      color: Utils.background.withAlpha(70),
      child: new AnimatedBuilder(
        animation: animationController,
        child: new Container(
          height: 100.0,
          width: 100.0,
          child: new Image.asset(
            widget._overlay ? 'assets/logoC_white.png' : 'assets/logoC.png',
          ),
        ),
        builder: (BuildContext context, Widget _widget) {
          return new Transform.rotate(
            angle: animationController.value * 6.3,
            child: _widget,
          );
        },
      ),
    );
  }
}
