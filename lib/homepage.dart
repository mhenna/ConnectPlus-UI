import 'package:carousel_pro/carousel_pro.dart';
import 'package:connect_plus/announcements.dart';
import 'package:connect_plus/models/activity.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/occurrence.dart';
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
  }

  Future<void> _loadData() async {
    await getEvents();
    await getWebinars();
    await getOffers();
    await getAnnouncements();
    await getRecentEventsPosters();
    await getSliderPosters();
    return;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getEvents() async {
    final allEvents = await WebAPI.getEvents();
    if (this.mounted) {
      events = allEvents;
      eventsLoaded = true;
    }
  }

  Future<void> getWebinars() async {
    final allWebinars = await WebAPI.getWebinars();
    if (this.mounted) {
      webinars = allWebinars;
      webinarsLoaded = true;
    }
  }

  Future<void> getOffers() async {
    try {
      final recentOffers = await WebAPI.getRecentOffers();
      if (this.mounted) {
        this.offers = recentOffers;
        offersLoaded = true;
      }
    } catch (e) {}
  }

  Future<void> getRecentEventsPosters() async {
    this.sliderPosters.clear();
    var recent = await WebAPI.getEventHighlights();
    if (this.mounted) {
      recent.forEach((element) {
        element.highlight.forEach((h) {
          sliderPosters.add(CachedNetworkImage(
            placeholder: (context, url) => Expanded(
              child: Container(color: Colors.grey[300]),
            ),
            imageUrl: WebAPI.baseURL + h.url,
          ));
        });
      });
      highlightsLoaded = true;
    }
  }

  // TODO: Move business logic outside of UI
  /// Gets the posters related to ERGs that will be displayed in the
  /// carousel slider.
  ///
  /// Must be called after events, offers, webinars, are loaded
  Future<void> getErgSliderPosters() async {
    List<CachedNetworkImage> posters = [];
    final int ergPosterLimit = 1;

    List<Activity> activities = await WebAPI.getActivities();

    Map<ERG, List<Occurrence>> ergItems = {};

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

    offers.forEach((offer) {
      if (offer.slider) {
        ERG erg = offer.erg;
        if (ergItems.containsKey(erg)) {
          ergItems[erg].add(offer);
        } else {
          ergItems[erg] = [offer];
        }
      }
    });
    activities.forEach((activity) {
      if (activity.slider) {
        ERG erg = activity.erg;
        if (ergItems.containsKey(erg)) {
          ergItems[erg].add(activity);
        } else {
          ergItems[erg] = [activity];
        }
      }
    });

    // Sorts items for each erg
    ergItems.forEach((erg, items) {
      items.sort(
        (item1, item2) => item2.date.compareTo(item1.date),
      );
      ergItems[erg] = items;
    });

    ergItems.forEach((erg, items) {
      for (int i = 0; i < ergPosterLimit; i++) {
        // will break when poster field changes
        posters.add(
          CachedNetworkImage(
            placeholder: (context, url) => Expanded(
              child: Container(color: Colors.grey[300]),
            ),
            imageUrl: WebAPI.baseURL + items[i].poster.url,
          ),
        );
      }
    });
    sliderPosters.addAll(posters);
  }

  void getSliderAnnouncements() {
    num numberOfShownAnnouncements = 2;
    List<Announcement> sortedAnnouncements = announcements;
    sortedAnnouncements.sort((a1, a2) {
      if (a1.deadline == null) return -1;
      if (a2.deadline == null) return 1;
      return a2.deadline.compareTo(a1.deadline);
    });

    List<Announcement> unexpiredAnnouncements = sortedAnnouncements
        .where(
          (announcement) =>
              announcement.slider == true &&
              announcement.erg.name.toLowerCase() ==
                  "internal comms" && //TODO store this somewhere else
              (announcement.deadline == null ||
                  announcement.deadline.isAfter(DateTime.now())),
        )
        .toList();
    unexpiredAnnouncements =
        unexpiredAnnouncements.take(numberOfShownAnnouncements).toList();

    List<CachedNetworkImage> posters = unexpiredAnnouncements
        .map(
          (announcement) => CachedNetworkImage(
            placeholder: (context, url) => Expanded(
              child: Container(color: Colors.grey[300]),
            ),
            imageUrl: WebAPI.baseURL + announcement.poster.url,
          ),
        )
        .toList();

    sliderPosters.addAll(posters);
  }

  Future<void> getSliderPosters() async {
    sliderPosters.clear();
    await getRecentEventsPosters();
    await getErgSliderPosters();
    getSliderAnnouncements();
    sliderPostersLoaded = true;
  }

  Future<void> getAnnouncements() async {
    final allAnnouncements = await WebAPI.getAnnouncements();
    if (this.mounted) {
      announcements = allAnnouncements;
      announcementsLoaded = true;
    }
  }

  Future<void> _refreshData() async {
    await getEvents();
    await getWebinars();
    await getOffers();
    await getSliderPosters();
    setState(() {});
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
    return FutureBuilder<void>(
        future: _loadData(),
        builder: (context, snapshot) {
          if (!highlightsLoaded &&
              !webinarsLoaded &&
              !eventsLoaded &&
              !offersLoaded &&
              !announcementsLoaded) return Scaffold(body: ImageRotate());

          return RefreshIndicator(
              onRefresh: _refreshData,
              child: WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  appBar: AppBar(
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
        });
  }
}
