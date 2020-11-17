import 'package:connect_plus/ActivityWidget.dart';
import 'package:connect_plus/WebinarWidget.dart';
import 'package:connect_plus/models/activity.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/webinar.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:localstorage/localstorage.dart';
import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/EventWidget.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  Map<DateTime, List<dynamic>> _activities;
  Map<DateTime, List<dynamic>> _webinars;
  Map<DateTime, List<dynamic>> _all;
  List<dynamic> _selectedEvents;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  @override
  void initState() {
    _events = {};
    _activities = {};
    _webinars = {};
    _all = {};
    _selectedEvents = [];
    _controller = CalendarController();
    super.initState();
    getEvents();
    getActivities();
    getWebinars();
  }

  void getEvents() async {
    var events = await WebAPI.getEvents();
    for (var event in events) {
      var date = DateTime.parse(event.startDate.toString());
      if (_events[date] != null)
        _events[date].add(event);
      else
        _events[date] = [event];
    }
    _all.addAll(_events);
  }

  void getActivities() async {
    var activities = await WebAPI.getActivities();
    for (var activity in activities) {
      var date = DateTime.parse(activity.startDate.toString());
      if (_activities[date] != null)
        _activities[date].add(activity);
      else
        _activities[date] = [activity];
    }
    _all.addAll(_activities);
  }

  void getWebinars() async {
    var webinars = await WebAPI.getWebinars();
    for (var webinar in webinars) {
      var date = DateTime.parse(webinar.date.toString());
      if (_webinars[date] != null)
        _webinars[date].add(webinar);
      else
        _webinars[date] = [webinar];
    }
    _all.addAll(_webinars);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Calendar"),
          centerTitle: true,
          backgroundColor: Utils.header,
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
        ),
        drawer: NavDrawer(),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              Container(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.04, height * 0.02, width * 0.04, height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Utils.headline),
                          width: 10.0,
                          height: 10.0,
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text("Event & Webinar")
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle, color: Utils.headline),
                          width: 10.0,
                          height: 10.0,
                        ),
                        SizedBox(
                          width: width * 0.02,
                        ),
                        Text("Activity")
                      ],
                    )
                  ],
                ),
              )),
              TableCalendar(
                events: _all,
                calendarController: _controller,
                calendarStyle: CalendarStyle(
                  todayColor: Utils.headline,
                  selectedColor: Colors.black,
                ),
                weekendDays: [5, 6],
                onDaySelected: (date, events) {
                  setState(() {
                    _selectedEvents = events;
                  });
                },
                builders: CalendarBuilders(
                  singleMarkerBuilder: (context, date, event) {
                    if (event.runtimeType == Activity) {
                      return Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Utils.headline),
                        width: 7.0,
                        height: 7.0,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      );
                    } else
                      return Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(int.parse(
                                event.erg.color.replaceFirst('#', '0xFF')))),
                        width: 7.0,
                        height: 7.0,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      );
                  },
                ),
              ),
              ..._selectedEvents.map((event) => ListTile(
                  title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(event.name),
                        if (event.runtimeType == Event ||
                            event.runtimeType == Webinar)
                          Row(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(int.parse(event.erg.color
                                        .replaceFirst('#', '0xFF')))),
                                width: 10.0,
                                height: 10.0,
                              ),
                              SizedBox(
                                width: width * 0.02,
                              ),
                              Text(event.erg.name)
                            ],
                          )
                      ],
                    ),
                  ),
                  onTap: () {
                    if (event.runtimeType == Event) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventWidget(
                            event: event,
                          ),
                        ),
                      );
                    } else if (event.runtimeType == Activity) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ActivityWidget(activity: event)),
                      );
                    } else if (event.runtimeType == Webinar) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                WebinarWidget(webinar: event)),
                      );
                    }
                  })),
            ])));
  }
}
