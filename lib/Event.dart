import 'package:connect_plus/Navbar.dart';
import 'package:flutter/material.dart';
import 'Navbar.dart';
import 'widgets/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'widgets/Indicator.dart';

class Event extends StatefulWidget {
  Event({Key key, @required this.event, @required this.erg}) : super(key: key);

  final String event;
  final String erg;

  @override
  State<StatefulWidget> createState() {
    return new _EventState(this.event, this.erg);
  }
}

class _EventState extends State<Event> with TickerProviderStateMixin {
  var ip;
  var port;
  var eventDetails;
  var ergEvents;
  final String event;
  final String erg;
  bool loading = true;

  AnimationController controller;
  Animation<double> animation;

  _EventState(this.event, this.erg);

  @override
  void initState() {
    super.initState();
    getEvent();
    setEnv();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  setEnv() {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future getEvent() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var url = 'http://' + ip + ':' + port + '/event/getEvent/$event';

    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200)
      setState(() {
        eventDetails = json.decode(response.body);
        getERGEvents();
      });
  }

  Future getERGEvents() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var url = 'http://' + ip + ':' + port + '/event/getByERG/$erg';

    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200)
      setState(() {
        ergEvents = json.decode(response.body);
        loading = false;
      });
  }

  Widget base64ToImage(String base64) {
    Uint8List bytes = base64Decode(base64);
    return Expanded(
      child: SizedBox(
        width: 250, // otherwise the logo will be tiny
        child: Image.memory(bytes),
      ),
    );
  }

  List<Widget> eventsByERG() {
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size.aspectRatio;

    List<Widget> list = List<Widget>();
    for (var ergEvent in ergEvents) {
      if (ergEvent['_id'] != eventDetails['event']['_id']) {
        list.add(Container(
          padding: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
          width: width * 0.45,
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                base64ToImage(ergEvent['poster']['fileData'].toString()),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Event(
                                event: ergEvent['name'],
                                erg: ergEvent['ERG'],
                              ),
                            ));
                      },
                      child: Text(
                        ergEvent['name'].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: size * 35, color: Utils.header),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
      }
    }
    return list;
  }

  Widget _appBar() {
    var size = MediaQuery.of(context).size.aspectRatio;
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
    if (loading == true) {
      return CircularIndicator();
    } else {
      return AnimatedBuilder(
        builder: (context, child) {
          return AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: animation.value,
            child: child,
          );
        },
        animation: animation,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Image.memory(
                  base64Decode(eventDetails['poster']['fileData'].toString())),
            )
          ],
        ),
      );
    }
  }

  Widget _detailWidget() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    final _scrollController = ScrollController();

    if (loading == true) {
      return CircularIndicator();
    } else {
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
                  SizedBox(height: 15),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Utils.titleText(
                            textString: eventDetails['event']['name'],
                            fontSize: size * 45,
                            textcolor: Utils.header),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
//                  _dateWidget(eventDetails['event']['startDate'].toString().split("T")[0]),
                  SizedBox(
                    height: 20,
                  ),
                  _description(),
                  SizedBox(
                    height: 20,
                  ),
                  Center(child: _registerButton()),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, height * 0.08, 0, height * 0.02),
                      child: Utils.titleText(
                          textString: "Events by $erg",
                          fontSize: size * 45,
                          textcolor: Utils.header)),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * 0.02, 0, width * 0.02, height * 0.02),
                      child: SizedBox(
                          height: height * 0.28,
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
    String fulltime =
        eventDetails['event']['startDate'].toString().split("T")[1];
    int index = fulltime.lastIndexOf(":");
    String time = fulltime.toString().substring(0, index);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Utils.titleText(
            textString: "Event Details",
            fontSize: size * 37,
            textcolor: Colors.black),
        SizedBox(height: 15),
        Row(children: <Widget>[
          Text(
            "Venue: ",
            style: TextStyle(fontSize: size * 30, fontWeight: FontWeight.bold),
          ),
          Text(eventDetails['event']['venue'],
              style: TextStyle(fontSize: size * 28))
        ]),
        SizedBox(height: 5),
        Row(children: <Widget>[
          Text(
            "Date: ",
            style: TextStyle(fontSize: size * 30, fontWeight: FontWeight.bold),
          ),
          Text(eventDetails['event']['startDate'].toString().split("T")[0],
              style: TextStyle(fontSize: size * 28))
        ]),
        SizedBox(height: 5),
        Row(children: <Widget>[
          Text(
            "Time: ",
            style: TextStyle(fontSize: size * 30, fontWeight: FontWeight.bold),
          ),
          Text(time, style: TextStyle(fontSize: size * 28 ))
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
