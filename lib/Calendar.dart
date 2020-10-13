import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
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
  Map<DateTime, List<dynamic>> _all;
  List<dynamic> _selectedEvents;
  var ip;
  var port;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  @override
  void initState() {
    super.initState();
    _events = {};
    _activities = {};
    _all = {};
    _selectedEvents = [];
    _controller = CalendarController();
    getEvents();
    getActivities();
  }

  void getEvents() async {
    var events;
    String token = localStorage.getItem("token");
    var url = 'http://' + ip + ':' + port + '/event';
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      events = json.decode(response.body);
      for (var event in events) {
        var date = DateTime.parse(event["startDate"]);
        if (_events[date] != null)
          _events[date].add(event);
        else
          _events[date] = [event];
      }
      _all.addAll(_events);
    }
  }

  void getActivities() async {
    var activities;
    String token = localStorage.getItem("token");
    var url = 'http://' + ip + ':' + port + '/activity';
    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });
    if (response.statusCode == 200) {
      activities = json.decode(response.body);
      for (var activity in activities) {
        var dates = activity["recurrenceDates"];
        for (var date in dates) {
          date = DateTime.parse(date);
          if (_activities[date] != null)
            _activities[date].add(activity);
          else
            _activities[date] = [activity];
        }
      }
      _all.addAll(_activities);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calendar'),
        ),
        drawer: NavDrawer(),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
              TableCalendar(
                events: _all,
                calendarController: _controller,
                calendarStyle: CalendarStyle(
                  todayColor: Color(0xFFE15F5F),
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
                    bool condition =
                        _events.containsKey(DateTime.parse(event['startDate']));
                    Color cor = Color(int.parse(event["ERG"]["color"]));
                    return Container(
                      decoration: condition
                          ? BoxDecoration(shape: BoxShape.circle, color: cor)
                          : BoxDecoration(
                              shape: BoxShape.rectangle, color: Colors.blue),
                      width: 7.0,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    );
                  },
                ),
              ),
              ..._selectedEvents.map((event) => ListTile(
                  title: Text(event["name"]),
                  onTap: () {
                    bool condition =
                        _events.containsKey(DateTime.parse(event['startDate']));
                    condition
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventWidget(event: event),
                            ),
                          )
                        : /*Add Activities navigation route here*/ MaterialPageRoute(
                            builder: (BuildContext context) {});
                  })),
            ])));
  }
}
