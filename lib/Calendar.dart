import 'package:connect_plus/ActivityWidget.dart';
import 'package:connect_plus/WebinarWidget.dart';
import 'package:connect_plus/models/activity.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/webinar.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
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
  }

  void getEvents() async {
    var events = await WebAPI.getEvents();
    if (this.mounted) {
      for (var event in events) {
        var date = DateTime.parse(event.startDate.toString());
        if (_events[date] != null)
          _events[date].add(event);
        else
          _events[date] = [event];
      }
      setState(() {
        _all.addAll(_events);
      });
      getActivities();
    }
  }

  void getActivities() async {
    var activities = await WebAPI.getActivitiesDates();
    if (this.mounted) {
      for (var activity in activities) {
        activity.recurrenceDates.forEach((element) {
          var date = DateTime.parse(element.toString());
          if (_activities[date] != null)
            _activities[date].add(activity);
          else
            _activities[date] = [activity];
        });
      }
      setState(() {
        _all.addAll(_activities);
      });
      getWebinars();
    }
  }

  void getWebinars() async {
    var webinars = await WebAPI.getWebinars();
    if (this.mounted) {
      for (var webinar in webinars) {
        var date = DateTime.parse(webinar.startDate.toString());
        if (_webinars[date] != null)
          _webinars[date].add(webinar);
        else
          _webinars[date] = [webinar];
      }
      setState(() {
        _all.addAll(_webinars);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (_events.isEmpty && _webinars.isEmpty && _activities.isEmpty) {
      return Scaffold(
        body: ImageRotate(),
      );
    }
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
