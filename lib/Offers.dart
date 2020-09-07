import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:connect_plus/Offer.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
  var ip;
  var port;
  var offers = [];
  var categoriesAndOffers = [];
  var randIndexCat;
  var randIndexOffer;
  var searchData = [];
  final LocalStorage localStorage = new LocalStorage("Connect+");

  void initState() {
    super.initState();
    setEnv();
    getOffers();
  }

  setEnv() {
    port = DotEnv().env['PORT'];
    ip = DotEnv().env['SERVER_IP'];
  }

  Future getOffers() async {
    String name = widget.offerCategory;
    String token = localStorage.getItem("token");
    var url = 'http://' + ip + ':' + port + '/offers';

    var response = await http.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200)
      setState(() {
        categoriesAndOffers = json.decode(response.body);
        randIndexCat = Offers._random.nextInt(categoriesAndOffers.length);
        randIndexOffer = Offers._random.nextInt(
            categoriesAndOffers.elementAt(randIndexCat)['offers'].length);
      });
    getSearchData();
  }

  getSearchData() {
    categoriesAndOffers.forEach((category) {
      category['offers'].forEach((offer) {
        offer['category'] = category['name'];
        searchData.add(offer);
      });
    });
  }

  Widget base64ToImage(String base64) {
    Uint8List bytes = base64Decode(base64);
    return Expanded(
      child: SizedBox(
        width: 250, // otherwise the logo will be tiny
        child: Image.memory(bytes),
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
      Uint8List bytes = base64Decode(categoriesAndOffers
          .elementAt(randIndexCat)['offers']
          .elementAt(randIndexOffer)['logo']['fileData']);
      return FittedBox(
        fit: BoxFit.contain,
        child: Image.memory(bytes),
      );
    } catch (Exception) {
      return LoadingWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return AppScaffold(
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
                              border: OutlineInputBorder(),
                              hintText: "Search")),
                      suggestionsCallback: (pattern) async {
                        return await getSuggestions(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          leading: Icon(Icons.shopping_cart),
                          title: Text(suggestion['name']),
//                subtitle: Text(suggestion['category']),
                        );
                      },
                      onSuggestionSelected: (suggestion) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Offer(
                                      offer: suggestion,
                                      category: suggestion['category'],
                                    )));
                      },
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      child: base64ToImageFeatured(),
                    )
                  ]);
                } else if (elem == 1) {
                  return Padding(
                      padding: EdgeInsets.fromLTRB(0, 64.0, 0, 8.0),
                      child: Text(
                        "OFFERS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 32,
                        ),
                      ));
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: categoriesAndOffers.length,
                      itemBuilder: (BuildContext catContext, int cat) {
                        return Column(
                          children: <Widget>[
                            if (cat == 0)
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 12.0, 0, 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Text(
                                        categoriesAndOffers
                                            .elementAt(cat)['name'],
                                        style: TextStyle(fontSize: 28),
                                      ),
                                    ),
                                  ))
                            else
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 55.0, 0, 8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Text(
                                        categoriesAndOffers
                                            .elementAt(cat)['name'],
                                        style: TextStyle(fontSize: 28),
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
                              // Generate 100 widgets that display their index in the List.
                              children: List.generate(
                                  categoriesAndOffers
                                      .elementAt(cat)['offers']
                                      .length, (index) {
                                return Center(
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        base64ToImage(categoriesAndOffers
                                            .elementAt(cat)['offers']
                                            .elementAt(index)['logo']
                                                ['fileData']
                                            .toString()),
                                        ButtonBar(
                                          alignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                categoriesAndOffers
                                                    .elementAt(cat)['offers']
                                                    .elementAt(index)['name']
                                                    .toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 22),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (context) => Offer(
                                                                category: categoriesAndOffers
                                                                        .elementAt(
                                                                            cat)[
                                                                    'name'],
                                                                offer: categoriesAndOffers
                                                                    .elementAt(cat)[
                                                                        'offers']
                                                                    .elementAt(
                                                                        index),
                                                              )),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            )
                          ],
                        );
                      });
                }
              }));
    } catch (Exception) {
      return LoadingWidget();
    }
  }

  getSuggestions(pattern) {
    if (pattern == "") return null;
    var filter = List.from(searchData.where((entry) =>
        entry["name"].toLowerCase().startsWith(pattern.toLowerCase()) as bool));
    return filter;
  }
}
