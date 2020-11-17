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
      child: SizedBox(
        width: MediaQuery.of(context)
            .size
            .width, // otherwise the logo will be tiny
        child: Image.network(imageURL),
      ),
    );
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

  Widget _appBar() {
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size.aspectRatio;
    var height = MediaQuery.of(context).size.height;
    return Container(
      padding: Utils.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _icon(
            Icons.arrow_back_ios,
            color: Utils.header,
            size: size * 30,
            padding: size * 0.03,
            isOutLine: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, height * 0.03, 0, height * 0.02),
                    child: SizedBox(
                        child: new Text(
                      event.name,
                      style: TextStyle(
                          fontSize: size * 53,
                          color: Utils.background,
                          fontWeight: FontWeight.w600),
                    )))
              ],
            ),
          ),
          SizedBox(
            width: width * 0.12,
          )
        ],
      ),
    );
  }

  Widget _icon(
    IconData icon, {
    Color color = Utils.iconColor,
    double size = 20,
    double padding = 10,
    bool isOutLine = false,
    Function onPressed,
  }) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(padding),
      // margin: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
            color: Utils.iconColor,
            style: isOutLine ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color: isOutLine ? Colors.white : Theme.of(context).backgroundColor,
      ),
      child: Icon(icon, color: color, size: size),
    ).ripple(() {
      if (onPressed != null) {
        onPressed();
      }
    }, borderRadius: BorderRadius.all(Radius.circular(13)));
  }

  Widget _registerButton() {
    return RaisedButton(
      onPressed: () {},
      color: Utils.iconColor,
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Utils.iconColor)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          gradient: LinearGradient(
            colors: [
              Utils.secondaryColor,
              Utils.primaryColor,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Text(
          'Register',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
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
//                  _dateWidget(eventDetails['event']['startDate'].toString().split("T")[0]),
                SizedBox(
                  height: 20,
                ),
                _description(),
                SizedBox(
                  height: 20,
                ),
                // Center(child: _registerButton()),
                Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, height * 0.08, 0, height * 0.02),
                    child: Utils.titleText(
                        textString: "Events by ${event.erg.name}",
                        fontSize: size * 39,
                        textcolor: Utils.header)),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        width * 0.02, 0, width * 0.02, height * 0.02),
                    child: SizedBox(
                        height: height * 0.25,
                        child: Scrollbar(
                            controller: _scrollController,
                            isAlwaysShown: true,
                            child: ListView(
                              controller: _scrollController,
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: eventsByERG(),
                            )))),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dateWidget(String text) {
    return Container(
      padding: EdgeInsets.all(10),
//      decoration: BoxDecoration(
//        border: Border.all(color: Utils.iconColor, style: BorderStyle.solid),
//        borderRadius: BorderRadius.all(Radius.circular(13)),
//        color: Utils.iconColor,
//      ),
      child: Utils.titleText(
        textString: text,
        fontSize: 16,
        textcolor: Colors.black,
      ),
    );
  }

  Widget _description() {
    var size = MediaQuery.of(context).size.aspectRatio;
    String time = DateFormat.Hm('en_US').format(event.startDate);
    String date = DateFormat.yMMMMd('en_US').format(event.startDate);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Utils.titleText(
            textString: "Event Details",
            fontSize: size * 39,
            textcolor: Utils.header),
        SizedBox(height: 15),
        Row(children: <Widget>[
          Text(
            "Venue: ",
            style: TextStyle(fontSize: size * 32, fontWeight: FontWeight.bold),
          ),
          Text(
            event.venue,
            style: TextStyle(fontSize: size * 30),
          )
        ]),
        SizedBox(height: 5),
        Row(children: <Widget>[
          Text(
            "Date: ",
            style: TextStyle(
              fontSize: size * 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            date,
            style: TextStyle(fontSize: size * 30),
          )
        ]),
        SizedBox(height: 5),
        Row(children: <Widget>[
          Text(
            "Time: ",
            style: TextStyle(
              fontSize: size * 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            time,
            style: TextStyle(fontSize: size * 30),
          )
        ]),
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
        backgroundColor: Utils.background,
        drawer: NavDrawer(),
        body: SafeArea(
          child: Container(
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
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    _appBar(),
                    Container(
                      height: height * 0.3,
                      child: _eventPoster(),
                    )
                  ],
                ),
                _detailWidget(),
              ],
            ),
          ),
        ),
      );
  }
}
