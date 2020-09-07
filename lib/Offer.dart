import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

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
        width: 220, // otherwise the logo will be tiny
        child: Image.memory(bytes),
      ),
    );
  }

  base64ToPDF(String base64) async {
    Uint8List bytes = base64Decode(base64);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File f = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    await f.writeAsBytes(bytes);
    return f.path;
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
    var width = MediaQuery.of(context).size.width;
   
    relatedOffers.sort((b, a) => a['offer']['createdAt'].compareTo(b['offer']['createdAt']));
    
    for (var offer in relatedOffers) {
      if (offer['offer']['_id'] != widget.offer['_id'].toString()) {
        list.add(Container(
          padding: EdgeInsets.fromLTRB(width * 0.03, 0.0, width * 0.03, 0.0),
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
                        style: TextStyle(fontSize: 19),
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return AppScaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              height: height * 0.12,
              width: width,
              child: Padding(
                  padding: EdgeInsets.fromLTRB(0, height * 0.05, 0, 0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        widget.offer['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ))),
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
            padding: EdgeInsets.fromLTRB(
                width * 0.05, height * 0.03, width * 0.05, 0),
            child: Column(
              children: <Widget>[
                Text(
                  'You Save ${widget.offer['discount']}',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  '${widget.offer['details']}',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17.0,
                  ),
                ),
                Text(
                  "\n\nLocation: " +
                      widget.offer['location'].toString() +
                      "\n\nContact: " +
                      widget.offer['contact'].toString() +
                      "\n\nExpiration: " +
                      widget.offer['expiration'].toString() +
                      "\n",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16.0,
                  ),
                ),
                InkWell(
                  child: Text(
                    "More Details",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () async {
                    String pathPDF = await base64ToPDF(
                        widget.offer['attachment']['fileData'].toString());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PDFScreen(pathPDF)),
                    );
                    // PDFViewer(document: file, indicatorBackground: Colors.red);
                  },
                ),
                Divider(color: Colors.black),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, height * 0.05, 0, height * 0.05),
              child: Text(
                "RELATED OFFERS",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, color: Colors.orange),
              )),
          Padding(
              padding: EdgeInsets.fromLTRB(width * 0.03, 0, width * 0.03, 0),
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

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Details"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF);
  }
}
