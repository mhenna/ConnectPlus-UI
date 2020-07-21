import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connect_plus/Navbar.dart';

class emergencyContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: new Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFFE15F5F),
          title: Text('Emergency Contacts'),
          bottom: TabBar(tabs: [
            Tab(
//              icon: Icon(Icons.local_hospital),
              text: "BUPA",
            ),
            Tab(
              //icon: Icon(Icons.home),
              text: "Dell",
            ),
            Tab(
              text:"Local",
            ),
          ]),
        ),
        body: TabBarView(children: [
          new ListView(
            children: <Widget>[
              ListTile(
                title: Text('BUPA Egypt Hotline',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel://16816"),
              ),
              ListTile(
                title: Text('Bupa Medical queries (Outside Egypt)',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel:+202 27681100"),
              ),
              ListTile(
                title: Text('BUPA Emergency contact',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel:+201227624595"),
              ),
              ListTile(
                title: Text('BUPA Medical Center',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel: +44 1273333911"),
              ),
              ListTile(
                title: Text('BUPA 24/7 Hotline',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel: +44 1273 323 563"),
              ),
              ListTile(
                title: Text('Travel Security Emergency (ISOS)',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel: +44 20 7939 8899"),
              ),
              ListTile(
                title: Text('*Rehab Emergency Medical Center',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel: +202 26077980"),
              ),
              ListTile(
                title: Text('*Air Force Specialized Hospital',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel://19448"),
              )
            ],
          ),
          new ListView(
            children: <Widget>[
              ListTile(
                title: Text('DELL EMC Office',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel:+202 2 5032500"),
              ),
              ListTile(
                title: Text('DELL EMC Fax',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel: +202 2503 2555"),
              ),
              ListTile(
                title: Text('IT Global Desk: +1 800-782-3797 opt 1 x58126'),
              ),
              ListTile(
                title: Text('IT International Direct',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel: +1 (508) 898-5812"),
              )
            ],
          ),
          new ListView(
            children: <Widget>[
              ListTile(
                title: Text('Ambulance – 123',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel:+202 35345260"),
              ),
              ListTile(
                title: Text('Police',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel: 122"),
              ),
              ListTile(
                title: Text('New Cairo Police Station',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel:+202 26173630"),
              ),
              ListTile(
                title: Text('Fire Brigade – 180',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel:+202 23910115"),
              ),
              ListTile(
                title: Text('Road Rescue',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel:128"),
              ),
              ListTile(
                title: Text('Road Accident',style: TextStyle(color: Color(0xFFE15F5F))),
                onTap: () => launch("tel:+201221110000"),
              )
            ],
          ),
        ]),
      ),
    );
  }
}
