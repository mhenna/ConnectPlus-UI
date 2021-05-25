import 'package:flutter/material.dart';
import 'package:connect_plus/Navbar.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Color backgroundColor;
  final Widget bottomNavigationBar;
  final String title;

  AppScaffold(
      {this.body,
      this.backgroundColor,
      this.bottomNavigationBar,
      this.title = "Connect+"});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
      drawer: NavDrawer(),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
