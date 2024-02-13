
import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/qr_code_scanner_camera.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/Utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connect_plus/widgets/CachedImageBox.dart';
import 'package:connect_plus/services/firebase_functions_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connect_plus/services/firestore_services.dart';

class QrCodeScannerEventWidget extends StatefulWidget {
  QrCodeScannerEventWidget({Key key, @required this.event}) : super(key: key);

  final Event event;

  @override
  State<StatefulWidget> createState() {
    return new _EventState(this.event);
  }
}

class _EventState extends State<QrCodeScannerEventWidget>
    with TickerProviderStateMixin {
  final Event event;

  List<Event> ergEvents;
  bool loading = true;

  AnimationController controller;
  Animation<double> animation;
  final emailController = TextEditingController();
  Future<String> defaultEmailFuture;
  String defaultEmail;
  FirestoreServices _fs=FirestoreServices();

  _EventState(this.event);

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
    setDefaultEmail();
    getERGEvents();
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future getERGEvents() async {
    final events = await WebAPI.getEventsByERG(event.erg.id);
    if (this.mounted)
      setState(() {
        ergEvents = events.where((ev) => ev.id != event.id).toList();
        loading = false;
      });
  }
  Future<void> setDefaultEmail() async {
    defaultEmailFuture= _fs.getCurrentUserEmail();
  }

  Widget urlToImage(String imageURL) {
    return Expanded(
        child: FittedBox(
            fit: BoxFit.contain,
            child: CachedImageBox(
              imageurl: imageURL,
            )));
  }

  Widget _eventPoster() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CachedImageBox(
            imageurl: event.poster,
          ),
        )
      ],
    );
  }

  Widget _relatedEvents() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    final _scrollController = ScrollController();

    if (ergEvents.isNotEmpty) {
      return Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, height * 0.05, 0, height * 0.02),
              child: Utils.titleText(
                  textString: "Events by ${event.erg.name}",
                  fontSize: size * 39,
                  textcolor: Utils.header)),
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
                _relatedEvents(),
              ],
            ),
          ),
        );
      },
    );
  }
  void _showMessage(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 7,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  void _showEmailInputPopUp(String defaultEmail){
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(fontFamily: 'Arial', fontSize: 20.0);
    showDialog(
        context: context,
        builder: (BuildContext
        context) =>
            AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(32))),
              title: Text(
                  "Send Event Report To:"),
              content:
              Container(
                width:width*0.8,
                height:height*0.3,
                alignment: Alignment.center,
                child:
                Column(
                  mainAxisSize:
                  MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 25),
                      child: TextField(
                        controller: emailController..text = defaultEmail,
                        obscureText: false,
                        style: style,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                                width * 0.05, height * 0.025, width * 0.02, height * 0.02),
                            hintText: "Email",
                            border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
                      )
                    ),
                    ClickableButton(
                      text: 'Confirm',
                      onClick: () async {
                        FirebaseFunctionsServices _fbFunctions=FirebaseFunctionsServices();
                        bool success=await _fbFunctions.sendEventReportByMail(email:emailController.text,eventId:event.sId,eventName:event.name);
                        if(success)
                          {
                            Navigator.pop(context);
                            _showMessage('${event.name} event report will be sent to your email at ${emailController.text} shortly');
                          }
                        else{
                          _showMessage('Failed to send email, Please enter a valid email address');
                        }
                      },
                    )
                  ],
                ),
              ),
            ));
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
        Divider(
          color: Colors.transparent,
          height: 10,
        ),
        // Trivia Button
        //if (event.endDate.isAfter(DateTime.now()))
          ClickableButton(
            text: 'Scan QR Codes',
            onClick: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QrCodeScannerCamera(eventId: event.sId, eventName: event.name,),
                ),
              );
            },
          ),
        ClickableButton(
          text: 'Get Event Report',
          onClick: () async {
            defaultEmail=await defaultEmailFuture;
            _showEmailInputPopUp(defaultEmail);
          },
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

class ClickableButton extends StatelessWidget {
  const ClickableButton({Key key, this.text, this.onClick}) : super(key: key);
  final Function onClick;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: onClick,
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
