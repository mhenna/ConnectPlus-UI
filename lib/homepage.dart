import 'package:flutter/cupertino.dart';
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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
//        title: Text(widget.title),
        flexibleSpace: Image(
          image: AssetImage('assets/background.png'),
          fit: BoxFit.cover,
        ),
        backgroundColor: Colors.transparent,
      ),

      drawer: NavDrawer(),
      body: Container(

          //background image
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/meetERGs.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Column(
                children: <Widget>[
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                    ),
                    items: imageSliders,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(80.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/WIAlogo.png'),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/Glogo.png'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/WIAlogo.png'),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset('assets/Glogo.png'),
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
