import 'package:flutter/material.dart';
import 'package:connect_plus/Carousel.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connect_plus/Navbar.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    erg(path) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0x29000000),
              offset: Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(path),
        ),
      );
    }

    ;
    final resWidth = MediaQuery.of(context).size.width;
    final resHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: PreferredSize(
        preferredSize:
            MediaQuery.of(context).size * 0.14, // here the desired height
        child: AppBar(
          backgroundColor: const Color(0xfffafafa),
          flexibleSpace: Container(
            width: resWidth * 1,
            height: resHeight * 0.17,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
              ),
              gradient: LinearGradient(
                begin: Alignment(-1.0, 1.0),
                end: Alignment(1.0, -1.0),
                colors: [const Color(0xfff7501e), const Color(0xffed136e)],
                stops: [0.0, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, resHeight * 0.08, 0, 0),
              child: Text('Home',
                  style: TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 28,
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center),
            ),
          ),
          elevation: 0.0,
        ),
      ),
      drawer: NavDrawer(),
      body: SingleChildScrollView(
         scrollDirection: Axis.vertical, 
       child: Container(
          child: Column(
        children: <Widget>[
          Container(
            width: resWidth * 1,
            child: CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                aspectRatio: 2.0,
                enlargeCenterPage: true,
              ),
              items: imageSliders,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, resWidth * 0.08, 0, 0),
            child: Text('Meet our ERGs',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 28,
                  color: Colors.deepOrange.shade600,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center),
          ),
          const Divider(
            color: Colors.deepOrange,
            height: 20,
            thickness: 3,
            indent: 80,
            endIndent: 80,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(resWidth*0.17, resHeight * 0.07, resWidth*0.17, resHeight * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                erg('assets/WIAlogo.png'),
                erg('assets/Glogo.png')
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(resWidth*0.17, resHeight * 0.04, resWidth*0.17, resHeight * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                erg('assets/Glogo.png'),
                erg('assets/WIAlogo.png'),
              ],
            ),
          ),
        ],
      )),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
