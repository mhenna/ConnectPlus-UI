import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'dart:typed_data';

class Offer extends StatefulWidget {
  Offer({Key key, @required this.offer, @required this.category})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String category;
  final offer;

  @override
  _OfferState createState() => _OfferState();
}

class _OfferState extends State<Offer> {
  var ip;
  var port;
  var relatedOffers = [];
  final LocalStorage localStorage = new LocalStorage("Connect+");

  void initState() {
    super.initState();
    setEnv();
    getOffers();
  }

  setEnv() {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  Future getOffers() async {
    String name = widget.category;
    String token = localStorage.getItem("token");
    var url = 'http://' + ip + ':' + port + '/offers/getByCategory/$name';

    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200)
      setState(() {
        relatedOffers = json.decode(response.body);
      });
  }

  Widget base64ToImage(String base64) {
    Uint8List bytes = base64Decode(base64);
    return Expanded(
      child: SizedBox(
        width: 250, // otherwise the logo will be tiny
        child: Image.memory(bytes),
      ),
    );
  }

  Widget LoadingWidget() {
    return Scaffold(
        body: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          new CircularProgressIndicator(),
          new Text("Loading"),
        ],
      ),
    ));
  }

  List<Widget> constructRelatedOffers() {
    List<Widget> list = List<Widget>();
    for (var offer in relatedOffers) {
      if (offer['offer']['_id'] != widget.offer['_id'].toString()) {
        list.add(Container(
          padding: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
          width: 200.0,
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                base64ToImage(offer['logo']['fileData'].toString()),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        offer['offer']['logo'] = offer['logo'];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Offer(
                                category: widget.category,
                                offer: offer['offer'],
                              ),
                            ));
                      },
                      child: Text(
                        offer['offer']['name'].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
//    try {
    return AppScaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                base64ToImage(widget.offer['logo']['fileData'].toString()),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Center(
                  child: Card(
                      elevation: 3,
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                widget.offer['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 28.0, color: Colors.orange),
                              ),
                              subtitle: Text(
                                "\nDetails: " +
                                    widget.offer['details'].toString() +
                                    "\n\nLocation: " +
                                    widget.offer['location'].toString() +
                                    "\n\nContact: " +
                                    widget.offer['contact'].toString() +
                                    "\n\nExpiration: " +
                                    widget.offer['expiration'].toString() +
                                    "\n",
                                style: TextStyle(
                                    fontSize: 22.0, color: Colors.black),
                              ),
                            ),
                          ])))),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 64.0, 0, 8.0),
              child: Text(
                "RELATED OFFERS",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                ),
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SizedBox(
                  height: 200,
                  child: ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: constructRelatedOffers(),
                  ))),
          Align(
            alignment: Alignment.bottomLeft,
            child: FlatButton(
              child: Text("Back"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    ));
//    } catch (Exception) {
//      print("EXCEPTIONNNNNNNNNN $Exception ");
//      return LoadingWidget();
//    }
  }
}
