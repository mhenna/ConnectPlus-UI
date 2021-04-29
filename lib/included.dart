import 'package:carousel_pro/carousel_pro.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/widgets/CachedImageBox.dart';

class Included extends StatefulWidget {
  Included({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _IncludedState createState() => _IncludedState();
}

class _IncludedState extends State<Included> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 16.0);
  List<ERG> ergsList;
  int index = 0;

  void initState() {
    ergsList = [];
    super.initState();
    getERGS();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getERGS() async {
    final ergs = await WebAPI.getERGS();
    if (this.mounted) {
      setState(() {
        ergsList = ergs;
      });
    }
  }

  void nextERG() {
    if (index < ergsList.length - 1)
      setState(() {
        index++;
      });
  }

  void previousERG() {
    if (index > 0)
      setState(() {
        index--;
      });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    if (ergsList.isNotEmpty)
      return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text("Who is Included?"),
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
          drawer: NavDrawer(),
          backgroundColor: Utils.background,
          body: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _icon(
                Icons.arrow_back_ios,
                color: Utils.header,
                size: size * 25,
                padding: size * 0.01,
                isOutLine: true,
                onPressed: () {
                  previousERG();
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: CachedImageBox(
                        imageurl: WebAPI.baseURL + ergsList[index].poster.url,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(ergsList[index].name.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Utils.header,
                          fontSize: size * 35,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                      child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(ergsList[index].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: size * 25,
                        )),
                  )),
                ],
              ),
              _icon(
                Icons.arrow_forward_ios,
                color: Utils.header,
                size: size * 25,
                padding: size * 0.03,
                isOutLine: true,
                onPressed: () {
                  nextERG();
                },
              ),
            ],
          )),
        ),
      );
    else {
      return Scaffold(
        body: ImageRotate(),
      );
    }
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
}
