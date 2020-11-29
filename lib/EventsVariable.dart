import 'package:connect_plus/Events.dart';
import 'package:connect_plus/WebinarWidget.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/webinar.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:connect_plus/EventWidget.dart';

class EventsVariables extends StatefulWidget {
  EventsVariables({Key key, @required this.events, @required this.webinars})
      : super(key: key);

  final List<Event> events;
  final List<Webinar> webinars;

  @override
  State<StatefulWidget> createState() {
    return new _EventsVariablesState(this.events, this.webinars);
  }
}

class _EventsVariablesState extends State<EventsVariables>
    with TickerProviderStateMixin {
  List<Event> events = [];
  List<Webinar> webinars = [];
  List<dynamic> _all = [];
  String mostRecentEventPosterUrl;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  _EventsVariablesState(this.events, this.webinars);

  @override
  void initState() {
    super.initState();
    //getEvents();
    sortAll();
  }

  void getEvents() async {
    final allEvents = await WebAPI.getEvents();
    if (this.mounted) {
      setState(() {
        events = allEvents;
        _all.addAll(events);
        if (allEvents.isNotEmpty)
          mostRecentEventPosterUrl = WebAPI.baseURL + events.first.poster.url;
      });

      getWebinars();
    }
  }

  void getWebinars() async {
    final allWebinars = await WebAPI.getWebinars();
    if (this.mounted) {
      setState(() {
        webinars = allWebinars;
        _all.addAll(webinars);
        sortAll();
      });
    }
  }

  void sortAll() {
    _all.addAll(events);
    _all.addAll(webinars);
    _all.sort((b, a) => a.startDate.compareTo(b.startDate));
    if (webinars.isNotEmpty && events.isEmpty) {
      mostRecentEventPosterUrl = WebAPI.baseURL + webinars.first.poster.url;
    } else if (webinars.isEmpty && events.isNotEmpty) {
      mostRecentEventPosterUrl = WebAPI.baseURL + events.first.poster.url;
    } else if (webinars.isNotEmpty && events.isNotEmpty) {
      webinars.first.startDate.isAfter(events.first.startDate)
          ? mostRecentEventPosterUrl =
              WebAPI.baseURL + webinars.first.poster.url
          : mostRecentEventPosterUrl = WebAPI.baseURL + events.first.poster.url;
    }
  }

  Widget mostRecent() {
    return Container(
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.white, blurRadius: 3.0, offset: Offset(0.0, 0.50))
          ],
        ),
        child: Single_Event(event: _all.first));
  }

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    final height = MediaQuery.of(context).size.height;
    if (_all.isEmpty)
      return Center(
          child: Text(
        "No Recent Events or Webinars, Coming Soon!",
        style: TextStyle(fontWeight: FontWeight.w600),
      ));
    return Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 6, right: 6),
            child: Container(height: height * 0.27, child: mostRecent())),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(left: 6, right: 7, top: 5),
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

    for (var event in _all) {
      if (!first) {
        list.add(Padding(
            padding: EdgeInsets.only(right: 10),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.white,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 0.50))
                ],
              ),
              child: SizedBox(
                height: height,
                width: width * 0.60,
                child: Single_Event(event: event),
              ),
            )));
      }
      first = false;
    }
    return list;
  }
}

class Single_Event extends StatelessWidget {
  final dynamic event;

  //constructor
  Single_Event({
    this.event,
  });
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print(event.name);
    print(event.startDate);
    return SizedBox(
        height: height,
        child: Card(
          child: Hero(
            tag: event.name,
            child: Material(
              child: InkWell(
                onTap: () {
                  if (event.runtimeType == Event)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventWidget(
                          event: event,
                        ),
                      ),
                    );
                  else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebinarWidget(
                            webinar: event,
                          ),
                        ));
                  }
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
