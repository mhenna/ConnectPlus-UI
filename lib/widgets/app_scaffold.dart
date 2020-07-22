import 'package:flutter/material.dart';
import 'package:connect_plus/Navbar.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Color backgroundColor;
  final Widget bottomNavigationBar;

  AppScaffold({this.body, this.backgroundColor, this.bottomNavigationBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connect+')),
      body: body,
      drawer: NavDrawer(),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}