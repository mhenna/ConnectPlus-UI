import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:connect_plus/Event.dart';

class EventsVariables extends StatefulWidget {
  @override
  _EventsVariablesState createState() => _EventsVariablesState();
}

class _EventsVariablesState extends State<EventsVariables> {
  var ip, port;
  var event_list = [];
  Uint8List mostRecentEvent;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  @override
  void initState() {
    super.initState();
    setEnv();
    getEvents();
  }

  setEnv() {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  void getEvents() async {
    String token = localStorage.getItem("token");
    var url = 'http://$ip:$port/event/recent';

    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      setState(() {
        event_list = json.decode(response.body);
        this.mostRecentEvent =
            base64Decode(event_list.elementAt(0)['poster']['fileData']);
      });
    }
  }

  Widget mostRecent() {
    if (mostRecentEvent == null) return CircularProgressIndicator();
    return Container(
        height: 200,
        decoration: BoxDecoration(
          image: new DecorationImage(
              image: MemoryImage(mostRecentEvent), fit: BoxFit.cover),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        mostRecent(),
        Expanded(
            child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: constructEvents(),
        )),
      ],
    );
  }

  List<Widget> constructEvents() {
    List<Widget> list = List<Widget>();

    for (var event in event_list) {
      list.add(Single_Event(
        event_name: event['name'],
        event_picture: base64Decode(event['poster']['fileData']),
        event_date: event['startDate'].toString().split("T")[0],
        event: event
      ));
    }
    return list;
  }
}

class Single_Event extends StatelessWidget {
  final event_name;
  final event_picture;
  final event_date;
  final event;

  //constructor
  Single_Event({
    this.event_name,
    this.event_picture,
    this.event_date,
    this.event,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 230,
        width: 270,
        child: Card(
          child: Hero(
            tag: event_name,
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Event(
                          event: event_name,
                          erg: event['ERG'],
                        )),
                  );
                },
                child: GridTile(
                    footer: Container(
                      color: Colors.white70,
                      child: ListTile(
                        leading: Text(event_name,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        title: Text(event_date,
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800)),
                      ),
                    ),
                    child: Image.memory(
                      event_picture,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
          ),
        ));
  }
}
