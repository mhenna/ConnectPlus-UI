import 'package:flutter/material.dart';
import 'package:connect_plus/dummyPage.dart';
import 'package:connect_plus/bottomNav.dart';
import 'package:connect_plus/emergencyContact.dart';
import 'package:connect_plus/offersPage.dart';

class NavDrawer extends StatelessWidget {
  @override
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
            children: List.generate(3, (index) {
              return ListTile(
                leading: Icon(Icons.album),
                title: Text('Offer name'),
                subtitle: Text('Offer Details.'),
              );
            })
          ),
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
