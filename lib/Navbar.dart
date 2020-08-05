import 'package:flutter/material.dart';
import 'package:connect_plus/dummyPage.dart';
import 'package:connect_plus/bottomNav.dart';
import 'package:connect_plus/emergencyContact.dart';
import 'package:connect_plus/offersPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';


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

  void initState() {
    super.initState();
    getCategories();
    setEnv();
  }

  Future setEnv() async {
    await DotEnv().load('.env');
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  void getCategories() async {
//    var ip = await EnvironmentUtil.getEnvValueForKey('SERVER_IP');
//    print(ip)
//    Working for android emulator -- set to actual ip for use with physical device
//    ip = "10.0.2.2";
//    port = '3300';
    var url = 'http://' + ip + ':' + port + '/offerCategories/getCategories';
    print(url);
    var response =
    await http.get(url, headers: {"Content-Type": "application/json"});
    print(response.statusCode);
    if (response.statusCode == 200)
      setState(() {
        offerCategories = json.decode(response.body)['offerCategories'];
      });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print(offerCategories);
  }

  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.network(
              'http://www.emc2movecar.com/connectplus/wp-content/uploads/2018/01/logo.png',
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepOrange,
                  Color.fromARGB(0, 0, 0, 0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          ExpansionTile(
              leading: Icon(Icons.local_offer),
              title: Text('Offer Categories'),
              children: List.generate(offerCategories.length, (index) {
                return ListTile(
                  leading: Icon(Icons.album),
                  title: Text(offerCategories.elementAt(index)['name'].toString()),
                  subtitle: Text('Offer Details.'),
                );
              })),
          ListTile(
            leading: Icon(Icons.local_offer),
            title: Text('Offer Categories ver 2'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyOffersPage()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Profile'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomNavPreview()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => dummyPage()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => dummyPage()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.call),
            title: Text('Emergency Contacts'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => emergencyContact()),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }
}
