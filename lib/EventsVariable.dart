import 'package:flutter/material.dart';

class EventsVariables extends StatefulWidget {
  @override
  _EventsVariablesState createState() => _EventsVariablesState();
}

class _EventsVariablesState extends State<EventsVariables> {
  var event_list = [
    {
      "name": "Family Day",
      "picture": "assets/famDay.jpg",
      "date": "20/10/2019",
    },
    {
      "name": "Olympics Day",
      "picture": "assets/olympics.jpg",
      "date": "16/12/2019",
    },
    {
      "name": "fun Day",
      "picture": "assets/olympics.jpg",
      "date": "16/12/2019",
    }

  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        itemCount: event_list.length,
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Single_Event(
            event_name: event_list[index]['name'],
            event_picture: event_list[index]['picture'],
            event_date: event_list[index]['date'],
          );
        });
  }
}

class Single_Event extends StatelessWidget {
  final event_name;
  final event_picture;
  final event_date;

  //constructor
  Single_Event({
    this.event_name,
    this.event_picture,
    this.event_date,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: event_name,
        child: Material(
          child: InkWell(
            onTap: () {},
            child: GridTile(
                footer: Container(
                  color: Colors.white70,
                  child: ListTile(
                    leading: Text(event_name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    title: Text(event_date,
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w800)
                    ),
                  ),
                ),
                child: Image.asset(
                  event_picture,
                  fit: BoxFit.cover,
                )),
          ),
        ),
      ),
    );
  }
}
