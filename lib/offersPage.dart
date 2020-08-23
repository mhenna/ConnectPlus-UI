import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'package:connect_plus/Offers.dart';

class MyOffersPage extends StatefulWidget {
  MyOffersPage({Key key, this.title}) : super(key: key);
  final String title;
  // This widget is the root of your application.
  @override
  MyOffersPageState createState() => MyOffersPageState();
}

class MyOffersPageState extends State<MyOffersPage>
    with AutomaticKeepAliveClientMixin<MyOffersPage> {
  final LocalStorage localStorage = new LocalStorage("Connect+");

  @override
  bool get wantKeepAlive => true;
//  String token;
  var ip;
  var port;
  var offerCategories = [];
  var offers = [];

  void initState() {
    super.initState();
    setEnv();
    getCategories();
  }

  setEnv() {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  void getCategories() async {
//    var ip = await EnvironmentUtil.getEnvValueForKey('SERVER_IP');
//    print(ip)
//    Working for android emulator -- set to actual ip for use with physical device
    String token = localStorage.getItem("token");
    var url = 'http://' + ip + ':' + port + '/offerCategories/getCategories';
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200)
      setState(() {
        offerCategories = json.decode(response.body)['offerCategories'];
        offers = json.decode(response.body)['offers'];
      });
  }

  void getOffer() async {
    String token = localStorage.getItem("token");
    var url = 'http://' + ip + ':' + port + '/offer/getOffer';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
                  subtitle: Text("Logo would be here"),
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: const Text('Learn more.'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Offers(
                                    offerCategory: offerCategories
                                        .elementAt(index)['name'],
                                  )),
                        );
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    ));

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
