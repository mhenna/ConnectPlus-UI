import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/Utils.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Function onPress;

  AppButton({@required this.title,
    @required this.onPress,
  }
   );

  @override
  Widget build(BuildContext context) {
    return  RaisedButton(
      onPressed:onPress,
      color: Utils.iconColor,
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Utils.iconColor)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          gradient: LinearGradient(
            colors: [
              Utils.secondaryColor,
              Utils.primaryColor,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(25, 7, 25, 7),
        child: Text(
          title,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}