import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/webinar.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/Utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connect_plus/widgets/CachedImageBox.dart';
import 'package:connect_plus/widgets/app_button.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as add2calendar;

class WebinarWidget extends StatefulWidget {
  WebinarWidget({Key key, @required this.webinar}) : super(key: key);

  final Webinar webinar;

  @override
  State<StatefulWidget> createState() {
    return new _WebinarState(this.webinar);
  }
}

class _WebinarState extends State<WebinarWidget> with TickerProviderStateMixin {
  final Webinar webinar;

  List<Webinar> ergWebinars;
  bool loading = true;

  _WebinarState(this.webinar);

  @override
  void initState() {
    super.initState();
    getERGWebinars();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getERGWebinars() async {
    final webinars = await WebAPI.getWebinarsByERG(webinar.erg);
    if (this.mounted)
      setState(() {
        ergWebinars = webinars.where((ev) => ev.id != webinar.id).toList();
        loading = false;
      });
  }

  Widget urlToImage(String imageURL) {
    return Expanded(
      child: SizedBox(
        width: 250, // otherwise the logo will be tiny
        child: CachedImageBox(
          imageurl: imageURL,
        ),
      ),
    );
  }

  List<Widget> webinarsByERG() {
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size.aspectRatio;

    List<Widget> list = List<Widget>();
    for (var ergwebinar in ergWebinars) {
      list.add(Container(
        padding: EdgeInsets.fromLTRB(7.0, 0.0, 7.0, 0.0),
        width: width * 0.50,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              urlToImage(WebAPI.baseURL + ergwebinar.poster.url),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebinarWidget(
                              webinar: ergwebinar,
                            ),
                          ));
                    },
                    child: Text(
                      ergwebinar.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Utils.header,
                      ),
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

  Widget _webinarPoster() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CachedImageBox(
            imageurl: WebAPI.baseURL + webinar.poster.url,
          ),
        )
      ],
    );
  }

  Widget _relatedWebinars() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    final _scrollController = ScrollController();

    if (ergWebinars.isNotEmpty) {
      return Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, height * 0.05, 0, height * 0.02),
              child: Utils.titleText(
                  textString: "Webinars by ${webinar.erg.name}",
                  fontSize: size * 39,
                  textcolor: Utils.header)),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, width * 0.02, height * 0.02),
            child: SizedBox(
              height: height * 0.25,
              child: ListView(
                controller: _scrollController,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: webinarsByERG(),
              ),
            ),
          ),
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
                  height: 20,
                ),
                _description(),
                _relatedWebinars(),
              ],
            ),
          ),
        );
      },
    );
  }
  void _addWebinarToCalendar(){
    DateTime endDate=webinar.startDate.add(Duration(hours:webinar.duration.toInt()));
    final add2calendar.Event event = add2calendar.Event(
      title: webinar.name,
      startDate: webinar.startDate,
      endDate: endDate
    );
    add2calendar.Add2Calendar.addEvent2Cal(event);
  }

  Widget _description() {
    var size = MediaQuery.of(context).size.aspectRatio;
    String time = DateFormat.Hm('en_US').format(webinar.startDate);
    String date = DateFormat.yMMMMd('en_US').format(webinar.startDate);
    var text = "";
    text += "\n\nCommittee: " + webinar.erg.name;
    text += "\n\nDate: " + date;

    text += "\n\nTime: " + time;
    text += "\n\nDuration: " + webinar.duration.toString() + 'Hour(s)';

    if (webinar.onBehalfOf != null) {
      text += "\n\nOn behalf of: " + webinar.onBehalfOf;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 10),
        SelectableText(
          text,
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: size * 35,
          ),
        ),
        SizedBox(height: 30),
        Center(
          child: AppButton(
              onPress: ()=> _launchURL(webinar.url ?? ''),
              title: 'Webinar Link'
          )
        ),
        SizedBox(height: 15),
        Center(
          child: AppButton(
              onPress: ()=> _addWebinarToCalendar(),
              title: 'Add to Calendar'
          )
        ),
        Divider(
          color: Colors.transparent,
          height: 10,
        ),
        // trivia button
        webinar.trivia == null
            ? Container()
            : Center(
                child:AppButton(
                    onPress: ()=>  _launchURL(webinar.trivia ?? ''),
                    title: 'Trivia Link'
                )
              ),
      ],
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    if (loading == true) {
      return Scaffold(
        body: ImageRotate(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(webinar.name),
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
                    child: _webinarPoster(),
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
}
