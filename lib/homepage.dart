import 'package:flutter/cupertino.dart';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:connect_plus/Carousel.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/Events.dart';
import 'package:connect_plus/OfferVariables.dart';
import 'package:connect_plus/Offers.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'EventsVariable.dart';

final List<String> imgList = [
  'https://mainvibes.com/wp-content/uploads/2020/05/Party.jpeg',
  'https://identity-mag.com/wp-content/uploads/2020/01/My-Post-19.jpg',
  'https://img.freepik.com/free-photo/senior-businesswoman-young-business-people-work-modern-office_52137-28330.jpg?size=626&ext=jpg',
  'https://www.potential.com/wp-content/uploads/2018/01/teamwork-.jpg',
  'https://www.csregypt.com/wp-content/uploads/2019/07/Feature-Image-1.jpg',
  'https://corporate.delltechnologies.com/is/image/content/dam/delltechnologies/assets/home/images/photos/MichaelDell.jpg?fit=constrain&wid=640'
];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
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
            body: Stack(children: <Widget>[
              new Container(
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("assets/meetERGs.png"),
                        fit: BoxFit.fill)),
              ),
              SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Column(
                        children: <Widget>[
                          CarouselSlider(
                            options: CarouselOptions(
                              viewportFraction: 1.0,
                              autoPlay: true,
                              aspectRatio: 2.0,
                              enlargeCenterPage: false,
                            ),
                            items: imageSliders,
                          ),
                          new Padding(
                            padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                            child: new Text(
                              'Recent Events',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  foreground: Paint()
                                    ..shader = ui.Gradient.linear(
                                      const Offset(0, 20),
                                      const Offset(150, 20),
                                      <Color>[
                                        Colors.red,
                                        Colors.black,
                                      ],
                                    )),
                            ),
                          ),
                          //gridview
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            height: 400,
                            child: EventsVariables(),
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                width: 130,
                                height: 55,
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Color(0xFFE15F5F),
                                      child: MaterialButton(
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.fromLTRB(
                                            20.0, 0.0, 20.0, 0.0),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Events()),
                                          );
                                        },
                                        child: Text("See More",
                                            textAlign: TextAlign.center,
                                            style: style.copyWith(
                                                color: Colors.white)),
                                      ),
                                    )),
                              )),
                          new Padding(
                            padding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                            child: new Text(
                              'Recent Offers',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  foreground: Paint()
                                    ..shader = ui.Gradient.linear(
                                      const Offset(0, 20),
                                      const Offset(150, 20),
                                      <Color>[
                                        Colors.red,
                                        Colors.black,
                                      ],
                                    )),
                            ),
                          ),
                          //gridview
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            height: 400,
                            child: OfferVariables(),
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                                width: 130,
                                height: 55,
                                child: Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Color(0xFFE15F5F),
                                      child: MaterialButton(
                                        minWidth:
                                            MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.fromLTRB(
                                            20.0, 0.0, 20.0, 0.0),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Offers()),
                                          );
                                        },
                                        child: Text("See More",
                                            textAlign: TextAlign.center,
                                            style: style.copyWith(
                                                color: Colors.white)),
                                      ),
                                    )),
                              )),
                        ],
                      ))),

// This trailing comma makes auto-formatting nicer for build methods.
            ])));
  }
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Text(
                          'No. ${imgList.indexOf(item)} image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();
