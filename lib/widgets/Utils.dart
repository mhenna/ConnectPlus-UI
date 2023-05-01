import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Utils {
  static EdgeInsets padding =
      const EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static EdgeInsets paddingPoster =
      const EdgeInsets.symmetric(horizontal: 30, vertical: 20);
  static EdgeInsets hPadding = const EdgeInsets.symmetric(
    horizontal: 10,
  );

  static double fullWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static Widget titleText(
      {String textString, double fontSize, Color textcolor}) {
    return Text(textString,
        style: GoogleFonts.muli(
            fontSize: fontSize, fontWeight: FontWeight.w800, color: textcolor));
  }

  static const Color titleTextColor = const Color(0xfff23441);
  static const Color iconColor = Color(0xffff5722);

  static const Color header = Color(0xffF54132);
  static const Color headline = Color(0xfff54132);
  static const Color background = Color(0xfff4f4f4);
  static const Color darkBackground = Color(0xfff0f0f0);

  static const Color primaryColor = Color(0xffF7501E);
  static const Color secondaryColor = Color(0xffED136E);
  static const Color midPoint = Color(0xffF12B4E);
  static String description =
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.";
  static String emailTemplate = '''Hello FULL_NAME,

This is a message sent from the connect+ app,

EMAIL_BODY.

Have a great day,

Your Connect + team
''';

  static String getComposedEmail({fullName,emailBody}){
    String email= emailTemplate.replaceAll("FULL_NAME", fullName);
    return email.replaceAll("EMAIL_BODY", emailBody);
  }
  static void showMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}


extension OnPressed on Widget {
  Widget ripple(Function onPressed,
          {BorderRadiusGeometry borderRadius =
              const BorderRadius.all(Radius.circular(5))}) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: FlatButton(
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
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
