import 'package:connect_plus/Navbar.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyOffersPage extends StatefulWidget {
  MyOffersPage({Key key, this.title}) : super(key: key);
  final String title;
  // This widget is the root of your application.
  @override
  MyOffersPageState createState() => MyOffersPageState();
}

class MyOffersPageState extends State<MyOffersPage>
    with AutomaticKeepAliveClientMixin<MyOffersPage> {
  @override
  bool get wantKeepAlive => true;
//  String token;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            MediaQuery.of(context).size * 0.14, // here the desired height
        child: AppBar(
          backgroundColor: const Color(0xfffafafa),
          flexibleSpace: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 0.17,
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
              padding: EdgeInsets.fromLTRB(0, 80, 0, 0),
              child: Text('Offers',
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
        ),
      ),
      drawer: NavDrawer(),

          body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        addAutomaticKeepAlives: true,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(offerCategories.length, (index) {
          return Center(
            child: Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new ListTile(
                    leading: Icon(Icons.album),
                    title:
                        Text(offerCategories.elementAt(index)['name'].toString()),
                    subtitle: Text(
                        "Logo would be here"),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('Learn more.'),
                        onPressed: () {/* ... */},
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      )
    );

    //IF YOU WANT VERTICAL SLOTS
    //        body: Container(
    //      child: ListView.builder(
    //        addAutomaticKeepAlives: true,
    //        itemBuilder: (context, index) {
    //          return Center(
    //              child: Card(
    //            child: Column(
    //              mainAxisSize: MainAxisSize.min,
    //              children: <Widget>[
    //                new ListTile(
    //                  leading: Icon(Icons.album),
    //                  title:
    //                      Text(offerCategories.elementAt(index)['name'].toString()),
    //                  subtitle: Text(
    //                      offerCategories.elementAt(index)['details'].toString()),
    //                ),
    //                ButtonBar(
    //                  children: <Widget>[
    //                    FlatButton(
    //                      child: const Text('Learn more.'),
    //                      onPressed: () {/* ... */},
    //                    )
    //                  ],
    //                ),
    //              ],
    //            ),
    //          ));
    //        },
    //        itemCount: offerCategories.length,
    //        scrollDirection: Axis.vertical,
    //      ),
    //    )
  }
}
