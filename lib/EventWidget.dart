import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Navbar.dart';
import 'widgets/Utils.dart';
import 'dart:convert';
import 'widgets/Indicator.dart';

class EventWidget extends StatefulWidget {
  EventWidget({Key key, @required this.event}) : super(key: key);

  final Event event;

  @override
  State<StatefulWidget> createState() {
    return new _EventState(this.event);
  }
}

class _EventState extends State<EventWidget> with TickerProviderStateMixin {
  final Event event;

  List<Event> ergEvents;
  bool loading = true;

  AnimationController controller;
  Animation<double> animation;

  _EventState(this.event);

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
    getERGEvents();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future getERGEvents() async {
    final events = await WebAPI.getEventsByERG(event.erg);
    if (this.mounted)
      setState(() {
        ergEvents = events.where((ev) => ev.id != event.id).toList();
        loading = false;
      });
  }

  Widget urlToImage(String imageURL) {
    return Expanded(
        child: FittedBox(fit: BoxFit.contain, child: Image.network(imageURL)));
  }

  List<Widget> eventsByERG() {
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size.aspectRatio;

    List<Widget> list = List<Widget>();
    for (var ergEvent in ergEvents) {
      list.add(Container(
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
        width: width * 0.50,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              urlToImage(WebAPI.baseURL + ergEvent.poster.url),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventWidget(
                              event: ergEvent,
                            ),
                          ));
                    },
                    child: Text(
                      ergEvent.name,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: size * 35, color: Utils.header),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ));
    }
    return list;
  }

  Widget _eventPoster() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Image.network(WebAPI.baseURL + event.poster.url),
        )
      ],
    );
  }

  Widget _detailWidget() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    final _scrollController = ScrollController();

    return DraggableScrollableSheet(
      maxChildSize: .6,
      initialChildSize: .5,
      minChildSize: .4,
      builder: (context, scrollController) {
        return Container(
          padding: Utils.padding.copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Utils.background),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: width * 0.1,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Utils.header,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                _description(),
                Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, height * 0.05, 0, height * 0.02),
                    child: Utils.titleText(
                        textString: "Events by ${event.erg.name}",
                        fontSize: size * 39,
                        textcolor: Utils.header)),
                Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, 0, width * 0.02, height * 0.02),
                    child: SizedBox(
                        height: height * 0.25,
                        child: ListView(
                          controller: _scrollController,
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: eventsByERG(),
                        ))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _description() {
    String time = DateFormat.Hm('en_US').format(event.startDate);
    String date = DateFormat.yMMMMd('en_US').format(event.startDate);
    var size = MediaQuery.of(context).size.aspectRatio;
    var text = "";
    if (event.venue != null) {
      text += "\n\nVenue: " + event.venue.toString();
    }

    text += "\n\nDate: " + date;

    text += "\n\nTime: " + time;
    if (event.onBehalfOf != null) {
      text += "\n\nOn behalf of: " + event.onBehalfOf.toString();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SelectableText(
          text,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: size * 35,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (loading == true) {
      return Scaffold(
        body: ImageRotate(),
      );
    } else
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(event.name),
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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Utils.secondaryColor,
                Utils.primaryColor,
              ],
              begin: Alignment.topRight,
              end: Alignment.topLeft,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: Utils.paddingPoster,
                    height: height * 0.35,
                    child: _eventPoster(),
                  )
                ],
              ),
              _detailWidget(),
            ],
          ),
        ),
      );
  }
}
