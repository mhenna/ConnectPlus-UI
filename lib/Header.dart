import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  Header({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          height: height / 3,
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
              image: AssetImage("assets/logo2.png"),
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
            ),
          ),
        ));
  }
}
