import 'dart:convert';
import 'dart:typed_data';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:connect_plus/Activity.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:math';

class Activities extends StatefulWidget {
  Activities({
    Key key,
  }) : super(key: key);
  static final _random = new Random();

  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<Activities>
    with AutomaticKeepAliveClientMixin<Activities> {
  @override
  bool get wantKeepAlive => true;

//  String token;
  var ip;
  var port;
  var activities = [];
  var randIndex;
  var emptyActivities = false;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  void initState() {
    super.initState();
    setEnv();
    getActivities();
  }

  Future setEnv() async {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  void getActivities() async {
    //    var ip = await EnvironmentUtil.getEnvValueForKey('SERVER_IP');
//    print(ip)
//    Working for android emulator -- set to actual ip for use with physical device
//    ip = "10.0.2.2";
//    port = '3300';
    var url = 'http://' + ip + ':' + port + '/activity';
    var token = localStorage.getItem("token");

    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200)
      setState(() {
        activities = json.decode(response.body);
        if (activities.isEmpty)
          emptyActivities = true;
        else
          randIndex = Activities._random.nextInt(activities.length);
      });
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

  Widget base64ToImage(String base64) {
    Uint8List bytes = base64Decode(base64);
    return SizedBox(
      width:
          MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3, // otherwise the logo will be tiny
      child: Image.memory(bytes),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size.aspectRatio;

    try {
      if (emptyActivities)
        return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Activities"),
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
            body: Center(child: Text("No Activities")));
      else
        return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Activities"),
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
                padding: const EdgeInsets.all(5),
                itemCount: 2,
                itemBuilder: (BuildContext context, int elem) {
                  if (elem == 0) {
                    return Padding(
                        padding: EdgeInsets.only(
                            top: height * 0.03, bottom: height * 0.02),
                        child: Text(
                          "Current Activities",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Utils.headline),
                        ));
                  } else {
                    return GridView.count(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        // Create a grid with 2 columns. If you change the scrollDirection to
                        // horizontal, this produces 2 rows.
                        crossAxisCount: 1,
                        addAutomaticKeepAlives: true,
                        children: List.generate(activities.length, (index) {
                          return Center(
                              child: Padding(
                            padding: EdgeInsets.only(bottom: height * 0.02),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                child: Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      base64ToImage(activities
                                          .elementAt(index)['poster']
                                              ['fileData']
                                          .toString()),
                                      Container(
                                    height: MediaQuery.of(context).size.height * 0.1,
                                        child: ButtonBar(
                                          alignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                activities
                                                    .elementAt(index)['name']
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: size * 40, color: Utils.headline),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Activity(
                                                            activity: activities
                                                                    .elementAt(
                                                                        index)[
                                                                'name'])));
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ));
                        }));
                  }
                }));
    } catch (err) {
      return LoadingWidget();
    }
  }
}
