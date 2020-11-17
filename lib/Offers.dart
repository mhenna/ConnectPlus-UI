import 'package:connect_plus/models/offer.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'dart:math';
import 'package:localstorage/localstorage.dart';
import 'package:connect_plus/OfferWidget.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:connect_plus/utils/map_indexed.dart';

class Offers extends StatefulWidget {
  Offers({Key key, this.offerCategory}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  static final _random = new Random();
  final String offerCategory;

  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  List<Offer> offers = [];
  Map<OfferCategory, List<Offer>> categoriesAndOffers =
      new Map<OfferCategory, List<Offer>>();
  var randIndexCat;
  var randIndexOffer;
  List<Offer> searchData = [];
  final LocalStorage localStorage = new LocalStorage("Connect+");

  void initState() {
    super.initState();
    getOffers();
  }

  Future getOffers() async {
    final allOffers = await WebAPI.getOffers();

    setState(() {
      this.offers = allOffers;
      allOffers.forEach((offer) {
        print(categoriesAndOffers[offer.category].toString() +
            offer.category.toString());
        if (categoriesAndOffers[offer.category] != null) {
          categoriesAndOffers[offer.category].add(offer);
        } else
          categoriesAndOffers[offer.category] = [offer];
      });
      randIndexCat = Offers._random.nextInt(categoriesAndOffers.length);
      randIndexOffer = Offers._random.nextInt(allOffers.length);
    });
    getSearchData();

    // print(categoriesAndOffers.keys);
    // print(categoriesAndOffers.values);
  }

  getSearchData() {
    searchData = this.offers;
  }

  Widget urlToImage(String imageURL) {
    return Expanded(
      child: SizedBox(
        width: 250, // otherwise the logo will be tiny
        child: Image.network(imageURL),
      ),
    );
  }

  Widget LoadingWidget() {
    return Scaffold(
        body: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          new CircularProgressIndicator(),
          new Text("Loading"),
        ],
      ),
    ));
  }

  Widget base64ToImageFeatured() {
    try {
      final url = WebAPI.baseURL + offers[randIndexOffer].logo.url;
      return FittedBox(
        fit: BoxFit.contain,
        child: Image.network(url),
      );
    } catch (Exception) {
      print(Exception);
      return Center(child: Text("No Offers"));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    if (this.offers.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            // Here we take the value from the MyHomePage object that was created by
            // the App.build method, and use it to set our appbar title.
            title: Text("Offers"),
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
          body: Center(child: Text("No Offers")));
    }
    try {
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text("Offers"),
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
        body: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(10),
          itemCount: 3,
          itemBuilder: (BuildContext context, int elem) {
            if (elem == 0) {
              return Column(children: <Widget>[
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: "Search")),
                  suggestionsCallback: (pattern) async {
                    return getSuggestions(pattern);
                  },
                  itemBuilder: (context, Offer suggestedOffer) {
                    return ListTile(
                      leading: Icon(Icons.shopping_cart),
                      title: Text(suggestedOffer.name),
                    );
                  },
                  onSuggestionSelected: (suggestion) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OfferWidget(
                          offer: suggestion,
                          category: suggestion.category,
                        ),
                      ),
                    );
                  },
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, height * 0.01, 0, 0),
                      child: base64ToImageFeatured(),
                    ))
              ]);
            } else if (elem == 1) {
              return Column(children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(0, height * 0.08, 0, 8.0),
                  child: Text(
                    "OFFERS",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: size * 50,
                        fontWeight: FontWeight.w600,
                        color: Utils.header),
                  ),
                ),
                Divider(
                  color: Utils.header,
                  thickness: 3,
                  indent: width * 0.27,
                  endIndent: width * 0.27,
                )
              ]);
            } else {
              return ListView(
                children: mapIndexed<Widget, OfferCategory>(
                  categoriesAndOffers.keys,
                  (index, category) {
                    return Column(
                      children: <Widget>[
                        if (categoriesAndOffers[category].isNotEmpty)
                          Padding(
                              padding: EdgeInsets.fromLTRB(width * 0.03,
                                  height * 0.03, width * 0.03, height * 0.06),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  child: Text(
                                    category.toString(),
                                    style: TextStyle(
                                        fontSize: size * 45,
                                        fontWeight: FontWeight.w600,
                                        color: Utils.header),
                                  ),
                                ),
                              )),
                        GridView.count(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          // Create a grid with 2 columns. If you change the scrollDirection to
                          // horizontal, this produces 2 rows.
                          crossAxisCount: 2,
                          addAutomaticKeepAlives: true,
                          children: categoriesAndOffers[category].map((offer) {
                            return Center(
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    urlToImage(WebAPI.baseURL + offer.logo.url),
                                    ButtonBar(
                                      alignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            offer.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: size * 35,
                                                color: Utils.header),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OfferWidget(
                                                  category: category,
                                                  offer: offer,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    );
                  },
                ).toList(),
                shrinkWrap: true,
                physics: ScrollPhysics(),
              );
            }
          },
        ),
      );
    } catch (Exception) {
      print(Exception);
      return LoadingWidget();
    }
  }

  List<Offer> getSuggestions(String pattern) {
    if (pattern == "") return null;
    final filter = searchData
        .where(
          (entry) => entry.name.toLowerCase().startsWith(pattern.toLowerCase()),
        )
        .toList();
    return filter;
  }
}
