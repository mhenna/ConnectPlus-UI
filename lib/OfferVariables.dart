import 'package:connect_plus/OfferWidget.dart';
import 'package:connect_plus/models/offer.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:flutter/cupertino.dart';
import 'package:connect_plus/widgets/CachedImageBox.dart';

class OfferVariables extends StatefulWidget {
  OfferVariables({Key key, @required this.offers}) : super(key: key);

  final List<Offer> offers;

  @override
  State<StatefulWidget> createState() {
    return new _OfferVariables(this.offers);
  }
}

class _OfferVariables extends State<OfferVariables>
    with TickerProviderStateMixin {
  List<Offer> offers = [];
  bool emptyList = false;
  String mostRecentOfferLogoURL;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  _OfferVariables(this.offers);

  @override
  void initState() {
    super.initState();
    if (offers.isEmpty)
      emptyList = true;
    else
      this.mostRecentOfferLogoURL =  offers.first.logo;
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
    if (emptyList) return Center(child: Text("No Recent Offers, Coming Soon"));
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 6, right: 6),
          child: Container(
            height: height * 0.3,
            child: _mostRecentOfferLogo(),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 6, right: 7, top: 5),
            child: ListView(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: constructOffers(),
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

    final LIST_SIZE = 6;
    for (var i = 0; i < LIST_SIZE && i < offers.length; i++) {
      if (!first) {
        list.add(Padding(
          padding: EdgeInsets.only(right: 10),
          child: SizedBox(
            height: height,
            width: 0.97 * 0.23 * height * 3 / 2,
            child: Single_Offer(offer: offers[i]),
          ),
        ));
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
          tag: offer.id,
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
                        FittedBox(
                          child: Row(
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
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                child: CachedImageBox(
                  imageurl:  offer.logo,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
