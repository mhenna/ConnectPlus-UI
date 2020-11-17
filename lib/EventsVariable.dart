import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:connect_plus/EventWidget.dart';

class EventsVariables extends StatefulWidget {
  @override
  _EventsVariablesState createState() => _EventsVariablesState();
}

class _EventsVariablesState extends State<EventsVariables> {
  List<Event> events = [];
  String mostRecentEventPosterUrl;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  void getEvents() async {
    final allEvents = await WebAPI.getEvents();
    setState(() {
      events = allEvents;
      mostRecentEventPosterUrl = WebAPI.baseURL + events.first.poster.url;
    });
  }

  Widget mostRecent() {
    if (mostRecentEventPosterUrl == null)
      return Scaffold(
        body: ImageRotate(),
      );
    return Single_Event(event: events.first);
  }

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    final height = MediaQuery.of(context).size.height;
    if (events.isEmpty) return Center(child: Text("No Events"));
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 6, right: 6),
            child: Container(height: height * 0.27, child: mostRecent())),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 6, right: 6),
                child: Scrollbar(
                    controller: _scrollController,
                    isAlwaysShown: true,
                    child: ListView(
                      controller: _scrollController,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      children: constructEvents(),
                    )))),
      ],
    );
  }

  List<Widget> constructEvents() {
    List<Widget> list = List<Widget>();
    bool first = true;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    for (var event in events) {
      if (!first) {
        list.add(
          SizedBox(
            height: height,
            width: width * 0.54,
            child: Single_Event(event: event),
          ),
        );
      }
      first = false;
    }
    return list;
  }
}

class Single_Event extends StatelessWidget {
  final Event event;

  //constructor
  Single_Event({
    this.event,
  });
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SizedBox(
        height: height,
        child: Card(
          child: Hero(
            tag: event.name,
            child: Material(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventWidget(
                        event: event,
                      ),
                    ),
                  );
                },
                child: GridTile(
                    footer: Container(
                      color: Colors.white70,
                      child: ListTile(
                        title: Column(children: <Widget>[
                          Text(event.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  DateFormat.yMMMMd('en_US')
                                      .format(event.startDate),
                                  style: TextStyle(
                                      color: Utils.header,
                                      fontWeight: FontWeight.w800),
                                ),
                              ])
                        ]),
                      ),
                    ),
                    child: Image.network(
                      WebAPI.baseURL + event.poster.url,
                      fit: BoxFit.contain,
                    )),
              ),
            ),
          ),
        ));
  }
}
