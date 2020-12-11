import 'package:carousel_pro/carousel_pro.dart';
import 'package:connect_plus/models/category.dart';
import 'package:connect_plus/models/offer.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:filter_list/filter_list.dart';
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
  List<Category> categories = [];
  bool emptyCategories = true;
  Map<String, List<Offer>> categoriesAndOffers = new Map<String, List<Offer>>();
  List<Offer> searchData = [];
  final LocalStorage localStorage = new LocalStorage("Connect+");
  List<String> selectedCountList = [
    "Lifestyle",
    "Cars",
    "Family",
    "Food",
    "Travel"
  ];
  List<String> categoriesList = [
    "Lifestyle",
    "Cars",
    "Family",
    "Food",
    "Travel"
  ];
  List<dynamic> _filteredData;
  List<dynamic> recentOffers;

  var randIndexCat;
  var randIndexOffer;

  void initState() {
    _filteredData = [];
    recentOffers = [];
    selectedCountList = [];
    super.initState();
    getRecentOffersPosters();
    getOffers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getRecentOffersPosters() async {
    var recent = await WebAPI.getOfferHighlights();
    if (this.mounted) {
      setState(() {
        recent.forEach((element) {
          element.highlight.forEach((h) {
            recentOffers.add(Image.network(WebAPI.baseURL + h.url));
          });
        });
      });
    }
  }

  Future getCategories() async {
    final allCat = await WebAPI.getCategories();
    if (this.mounted) {
      setState(() {
        this.categories = allCat;
        if (categories.length != 0) {
          emptyCategories = false;
        }
      });
    }
  }

  Future getOffers() async {
    final allOffers = await WebAPI.getOffers();
    if (this.mounted)
      setState(() {
        this.offers = allOffers;
        allOffers.forEach((offer) {
          if (offer.category !=
              null) if (categoriesAndOffers[offer.category.name] == null) {
            categoriesAndOffers[offer.category.name] = [offer];
          } else
            categoriesAndOffers[offer.category.name].add(offer);
        });
        randIndexCat = Offers._random.nextInt(categoriesAndOffers.length);
        randIndexOffer = Offers._random.nextInt(allOffers.length);
      });
    _filteredData.addAll(offers);
    getSearchData();
  }

  getSearchData() {
    searchData = this.offers;
  }

  Widget urlToImage(String imageURL) {
    return Expanded(
      child: SizedBox(
        width: 250, // otherwise the logo will be tiny
        child: FittedBox(fit: BoxFit.cover, child: Image.network(imageURL)),
      ),
    );
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
      return ImageRotate();
    }
  }

  void filterData() async {
    _filteredData = [];
    for (final data in offers) {
      if (selectedCountList.indexOf(data.category.toString()) != -1) {
        _filteredData.add(data);
      }
    }
    setState(() {});
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
          body: Container(child: ImageRotate()));
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
                Container(
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Utils.header,
                            blurRadius: 5.0,
                            offset: Offset(0.30, 0.10))
                      ],
                    ),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              suffixIcon: Icon(Icons.search),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Utils.header),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Utils.header),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              hintText: "Search for offers")),
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
                    )),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: height * 0.35,
                  width: width,
                  child: Carousel(
                    images: recentOffers,
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
              ]);
            } else if (elem == 1) {
              return Column(children: [
                Padding(padding: EdgeInsets.fromLTRB(0, height * 0.03, 0, 0.0))
              ]);
            } else {
              return ListView(
                children: mapIndexed<Widget, String>(
                  categoriesAndOffers.keys,
                  (index, category) {
                    return Column(
                      children: <Widget>[
                        if (categoriesAndOffers[category].isNotEmpty)
                          if (index == 0)
                            Padding(
                                padding: EdgeInsets.fromLTRB(width * 0.03,
                                    height * 0.03, width * 0.03, height * 0.03),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: Text(
                                      category.toString().toUpperCase(),
                                      style: TextStyle(
                                          fontSize: size * 45,
                                          fontWeight: FontWeight.w600,
                                          color: Utils.header),
                                    ),
                                  ),
                                ))
                          else
                            Padding(
                                padding: EdgeInsets.fromLTRB(width * 0.03,
                                    height * 0.03, width * 0.03, height * 0.03),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    child: Text(
                                      category.toString().toUpperCase(),
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
                                                fontSize: size * 30,
                                                color: Colors.black87),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OfferWidget(
                                                  category: offer.category,
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
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Divider(
                          color: Utils.header,
                          thickness: 2,
                          indent: width * 0.27,
                          endIndent: width * 0.27,
                        ),
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
      return Scaffold(
        body: ImageRotate(),
      );
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
