import 'dart:io';

import 'package:connect_plus/Navbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'Navbar.dart';
import 'widgets/Utils.dart';
import 'widgets/Indicator.dart';

class Offer extends StatefulWidget {
  Offer({Key key, @required this.offer, @required this.category})
      : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String category;
  final offer;

  @override
  _OfferState createState() => _OfferState();
}

class _OfferState extends State<Offer> with TickerProviderStateMixin {
  var ip;
  var port;
  var relatedOffers = [];
  final LocalStorage localStorage = new LocalStorage("Connect+");

  bool loading = true;

  AnimationController controller;
  Animation<double> animation;
  _OfferState();

  void initState() {
    super.initState();
    setEnv();
    getOffers();
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

  Future getOffers() async {
    String name = widget.category;
    String token = localStorage.getItem("token");
    var url = 'http://' + ip + ':' + port + '/offers/getByCategory/$name';

    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200)
      setState(() {
        relatedOffers = json.decode(response.body);
        loading = false;
      });
  }

  Widget base64ToImage(String base64) {
    Uint8List bytes = base64Decode(base64);
    return Expanded(
      child: SizedBox(
        width: 220, // otherwise the logo will be tiny
        child: Image.memory(bytes),
      ),
    );
  }

  base64ToPDF(String base64) async {
    Uint8List bytes = base64Decode(base64);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File f = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    await f.writeAsBytes(bytes);
    return f.path;
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
    ));
  }

  List<Widget> constructRelatedOffers() {
    List<Widget> list = List<Widget>();
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size.aspectRatio;

    relatedOffers.sort(
        (b, a) => a['offer']['createdAt'].compareTo(b['offer']['createdAt']));

    for (var offer in relatedOffers) {
      if (offer['offer']['_id'] != widget.offer['_id'].toString()) {
        list.add(Container(
          padding: EdgeInsets.fromLTRB(width * 0.01, 0.0, width * 0.01, 0.0),
          width: width * 0.48,
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                base64ToImage(offer['logo']['fileData'].toString()),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        offer['offer']['logo'] = offer['logo'];
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Offer(
                                category: widget.category,
                                offer: offer['offer'],
                              ),
                            ));
                      },
                      child: Text(
                        offer['offer']['name'].toString(),
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: size * 30, color: Utils.header),
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
                      widget.offer['name'],
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

  Widget _offerPoster() {
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
                  base64Decode(widget.offer['logo']['fileData'].toString())),
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
                        Text(
                          "${widget.offer['discount']} OFF",
                          style: TextStyle(
                              fontSize: size * 45,
                              color: Utils.headline,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _description(),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    child: Text(
                      "More Details",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16.0,
                      ),
                    ),
                    onTap: () async {
                      String pathPDF = await base64ToPDF(
                          widget.offer['attachment']['fileData'].toString());
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PDFScreen(pathPDF)),
                      );
                      // PDFViewer(document: file, indicatorBackground: Colors.red);
                    },
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, height * 0.08, 0, height * 0.02),
                      child: Utils.titleText(
                          textString: " Related Offers",
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
                                children: constructRelatedOffers(),
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
      child: Utils.titleText(
        textString: text,
        fontSize: 16,
        textcolor: Colors.black,
      ),
    );
  }

  Widget _description() {
    var size = MediaQuery.of(context).size.aspectRatio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          widget.offer['details'],
          style: TextStyle(
            color: Utils.header,
            fontSize: size * 27,
          ),
        ),
        Text(
          "\n\nLocation: " +
              widget.offer['location'].toString() +
              "\n\nContact: " +
              widget.offer['contact'].toString() +
              "\n\nExpiration: " +
              widget.offer['expiration'].toString().substring(0,10) +
              "\n",
          style: TextStyle(
            color: Colors.black87,
            fontSize: size * 26,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
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
                    child: _offerPoster(),
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

class PDFScreen extends StatelessWidget {
  String pathPDF = "";
  PDFScreen(this.pathPDF);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Details"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: pathPDF);
  }
}
