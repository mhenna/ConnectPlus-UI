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
  Activity({Key key, @required this.activity, @required this.erg}) : super(key: key);

  final String activity;
  final String erg;

  @override
  State<StatefulWidget> createState() {
    return new _ActivityState(this.activity, this.erg);
  }
}

class _ActivityState extends State<Activity> with TickerProviderStateMixin {
  var ip;
  var port;
  var activityDetails;
  var ergActivities;
  final String activity;
  final String erg;
  bool loading = true;

  AnimationController controller;
  Animation<double> animation;

  _ActivityState(this.activity, this.erg);

  @override
  void initState() {
    super.initState();
    getActivity();
    print("Activity Name: $activity and erg name : $erg");
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
        getERGActivities();
      });
  }

  Future getERGActivities() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var url = 'http://' + ip + ':' + port + '/activity/getByERG/$erg';

    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200)
      setState(() {
        ergActivities = json.decode(response.body);
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

  List<Widget> activitiesByERG() {
    List<Widget> list = List<Widget>();
    for (var ergActivity in ergActivities) {
      if (ergActivity['_id'] != activityDetails['activity']['_id']) {
        list.add(Container(
          padding: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
          width: 200.0,
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                base64ToImage(ergActivity['poster']['fileData'].toString()),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Activity(
                                activity: ergActivity['name'],
                                erg: ergActivity['ERG'],
                              ),
                            ));
                      },
                      child: Text(
                        ergActivity['name'].toString(),
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
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: const Text('Register', style: TextStyle(fontSize: 20)),
      ),
    );
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
              width: MediaQuery.of(context).size.width,
              child: Image.memory(
                  base64Decode(activityDetails['poster']['fileData'].toString())),
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
        maxChildSize: .7,
        initialChildSize: .6,
        minChildSize: .5,
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
                            textString: activityDetails['activity']['name'],
                            fontSize: 25,
                            textcolor: Colors.black),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                          textString: "Activities by $erg",
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
                            children: activitiesByERG(),
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
    String fulltime =
        activityDetails['activity']['startDate'].toString().split("T")[1];
    int index = fulltime.lastIndexOf(":");
    String time = fulltime.toString().substring(0, index);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Utils.titleText(
            textString: "Activity Details", fontSize: 24, textcolor: Colors.black),
        SizedBox(height: 15),
        Row(children: <Widget>[
          Text(
            "Venue: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(activityDetails['activity']['venue'], style: TextStyle(fontSize: 18))
        ]),
        SizedBox(height: 5),
        Row(children: <Widget>[
          Text(
            "Date: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(activityDetails['activity']['startDate'].toString().split("T")[0],
              style: TextStyle(fontSize: 18))
        ]),
        SizedBox(height: 5),
        Row(children: <Widget>[
          Text(
            "Time: ",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(time, style: TextStyle(fontSize: 18))
        ]),
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
