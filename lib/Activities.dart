import 'dart:math';

import 'package:connect_plus/ActivityWidget.dart';
import 'package:connect_plus/models/activity.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/utils/map_indexed.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class Activities extends StatefulWidget {
  Activities({
    Key key,
  }) : super(key: key);
  static final _rand = new Random();

  @override
  MyActivitiesPageState createState() => MyActivitiesPageState();
}

class MyActivitiesPageState extends State<Activities>
    with AutomaticKeepAliveClientMixin<Activities> {
  @override
  bool get wantKeepAlive => true;

  List<Activity> activities = [];
  num randIndex;
  bool emptyActivities = true;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  void initState() {
    super.initState();
    getActivities();
  }

  void getActivities() async {
    final allActivities = await WebAPI.getActivities();
    if (this.mounted)
      setState(() {
        activities = allActivities;
        if (activities.length != 0) {
          emptyActivities = false;
        }
        randIndex = Activities._rand.nextInt(activities.length);
      });
  }

  Widget featuredImage() {
    try {
      final featuruedActivity = activities[randIndex];
      final imageURL = WebAPI.baseURL + featuruedActivity.poster.url;
      return FittedBox(
        fit: BoxFit.contain,
        child: Image.network(imageURL),
      );
    } catch (Exception) {
      return Scaffold(body: ImageRotate());
    }
  }

  Widget urlToImage(String imageUrl) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width *
          0.5, // otherwise the logo will be tiny
      child: Image.network(imageUrl),
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
          body: Padding(
            padding: EdgeInsets.only(top: height * 0.03, bottom: height * 0.02),
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: mapIndexed(activities, (index, activity) {
                return Center(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: height * 0.02),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.40,
                          child: Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                urlToImage(
                                    WebAPI.baseURL + activity.poster.url),
                                Container(
                                  height: 50,
                                  child: ButtonBar(
                                    alignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      FlatButton(
                                        child: Text(
                                          activity.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ActivityWidget(
                                                      activity: activity),
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
            ),
          ),
        );
    } catch (err) {
      return Scaffold(
        body: ImageRotate(),
      );
    }
  }
}
