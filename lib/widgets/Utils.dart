import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  static EdgeInsets padding =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(
    horizontal: 10,
  );

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Widget titleText({String textString,double fontSize , Color textcolor}) {
    return Text(textString,
        style: GoogleFonts.muli(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: textcolor));
  }
    
  static const Color background = Color(0XFFFFFFFF);

  static const Color titleTextColor = const Color(0xfff23441);
  static const Color iconColor = Color(0xffff5722);

  static String description = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged." ;
}

extension OnPressed on Widget {
  Widget  ripple(Function onPressed, {BorderRadiusGeometry borderRadius =const BorderRadius.all(Radius.circular(5))}) => Stack(
      children: <Widget>[
        this,
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius
            ),
              onPressed: () {
                if (onPressed != null) {
                  onPressed();
                }
              },
              child: Container()),
        )
      ],
    );
}