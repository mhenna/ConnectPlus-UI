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
    print("event Name: $event and erg name : $erg");
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
    List<Widget> list = List<Widget>();
    for (var ergEvent in ergEvents) {
      if (ergEvent['_id'] != eventDetails['event']['_id']) {
        list.add(Container(
          padding: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
          width: 200.0,
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
                        style: TextStyle(fontSize: 22),
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
    return Container(
      padding: Utils.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 15,
            padding: 12,
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
        padding: const EdgeInsets.all(20.0),
        child: const Text('Register', style: TextStyle(fontSize: 20)),
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
              width: 250,
              child: Image.memory(
                  base64Decode(eventDetails['poster']['fileData'].toString())),
            )
          ],
        ),
      );
    }
  }

  Widget _detailWidget() {
    if (loading == true) {
      return CircularIndicator();
    } else {
      return DraggableScrollableSheet(
        maxChildSize: .8,
        initialChildSize: .8,
        minChildSize: .7,
        builder: (context, scrollController) {
          return Container(
            padding: Utils.padding.copyWith(bottom: 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                color: Colors.white),
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
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                          color: Utils.iconColor,
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Utils.titleText(
                            textString: eventDetails['event']['name'],
                            fontSize: 25,
                            textcolor: Colors.black),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  _dateWidget(eventDetails['event']['startDate']),
                  SizedBox(
                    height: 20,
                  ),
                  _description(),
                  SizedBox(
                    height: 20,
                  ),
                  Center(child: _registerButton()),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 64.0, 0, 8.0),
                      child: Utils.titleText(
                          textString: "Events by $erg",
                          fontSize: 25,
                          textcolor: Colors.black)),
                  Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: SizedBox(
                          height: 200,
                          child: ListView(
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
  }

  Widget _dateWidget(String text) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Utils.iconColor, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color: Utils.iconColor,
      ),
      child: Utils.titleText(
        textString: text,
        fontSize: 16,
        textcolor: Color(0xffffffff),
      ),
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Utils.titleText(
            textString: "Event Details", fontSize: 14, textcolor: Colors.black),
        SizedBox(height: 20),
        Text("venue :" + eventDetails['event']['venue']),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      drawer: NavDrawer(),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [const Color(0xfff7501e), const Color(0xffed136e)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _appBar(),
                  _eventPoster(),
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
