import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/models/activity.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/Utils.dart';
import 'package:connect_plus/widgets/CachedImageBox.dart';

class ActivityWidget extends StatefulWidget {
  ActivityWidget({Key key, @required this.activity}) : super(key: key);

  final Activity activity;

  @override
  State<StatefulWidget> createState() {
    return new _ActivityState(this.activity);
  }
}

class _ActivityState extends State<ActivityWidget>
    with TickerProviderStateMixin {
  final Activity activity;

  List<Activity> ergActivities;
  bool loading = true;

  AnimationController controller;
  Animation<double> animation;
  bool activityLoaded = false;
  _ActivityState(this.activity);

  @override
  void initState() {
    super.initState();
    getERGActivities();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getERGActivities() async {
    final activities = await WebAPI.getActivitiesByERG(activity.erg);

    setState(() {
      ergActivities = activities.where((ev) => ev.id != activity.id).toList();
      loading = false;
      activityLoaded = true;
    });
  }

  Widget urlToImage(String imageURL) {
    return Expanded(
        child: FittedBox(
      fit: BoxFit.contain,
      child: CachedImageBox(
        imageurl: imageURL,
      ),
    ));
  }

  List<Widget> activitiesByERG() {
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size.aspectRatio;

    List<Widget> list = List<Widget>();
    for (var ergActivity in ergActivities) {
      list.add(Container(
        padding: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
        width: width * 0.45,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              urlToImage(ergActivity.poster),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActivityWidget(
                              activity: ergActivity,
                            ),
                          ));
                    },
                    child: Text(
                      ergActivity.name,
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

  Widget _activityPoster() {
    String imageUrl =  activity.poster;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CachedImageBox(
              imageurl: imageUrl,
            ))
      ],
    );
  }

  Widget _relatedActivities() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    final _scrollController = ScrollController();

    if (ergActivities.isNotEmpty) {
      return Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, height * 0.05, 0, height * 0.02),
              child: Utils.titleText(
                  textString: "Activities by ${activity.erg.name}",
                  fontSize: size * 39,
                  textcolor: Utils.header)),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, width * 0.02, height * 0.02),
              child: SizedBox(
                  height: height * 0.28,
                  child: ListView(
                    controller: _scrollController,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: activitiesByERG(),
                  ))),
        ],
      );
    } else {
      return SizedBox(
        height: 1,
      );
    }
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
                  height: 10,
                ),
                _description(),
                _relatedActivities(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _description() {
    var size = MediaQuery.of(context).size.aspectRatio;
    String time = DateFormat.Hm('en_US').format(activity.startDate);
    String date = DateFormat.yMMMMd('en_US').format(activity.startDate);
    var textV = "";
    var text = "";
    if (activity.venue != null) {
      textV += "\n\nVenue:" + activity.venue.toString() + '\n';
    }
    text += "\nStart Date: " + date;
    text += "\n\nTime: " + time;
    text += "\n\nRecurrence: " + activity.recurrence;
    text += "\n\nDay(s): " + activity.days;
    if (activity.onBehalfOf != null) {
      text += "\n\nOn behalf of: " + activity.onBehalfOf;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        SelectableText(
          textV,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: size * 35,
          ),
        ),
        Row(children: <Widget>[
          Text(
            "Zoom ID: ",
            style: TextStyle(fontSize: size * 32, fontWeight: FontWeight.bold),
          ),
          InkWell(
            child: SelectableText(
              activity.zoomID,
              style: TextStyle(fontSize: size * 30, color: Colors.blue),
            ),
            onTap: _launchZoomLink,
          )
        ]),
        SelectableText(
          text,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: size * 35,
          ),
        ),
        ClickableButton(
            link: activity.registrationLink,
            text: 'Register',
            launchURL: _launchURL),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    if (loading == true && !activityLoaded) {
      return Scaffold(
        body: ImageRotate(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(activity.name),
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
                    child: _activityPoster(),
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchZoomLink() async {
    var url = activity.zoomID;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ClickableButton extends StatelessWidget {
  const ClickableButton({Key key, this.link, this.text, this.launchURL})
      : super(key: key);
  final String link;
  final String text;
  final void Function(String) launchURL;

  @override
  Widget build(BuildContext context) {
    return link == ''
        ? Container()
        : Center(
            child: RaisedButton(
              onPressed: () => launchURL(link ?? ''),
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
                padding: const EdgeInsets.fromLTRB(25, 7, 25, 7),
                child: Text(
                  this.text,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
  }
}
