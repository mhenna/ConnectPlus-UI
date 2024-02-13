import 'package:connect_plus/Activities.dart';
import 'package:connect_plus/BookSwapsMain.dart';
import 'package:connect_plus/BookSwapsMyRequests.dart';
import 'package:connect_plus/aboutus.dart';
import 'package:connect_plus/announcements.dart';
import 'package:connect_plus/events.dart';
import 'package:connect_plus/included.dart';
import 'package:connect_plus/injection_container.dart';
import 'package:connect_plus/move_your_car_screen.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/Profile.dart';
import 'package:connect_plus/emergencyContact.dart';
import 'package:connect_plus/homepage.dart';
import 'package:connect_plus/login.dart';
import 'package:connect_plus/Offers.dart';
import 'package:connect_plus/Calendar.dart';
import 'package:connect_plus/WireMagazines.dart';
import 'package:connect_plus/BookSwapsAvailablePosts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:localstorage/localstorage.dart';

import 'BookSwapsMyPosts.dart';

class NavDrawer extends StatefulWidget {
  NavDrawer({Key key, this.title}) : super(key: key);
  final String title;
  // This widget is the root of your application.
  @override
  NavDrawerState createState() => NavDrawerState();
}

class NavDrawerState extends State<NavDrawer>
    with AutomaticKeepAliveClientMixin<NavDrawer> {
  @override
  bool get wantKeepAlive => true;
  var ip;
  var port;
  var offerCategories = [];
  final LocalStorage localStorage = new LocalStorage("Connect+");
  SharedPreferences prefs;

  void initState() {
    super.initState();
    setEnv();
  }

  Future setEnv() async {
    prefs = await SharedPreferences.getInstance();
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              './assets/logo2.png',
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Offers'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Offers()),
              )
            },
          ),
/*          ListTile(
            leading: Icon(Icons.library_books),
            title: Text('Book Swaps'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookSwapsMain()),
              )
            },
          ),*/
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Events & Webinars'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Events()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.menu_book_outlined),
            title: Text('The Wire'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WireMagazines()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.announcement),
            title: Text('Announcements'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Announcements()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.local_activity),
            title: Text('Activities'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Activities()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Calendar'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Calendar()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.car_repair),
            title: Text('Move Your Car'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MoveYourCarScreen()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.call),
            title: Text('Emergency Contacts'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Emergency()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.add_to_home_screen),
            title: Text('Who is Included'),
            onTap: () => {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Included()),
                  (Route<dynamic> route) => false)
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About us'),
            onTap: () => {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AboutUs()),
                  (Route<dynamic> route) => false)
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              await sl<AuthService>().logout();
              await prefs.remove("token");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Login()),
                  (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
