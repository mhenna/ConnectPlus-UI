import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'package:connect_plus/Navbar.dart';

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
    _all={};
    _selectedEvents = [];
    _controller = CalendarController();
    setEnv();
    getEvents();
    getActivities();
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
        for (var date in dates)
        {
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


  Widget _buildEventsMarker(DateTime date, List events) {
     for (var item in events) {
        bool condition= _events.containsKey(DateTime.parse(item['startDate']));
        return AnimatedContainer(
         duration: const Duration(milliseconds: 300),
         decoration: BoxDecoration(
          shape:  condition ? BoxShape.circle : BoxShape.rectangle,
          color:  _controller.isSelected(date)? (condition ? Colors.brown[500] : Colors.blue[500])
                 : _controller.isToday(date) ?  (condition ? Colors.red[300] : Colors.yellow[400]) 
                 : (condition ? Colors.black : Colors.green[300]) 
        ),
         width: 16.0,  
        height: 16.0,
        child: Center(
         child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
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
                weekendDays: [5, 6],
                onDaySelected: (date, events) {
                  setState(() {
                    _selectedEvents = events;
                  });
                },
              builders: CalendarBuilders(
                markersBuilder: (context, date, events, holidays) {
                final children = <Widget>[];
                if (events.isNotEmpty) {
                children.add(
                  Positioned(
                   right: 1,
                   bottom: 1,
                   child: _buildEventsMarker(date, events),
                  ),
                );
              }
              return children;
           },
          ),
                
              ),

              ..._selectedEvents.map((event) => ListTile(
                    title: Text(event["name"]),
                  )),
            ])));
  }
}
