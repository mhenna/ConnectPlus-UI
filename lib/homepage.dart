import 'package:carousel_pro/carousel_pro.dart';
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
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
              title: Text("Home"),
              centerTitle: true,
              backgroundColor: Colors.header,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.secondaryColor,
                      Colors.primaryColor,
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
              ),
            ),
            drawer: NavDrawer(),
            backgroundColor: Colors.background,
            body: Stack(children: <Widget>[
              SingleChildScrollView(
                  child: Container(
                      child: Column(
                children: <Widget>[
                  SizedBox(
                      height: height * 0.42,
                      width: width,
                      child: Carousel(
                        images: [
                          Image.asset('./assets/logo2.png'),
                          Image.asset('./assets/logo.png'),
                        ],
                        dotSize: 4.0,
                        dotSpacing: 15.0,
                        dotColor: Colors.header,
                        indicatorBgPadding: 5.0,
                        dotBgColor: Colors.header.withOpacity(0.1),
                        overlayShadow: true,
                        overlayShadowColors: Colors.white,
                        overlayShadowSize: 0.7,
                      )),
                  new Padding(
                    padding: EdgeInsets.fromLTRB(width * 0.03, height * 0.07,
                        width * 0.03, height * 0.01),
                    child: new Text(
                      'Recent Events',
                      style: TextStyle(
                        fontSize: size * 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.headline,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.headline,
                    thickness: 3,
                    indent: width * 0.25,
                    endIndent: width * 0.25,
                  ),
                  //gridview
                  Container(
                    padding: EdgeInsets.fromLTRB(0, height * 0.03, 0, 0),
                    height: height * 0.55,
                    child: EventsVariables(),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.03, height * 0.02, width * 0.03, 0),
                        width: width * 0.4,
                        height: height * 0.12,
                        child: Padding(
                            padding: EdgeInsets.only(bottom: height * 0.04),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.secondaryColor,
                                    Colors.primaryColor,
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                ),
                              ),
                              child: MaterialButton(
                                minWidth: MediaQuery.of(context).size.width,
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Events()),
                                  );
                                },
                                child: Text("See More",
                                    textAlign: TextAlign.center,
                                    style: style.copyWith(color: Colors.white)),
                              ),
                            )),
                      )),
                  new Padding(
                    padding: EdgeInsets.fromLTRB(width * 0.03, height * 0.09,
                        width * 0.03, height * 0.01),
                    child: new Text(
                      'Recent Offers',
                      style: TextStyle(
                        fontSize: size * 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.headline,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.headline,
                    thickness: 3,
                    indent: width * 0.25,
                    endIndent: width * 0.25,
                  ),

                  //gridview
                  Container(
                    padding: EdgeInsets.fromLTRB(0, height * 0.03, 0, 0),
                    height: height * 0.55,
                    child: OfferVariables(),
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(
                            width * 0.03, height * 0.02, width * 0.03, 0),
                        width: width * 0.4,
                        height: height * 0.12,
                        child: Padding(
                            padding: EdgeInsets.only(bottom: height * 0.04),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.secondaryColor,
                                    Colors.primaryColor,
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                ),
                              ),
                              child: MaterialButton(
                                minWidth: MediaQuery.of(context).size.width,
                                padding:
                                    EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Offers()),
                                  );
                                },
                                child: Text("See More",
                                    textAlign: TextAlign.center,
                                    style: style.copyWith(color: Colors.white)),
                              ),
                            )),
                      )),
                ],
              ))),

// This trailing comma makes auto-formatting nicer for build methods.
            ])));
  }
}

// final Iterable<Image> imageSliders = imgList.map(
//   (item) => Image.network(item),
// );

// final List<Widget> imageSliders = imgList
//     .map((item) => Container(
//           child: Container(
//             margin: EdgeInsets.all(5.0),
//             child: ClipRRect(
//                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                 child: Stack(
//                   children: <Widget>[
//                     Image.network(item, fit: BoxFit.cover, width: 1000.0),
//                     Positioned(
//                       bottom: 0.0,
//                       left: 0.0,
//                       right: 0.0,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           gradient: LinearGradient(
//                             colors: [
//                               Color.fromARGB(200, 0, 0, 0),
//                               Color.fromARGB(0, 0, 0, 0)
//                             ],
//                             begin: Alignment.bottomCenter,
//                             end: Alignment.topCenter,
//                           ),
//                         ),
//                         padding: EdgeInsets.symmetric(
//                             vertical: 10.0, horizontal: 20.0),
//                         child: Text(
//                           'No. ${imgList.indexOf(item)} image',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )),
//           ),
//         ))
//     .toList();
