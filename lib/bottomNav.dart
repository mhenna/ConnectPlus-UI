import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:connect_plus/dummyPage.dart';
import 'package:connect_plus/offersPage.dart';

class BottomNavPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: new AppScaffold(
        body: TabBarView(
          children: [
            MyOffersPage(),
            dummyPage(),
            dummyPage(),
          ],
        ),
        bottomNavigationBar: new TabBar(
          labelPadding: EdgeInsets.only(bottom: 4.0),
          tabs: [
            Tab(
              icon: new Icon(Icons.home),
            ),
            Tab(
              icon: new Icon(Icons.calendar_view_day),
            ),
            Tab(
              icon: new Icon(Icons.settings),
            ),
          ],
          labelColor: Colors.green,
          unselectedLabelColor: Colors.blue,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.red,
          indicatorPadding: EdgeInsets.only(bottom: 8.0),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
