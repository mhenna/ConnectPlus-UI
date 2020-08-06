import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connect_plus/Navbar.dart';

class emergencyContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final resWidth = MediaQuery.of(context).size.width;
    final resHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      child: new Scaffold(
        backgroundColor: const Color(0xfffafafa),
        drawer: NavDrawer(),
        appBar: PreferredSize(
          preferredSize:
              MediaQuery.of(context).size * 0.20, // here the desired height
          child: AppBar(
            backgroundColor: const Color(0xfffafafa),
            flexibleSpace: Container(
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.23,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
                gradient: LinearGradient(
                  begin: Alignment(-1.0, 1.0),
                  end: Alignment(1.0, -1.0),
                  colors: [const Color(0xfff7501e), const Color(0xffed136e)],
                  stops: [0.0, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29000000),
                    offset: Offset(0, 3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, resHeight * 0.1, 0, 0),
                child: Text('Emergency Contacts',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 28,
                      color: const Color(0xffffffff),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center),
              ),
            ),
            elevation: 0.0,
            bottom: TabBar(labelStyle: TextStyle(fontSize: 18), tabs: [
              Tab(
//              icon: Icon(Icons.local_hospital),
                text: "BUPA",
              ),
              Tab(
                //icon: Icon(Icons.home),
                text: "Dell",
              ),
              Tab(
                text: "Local",
              ),
            ]),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, resHeight * 0.04, 0, 0),
          child: TabBarView(children: [
            new ListView(
              children: <Widget>[
                ListTile(
                  title: Text('BUPA Egypt Hotline',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel://16816"),
                ),
                ListTile(
                  title: Text('Bupa Medical queries (Outside Egypt)',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel:+202 27681100"),
                ),
                ListTile(
                  title: Text('BUPA Emergency contact',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel:+201227624595"),
                ),
                ListTile(
                  title: Text('BUPA Medical Center',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel: +44 1273333911"),
                ),
                ListTile(
                  title: Text('BUPA 24/7 Hotline',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel: +44 1273 323 563"),
                ),
                ListTile(
                  title: Text('Travel Security Emergency (ISOS)',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel: +44 20 7939 8899"),
                ),
                ListTile(
                  title: Text('*Rehab Emergency Medical Center',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel: +202 26077980"),
                ),
                ListTile(
                  title: Text('*Air Force Specialized Hospital',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel://19448"),
                )
              ],
            ),
            new ListView(
              children: <Widget>[
                ListTile(
                  title: Text('DELL EMC Office',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel:+202 2 5032500"),
                ),
                ListTile(
                  title: Text('DELL EMC Fax',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel: +202 2503 2555"),
                ),
                ListTile(
                  title: Text('IT Global Desk: +1 800-782-3797 opt 1 x58126'),
                ),
                ListTile(
                  title: Text('IT International Direct',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel: +1 (508) 898-5812"),
                )
              ],
            ),
            new ListView(
              children: <Widget>[
                ListTile(
                  title: Text('Ambulance – 123',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel:+202 35345260"),
                ),
                ListTile(
                  title: Text('Police',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel: 122"),
                ),
                ListTile(
                  title: Text('New Cairo Police Station',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel:+202 26173630"),
                ),
                ListTile(
                  title: Text('Fire Brigade – 180',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel:+202 23910115"),
                ),
                ListTile(
                  title: Text('Road Rescue',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel:128"),
                ),
                ListTile(
                  title: Text('Road Accident',
                      style: TextStyle(color: Color(0xFFE15F5F))),
                  onTap: () => launch("tel:+201221110000"),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
