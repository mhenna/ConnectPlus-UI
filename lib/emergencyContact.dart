import 'package:connect_plus/models/emergencyContact.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:connect_plus/Navbar.dart';

class Emergency extends StatefulWidget {
  Emergency({
    Key key,
  }) : super(key: key);

  @override
  MyEmergencyPageState createState() => MyEmergencyPageState();
}

class MyEmergencyPageState extends State<Emergency>
    with AutomaticKeepAliveClientMixin<Emergency> {
  @override
  bool get wantKeepAlive => true;
  List<EmergencyContact> contacts;
  List<Widget> bupa = new List<Widget>();
  List<Widget> dell = new List<Widget>();
  List<Widget> local = new List<Widget>();

  void initState() {
    contacts = [];
    bupa = [];
    dell = [];
    local = [];
    super.initState();
    getContacts();
  }

  void getContacts() async {
    final allContacts = await WebAPI.getEmergencyContacts();
    if (this.mounted) {
      setState(() {
        contacts = allContacts;
      });
      distributeContacts();
    }
  }

  void distributeContacts() {
    contacts.forEach((contact) {
      if (contact.type == 'BUPA') {
        bupa.add(
          ListTile(
            title: Text(contact.name, style: TextStyle(color: Utils.header)),
            onTap: () => urlLauncher.launch(contact.number),
          ),
        );
      } else if (contact.type == 'DELL') {
        dell.add(
          ListTile(
            title: Text(contact.name, style: TextStyle(color: Utils.header)),
            onTap: () => urlLauncher.launch(contact.number),
          ),
        );
      } else {
        local.add(
          ListTile(
            title: Text(contact.name, style: TextStyle(color: Utils.header)),
            onTap: () => urlLauncher.launch(contact.number),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (bupa.isNotEmpty || dell.isNotEmpty || local.isNotEmpty)
      return DefaultTabController(
          length: 3,
          child: new Scaffold(
            drawer: NavDrawer(),
            appBar: AppBar(
              centerTitle: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Utils.secondaryColor,
                      Utils.primaryColor,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
              title: Text('Emergency Contacts'),
              bottom: TabBar(tabs: [
                Tab(
                  text: "BUPA",
                ),
                Tab(
                  text: "Dell",
                ),
                Tab(
                  text: "Local",
                ),
              ]),
            ),
            body: Padding(
              padding: EdgeInsets.fromLTRB(
                  width * 0.02, height * 0.02, width * 0.03, height * 0.01),
              child: TabBarView(children: [
                new ListView(children: bupa),
                new ListView(children: dell),
                new ListView(children: local),
              ]),
            ),
          ));
    else {
      return Scaffold(
        body: ImageRotate(),
      );
    }
  }
}
