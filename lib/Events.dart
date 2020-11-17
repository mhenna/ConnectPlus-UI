import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/utils/map_indexed.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/EventWidget.dart';
import 'package:localstorage/localstorage.dart';
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
  List<Event> events = [];
  num randIndex;
  bool emptyEvents = true;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  void initState() {
    super.initState();
    getEvents();
  }

  void getEvents() async {
    final allEvents = await WebAPI.getEvents();
    setState(() {
      events = allEvents;
      if (events.length != 0) {
        emptyEvents = false;
      }
      randIndex = Events._random.nextInt(events.length);
    });
  }

  Widget featuredImage() {
    try {
      final featuredEvent = events[randIndex];
      final imageURL = WebAPI.baseURL + featuredEvent.poster.url;
      return FittedBox(
        fit: BoxFit.contain,
        child: Image.network(imageURL),
      );
    } catch (Exception) {
      return LoadingWidget();
    }
  }

  Widget urlToImage(String imageUrl) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width, // otherwise the logo will be tiny
      child: Image.network(imageUrl),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    try {
      LoadingWidget();
      if (emptyEvents)
        return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Events"),
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
            body: Center(child: Text("No Events")));
      else
        return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Events"),
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
            body: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                itemCount: 2,
                itemBuilder: (BuildContext context, int elem) {
                  if (elem == 0) {
                    return Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.03, bottom: height * 0.02),
                        child: Text(
                          "Current Events",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Utils.headline),
                        ));
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      children: mapIndexed(events, (index, event) {
                        return Center(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: height * 0.02),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  height:
                                      MediaQuery.of(context).size.height * 0.50,
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        urlToImage(
                                            WebAPI.baseURL + event.poster.url),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          child: ButtonBar(
                                            alignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  event.name,
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 22),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EventWidget(
                                                              event: event),
                                                    ),
                                                  );
                                                },
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ))),
                        );
                      }).toList(),
                    );
                  }
                }));
    } catch (err) {
      return LoadingWidget();
    }
  }
}
