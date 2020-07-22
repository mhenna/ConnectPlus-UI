import 'package:flutter/material.dart';
import 'package:connect_plus/dummyPage.dart';
import 'package:connect_plus/bottomNav.dart';
import 'package:connect_plus/emergencyContact.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              '',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: NetworkImage(
                        'http://www.emc2movecar.com/connectplus/wp-content/uploads/2018/01/logo.png'))),
          ),
          ListTile(
            leading: Icon(Icons.input),
            title: Text('Welcome'),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomNavPreview()),
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
