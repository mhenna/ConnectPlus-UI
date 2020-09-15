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

class Activity extends StatefulWidget {
  Activity({Key key, @required this.activity}) : super(key: key);

  final String activity;

  @override
  State<StatefulWidget> createState() {
    return new _ActivityState(this.activity);
  }
}

class _ActivityState extends State<Activity> with TickerProviderStateMixin {
  var ip;
  var port;
  var activityDetails;
  var ergActivities;
  final String activity;
  bool loading = true;

  AnimationController controller;
  Animation<double> animation;

  _ActivityState(this.activity);

  @override
  void initState() {
    super.initState();
    getActivity();
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

  Future getActivity() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var url = 'http://' + ip + ':' + port + '/activity/getActivity/$activity';

    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200)
      setState(() {
        activityDetails = json.decode(response.body);
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
                    child: Text(
                      activityDetails['activity']['name'],
                      style: TextStyle(
                          fontSize: size * 55,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ))
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

  Widget _activityPoster() {
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
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.width * 0.65,
              child: Image.memory(base64Decode(
                  activityDetails['poster']['fileData'].toString())),
            )
          ],
        ),
      );
    }
  }

  Widget _detailWidget() {
    var width = MediaQuery.of(context).size.width;

    if (loading == true) {
      return CircularIndicator();
    } else {
      return DraggableScrollableSheet(
        maxChildSize: .5,
        initialChildSize: .4,
        minChildSize: .3,
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
                    height: 20,
                  ),
                  _description(),
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
        activityDetails['activity']['startDate'].toString().split("T")[1];
    int index = fulltime.lastIndexOf(":");
    String time = fulltime.toString().substring(0, index);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Utils.titleText(
            textString: "Activity Details",
            fontSize: size * 37,
            textcolor: Colors.black),
        SizedBox(height: 15),
        Row(children: <Widget>[
          Text(
            "Venue: ",
            style: TextStyle(fontSize: size * 30, fontWeight: FontWeight.bold),
          ),
          Text(activityDetails['activity']['venue'],
              style: TextStyle(fontSize: size * 28))
        ]),
        SizedBox(height: 5),
        Row(children: <Widget>[
          Text(
            "Date: ",
            style: TextStyle(fontSize: size * 30, fontWeight: FontWeight.bold),
          ),
          Text(
              activityDetails['activity']['startDate'].toString().split("T")[0],
              style: TextStyle(fontSize: size * 28))
        ]),
        SizedBox(height: 5),
        Row(children: <Widget>[
          Text(
            "Time: ",
            style: TextStyle(fontSize: size * 30, fontWeight: FontWeight.bold),
          ),
          Text(time, style: TextStyle(fontSize: size * 28))
        ]),
        SizedBox(height: 5),
        Row(children: <Widget>[
          Text(
            "Reccurence: ",
            style: TextStyle(fontSize: size * 30, fontWeight: FontWeight.bold),
          ),
          Text(activityDetails['activity']['recurrence'],
              style: TextStyle(fontSize: size * 28))
        ]),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  _activityPoster(),
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
