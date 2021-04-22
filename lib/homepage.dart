import 'package:carousel_pro/carousel_pro.dart';
import 'package:connect_plus/announcements.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/offer.dart';
import 'package:connect_plus/models/webinar.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/Events.dart';
import 'package:connect_plus/OfferVariables.dart';
import 'package:connect_plus/Offers.dart';
import 'package:connect_plus/models/erg.dart';
import 'EventsVariable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_plus/models/announcement.dart';
import 'AnnouncementVariables.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Roboto', fontSize: 16.0);

  List<CachedNetworkImage> sliderPosters = [];
  List<Event> events = [];
  List<Offer> offers = [];
  List<Webinar> webinars = [];
  bool webinarsLoaded = false;
  bool eventsLoaded = false;
  bool offersLoaded = false;
  bool highlightsLoaded = false;
  bool sliderPostersLoaded = false;
  bool announcementsLoaded = false;
  List<Announcement> announcements = [];

  void initState() {
    events = [];
    offers = [];
    webinars = [];
    super.initState();
    getEvents();
    getWebinars();
    getOffers();
    getRecentEventsPosters();
    getAnnouncements();
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
        setState(() {
          this.offers = recentOffers;
          offersLoaded = true;
        });
      }
    } catch (e) {}
  }

  Future<void> getRecentEventsPosters() async {
    this.sliderPosters.clear();
    var recent = await WebAPI.getEventHighlights();
    if (this.mounted) {
      setState(() {
        recent.forEach((element) {
          element.highlight.forEach((h) {
            sliderPosters.add(CachedNetworkImage(
              placeholder: (context, url) => SizedBox(
                height: 40,
                child: CircularProgressIndicator(),
              ),
              imageUrl: WebAPI.baseURL + h.url,
            ));
          });
        });
        highlightsLoaded = true;
      });
    }
  }

  // TODO: Move business logic outside of UI
  Future<void> getErgSliderPosters() async {
    List<CachedNetworkImage> posters = [];
    final int ergPosterLimit = 1;

    List<Event> events = await WebAPI.getSliderEvents();
    List<Webinar> webinars = await WebAPI.getSliderWebinars();

    // TODO: create a superclass for webinars and events
    Map<ERG, List<dynamic>> ergItems = {};

    // add events to erg owner
    events.forEach((event) {
      if (event.slider) {
        ERG erg = event.erg;
        if (ergItems.containsKey(erg)) {
          ergItems[erg].add(event);
        } else {
          ergItems[erg] = [event];
        }
      }
    });

    // add webinars to erg owner
    webinars.forEach((webinar) {
      if (webinar.slider) {
        ERG erg = webinar.erg;
        if (ergItems.containsKey(erg)) {
          ergItems[erg].add(webinar);
        } else {
          ergItems[erg] = [webinar];
        }
      }
    });

    // Sorts items for each erg
    // superclass for webinar and events will make for much safer and cleaner code
    // The following will break if webinar/event class changes createdAt field name
    ergItems.forEach((erg, items) {
      items.sort(
        (item1, item2) => item2.createdAt.compareTo(item1.createdAt),
      );
      ergItems[erg] = items;
    });

    ergItems.forEach((erg, items) {
      for (int i = 0; i < ergPosterLimit; i++) {
        // will break when poster field changes
        posters.add(
          CachedNetworkImage(
            placeholder: (context, url) => CircularProgressIndicator(),
            imageUrl: WebAPI.baseURL + items[i].poster.ur,
          ),
        );
      }
    });
    setState(() {
      sliderPosters.addAll(posters);
    });
  }

  Future<void> getSliderPosters() async {
    sliderPosters.clear();
    await getRecentEventsPosters();
    await getErgSliderPosters();
    sliderPostersLoaded = true;
  }

  Future<void> getAnnouncements() async {
    final allAnnouncements = await WebAPI.getAnnouncements();
    if (this.mounted) {
      setState(() {
        announcements = allAnnouncements;
        announcementsLoaded = true;
      });
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      // eventsLoaded = false;
      // webinarsLoaded = false;
      // offersLoaded = false;
      // highlightsLoaded = false;
      getEvents();
      getWebinars();
      getOffers();
      getSliderPosters();
    });
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
                  } else if (view == 'Offers') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Offers()),
                    );
                  } else if (view == 'Announcements') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Announcements(),
                      ),
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
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(15, height * 0.07, 0, 10),
          child: Text(
            title,
            style: TextStyle(
              fontSize: size * 48,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        )
      ],
    );
  }

  List<Widget> getContent() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    List<Widget> list = [];
    if (webinarsLoaded && eventsLoaded && offersLoaded && announcementsLoaded) {
      if (sliderPosters.isNotEmpty) {
        list.add(
          SizedBox(
            height: height * 0.308,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Utils.background),
              child: Carousel(
                images: sliderPosters,
                autoplayDuration: const Duration(seconds: 20),
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
          ),
        );
      }

      if (events.isNotEmpty || webinars.isNotEmpty) {
        list.add(
          title('Recent Events & Webinars'),
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
      if (announcements.isNotEmpty) {
        list.add(
          title('Recent Announcements'),
          //gridview
        );
        list.add(Container(
            width: width * 0.97,
            height: height * 0.50,
            child: AnnouncementVariables(
              announcements: announcements,
            )));
        list.add(
          seeMore('Announcements'),
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
      } else if (offers.isEmpty &&
          events.isEmpty &&
          webinars.isEmpty &&
          announcements.isEmpty) {
        list.add(Text('No Recent Data, Coming Soon!'));
      }
      list.add(SizedBox(
        height: 35,
      ));
      list.add(Divider(
        height: 20,
      ));
      list.add(Center(
          child: Text(
        "Copyright © 2020. Cairo Automation Team - The Co-partner \n project . All rights reserved.",
        textAlign: TextAlign.center,
      )));
      list.add(SizedBox(
        height: 40,
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
    if (highlightsLoaded &&
        webinarsLoaded &&
        eventsLoaded &&
        offersLoaded &&
        announcementsLoaded)
      return RefreshIndicator(
          onRefresh: _refreshData,
          child: WillPopScope(
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
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: getContent(),
                    ),
                  ),
                ),
              ]),
            ),
          ));
    else {
      return Scaffold(body: ImageRotate());
    }
  }
}
