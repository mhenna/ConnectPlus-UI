import 'package:carousel_pro/carousel_pro.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/offer.dart';
import 'package:connect_plus/models/webinar.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 16.0);

  List<dynamic> recentEvents;
  List<Event> events = [];
  List<Offer> offers = [];
  List<Webinar> webinars = [];
  bool webinarsLoaded = false;
  bool eventsLoaded = false;
  bool offersLoaded = false;
  bool highlightsLoaded = false;

  void initState() {
    recentEvents = [];
    events = [];
    offers = [];
    webinars = [];
    super.initState();
    getEvents();
    getWebinars();
    getOffers();
    getRecentEventsPosters();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getEvents() async {
    final allEvents = await WebAPI.getEvents();
    if (this.mounted) {
      setState(() {
        events = allEvents;
        eventsLoaded = true;
      });
    }
  }

  Future<void> getWebinars() async {
    final allWebinars = await WebAPI.getWebinars();
    if (this.mounted) {
      setState(() {
        webinars = allWebinars;
        webinarsLoaded = true;
      });
    }
  }

  Future<void> getOffers() async {
    try {
      final recentOffers = await WebAPI.getRecentOffers();
      if (this.mounted) {
        recentOffers.sort((a, b) {
          return a.createdAt.compareTo(b.createdAt);
        });
        setState(() {
          this.offers = recentOffers;
          offersLoaded = true;
        });
      }
    } catch (e) {}
  }

  Future<void> getRecentEventsPosters() async {
    var recent = await WebAPI.getEventHighlights();
    if (this.mounted) {
      setState(() {
        recent.forEach((element) {
          element.highlight.forEach((h) {
            recentEvents.add(Image.network(WebAPI.baseURL + h.url));
          });
        });
        highlightsLoaded = true;
      });
    }
  }

  Widget seeMore(String view) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding:
            EdgeInsets.fromLTRB(width * 0.03, height * 0.02, width * 0.03, 0),
        width: width * 0.30,
        height: height * 0.06,
        child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  colors: [
                    Utils.secondaryColor,
                    Utils.primaryColor,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width,
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
                onPressed: () {
                  if (view == 'Events') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Events()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Offers()),
                    );
                  }
                },
                child: Text("View All",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600)),
              ),
            )),
      ),
    );
  }

  Widget title(String title) {
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    return new Padding(
      padding: EdgeInsets.fromLTRB(0, height * 0.07, 0, height * 0.07),
      child: Row(children: <Widget>[
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 45.0, right: 10.0),
              child: Divider(
                color: Colors.black87,
                thickness: 2,
                height: 30,
              )),
        ),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: size * 37,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: new Container(
              margin: const EdgeInsets.only(left: 10.0, right: 45.0),
              child: Divider(
                color: Colors.black87,
                thickness: 2,
                height: 30,
              )),
        ),
      ]),
    );
  }

  List<Widget> getContent() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<Widget> list = [];
    if (webinarsLoaded && eventsLoaded && offersLoaded) {
      if (recentEvents.isNotEmpty) {
        list.add(
          SizedBox(
            height: height * 0.35,
            width: width * 1,
            child: Carousel(
              images: recentEvents,
              boxFit: BoxFit.fill,
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotColor: Colors.grey,
              indicatorBgPadding: 5.0,
              dotBgColor: Colors.grey.withOpacity(0.2),
              overlayShadow: true,
              overlayShadowColors: Colors.white,
              overlayShadowSize: 0.7,
            ),
          ),
        );
      }

      if (events.isNotEmpty || webinars.isNotEmpty) {
        list.add(
          title('Recent Events \n   & Webinars'),
          //gridview
        );
        list.add(Container(
          width: width * 0.97,
          height: height * 0.50,
          child: EventsVariables(events: events, webinars: webinars),
        ));
        list.add(
          seeMore('Events'),
        );
      }
      if (offers.isNotEmpty) {
        list.add(title('Recent Offers'));
        list.add(

            //gridview
            Container(
          width: width * 0.97,
          height: height * 0.50,
          child: OfferVariables(
            offers: offers,
          ),
        ));
        list.add(seeMore('Offers'));
      } else if (offers.isEmpty && events.isEmpty && webinars.isEmpty) {
        list.add(Text('No Recent Data, Coming Soon!'));
      }
      list.add(SizedBox(
        height: 15,
      ));
      return list;
    } else {
      list.add(Center(child: Text("Loading...")));
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    if (highlightsLoaded && webinarsLoaded && eventsLoaded && offersLoaded)
      return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text("Home"),
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
          body: Stack(children: <Widget>[
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: getContent(),
                ),
              ),
            ),
          ]),
        ),
      );
    else {
      return Scaffold(body: ImageRotate());
    }
  }
}
