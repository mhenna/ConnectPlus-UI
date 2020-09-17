import 'package:connect_plus/Activity.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/Event.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
    Map<DateTime, List<dynamic>> _activities;
  Map<DateTime, List<dynamic>> _all;
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
    setEnv();
    getEvents();
  }

  setEnv() {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
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
    print(events[0]);
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
              TableCalendar(
                events: _events,
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
                    bool condition =
                        _events.containsKey(DateTime.parse(event['startDate']));
                    if (event['ERG'] == null) {
                      return Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle, color: Utils.headline),
                        width: 7.0,
                        height: 7.0,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      );
                    } else
                      return Container(
                        decoration: condition
                            ? BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(int.parse(event['ERG']['color'])))
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
                    if (event['ERG'] == null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Activity(activity: event["name"])),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Event(
                                  event: event["name"],
                                  erg: event['ERG']["name"],
                                )),
                      );
                    }
                  })),
            ])));
  }
}
