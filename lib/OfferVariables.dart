import 'package:connect_plus/OfferWidget.dart';
import 'package:connect_plus/models/offer.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/cupertino.dart';

class OfferVariables extends StatefulWidget {
  @override
  _OfferVariables createState() => _OfferVariables();
}

class _OfferVariables extends State<OfferVariables> {
  List<Offer> offers = [];
  bool emptyList = false;
  String mostRecentOfferLogoURL;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  @override
  void initState() {
    super.initState();
    getOffers();
  }

  void getOffers() async {
    try {
      final recentOffers = await WebAPI.getRecentOffers();
      recentOffers.sort((a, b) {
        return a.createdAt.compareTo(b.createdAt);
      });
      setState(() {
        this.offers = recentOffers;
        if (offers.isEmpty)
          emptyList = true;
        else
          this.mostRecentOfferLogoURL =
              WebAPI.baseURL + recentOffers.first.logo.url;
      });
    } catch (e) {}
  }

  Widget _mostRecentOfferLogo() {
    if (mostRecentOfferLogoURL == null)
      return Scaffold(
        body: ImageRotate(),
      );
    return Single_Offer(offer: offers.first);
  }

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    var height = MediaQuery.of(context).size.height;
    if (emptyList) return Center(child: Text("No Offers"));
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 6, right: 6),
          child: Container(
            height: height * 0.28,
            child: _mostRecentOfferLogo(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 6, right: 6),
            child: Scrollbar(
              controller: _scrollController,
              isAlwaysShown: true,
              child: ListView(
                controller: _scrollController,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: constructOffers(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> constructOffers() {
    List<Widget> list = List<Widget>();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    bool first = true;

    for (var offer in offers) {
      if (!first) {
        list.add(
          SizedBox(
            height: height,
            width: width * 0.70,
            child: Single_Offer(offer: offer),
          ),
        );
      }
      first = false;
    }
    return list;
  }
}

class Single_Offer extends StatelessWidget {
  final Offer offer;

  //constructor
  Single_Offer({this.offer});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height,
      child: Card(
        child: Hero(
          tag: offer.name,
          child: Material(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OfferWidget(
                      category: offer.category,
                      offer: offer,
                    ),
                  ),
                );
              },
              child: GridTile(
                  footer: Container(
                    color: Colors.white70,
                    child: ListTile(
                      title: Column(
                        children: <Widget>[
                          Text(
                            offer.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Expires: "),
                              Text(
                                DateFormat.yMMMMd('en_US')
                                    .format(offer.expiration),
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w800),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  child: Image.network(
                    WebAPI.baseURL + offer.logo.url,
                    fit: BoxFit.contain,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
