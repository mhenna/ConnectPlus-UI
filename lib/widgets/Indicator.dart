import 'package:flutter/material.dart';

class CircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center( child : Container(
        padding: EdgeInsets.all(24.0),
        child: CircularProgressIndicator(
            backgroundColor: Colors.black,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange))),);
  }
}