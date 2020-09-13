import 'dart:convert';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connect_plus/Event.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:typed_data';
import 'dart:math';

class Events extends StatefulWidget {
  Events({
    Key key,
  }) : super(key: key);
  static final _random = new Random();

  @override
  MyEventsPageState createState() => MyEventsPageState();
}

class MyEventsPageState extends State<Events>
    with AutomaticKeepAliveClientMixin<Events> {
  @override
  bool get wantKeepAlive => true;

//  String token;
  var ip;
  var port;
  var events = [];
  var randIndex;
  var emptyEvents = false;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  void initState() {
    super.initState();
    setEnv();
    getEvents();
  }

  Future setEnv() async {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  void getEvents() async {
    //    var ip = await EnvironmentUtil.getEnvValueForKey('SERVER_IP');
//    print(ip)
//    Working for android emulator -- set to actual ip for use with physical device
//    ip = "10.0.2.2";
//    port = '3300';
    var url = 'http://' + ip + ':' + port + '/event';
    var token = localStorage.getItem("token");

    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200)
      setState(() {
        events = json.decode(response.body);
        if (events.isEmpty) emptyEvents = true;
        else
        randIndex = Events._random.nextInt(events.length);

      });
  }

  Widget base64ToImageFeatured() {
    try {
      Uint8List bytes =
          base64Decode(events.elementAt(randIndex)['poster']['fileData']);
      return FittedBox(
        fit: BoxFit.contain,
        child: Image.memory(bytes),
      );
    } catch (Exception) {
      return LoadingWidget();
    }
  }

  Widget base64ToImage(String base64) {
    Uint8List bytes = base64Decode(base64);
    return SizedBox(
      width:
          MediaQuery.of(context).size.width, // otherwise the logo will be tiny
      child: Image.memory(bytes),
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    try {
      if(emptyEvents)
        return AppScaffold(body: Center(child: Text("No Events")));
      else
      return AppScaffold(
          body: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              itemCount: 2,
              itemBuilder: (BuildContext context, int elem) {
                if (elem == 0) {
                  return Padding(
                      padding: EdgeInsets.only(top: 40, bottom: 20),
                      child: Text(
                        "Events",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ));
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: events.length,
                      itemBuilder: (BuildContext catContext, int cat) {
                        return Center(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    base64ToImage(events
                                        .elementAt(cat)['poster']['fileData']
                                        .toString()),
                                    ButtonBar(
                                      alignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            events
                                                .elementAt(cat)['name']
                                                .toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => Event(
                                                        event: events.elementAt(
                                                            cat)['name'],
                                                        erg: events.elementAt(
                                                            cat)['ERG'])));
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        );
                      });
                }
              }));
    } catch (err) {
      return LoadingWidget();
    }
  }
}
