import 'package:connect_plus/widgets/Utils.dart';
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
  var emptyOffers = false;
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

    print(response.statusCode);
    if (response.statusCode == 200) {
      if (!(json.decode(response.body)).isEmpty) {
        setState(() {
          categoriesAndOffers = json.decode(response.body);
          randIndexCat = Offers._random.nextInt(categoriesAndOffers.length);
          randIndexOffer = Offers._random.nextInt(
              categoriesAndOffers.elementAt(randIndexCat)['offers'].length);
        });
      } else
        setState(() {
          emptyOffers = false;
        });
      getSearchData();
    }
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
      print(Exception);
      return Center(child: Text("No Offers"));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
     if (emptyOffers) {
        return AppScaffold(body: Center(child: Text("No Offers")));
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
                        child: Padding(
                          padding:
                              EdgeInsets.fromLTRB(0, height * 0.01, 0, 0),
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
                              fontSize: size * 60,
                              fontWeight: FontWeight.w600,
                              color: Utils.header),
                        )),
                    Divider(
                      color: Utils.header,
                      thickness: 3,
                      indent: width * 0.27,
                      endIndent: width * 0.27,
                    )
                  ]);
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
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.03,
                                      height * 0.03,
                                      width * 0.03,
                                      height * 0.06),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Text(
                                        categoriesAndOffers
                                            .elementAt(cat)['name'],
                                        style: TextStyle(
                                            fontSize: size * 45,
                                            fontWeight: FontWeight.w600,
                                            color: Utils.header),
                                      ),
                                    ),
                                  ))
                            else
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.03,
                                      height * 0.03,
                                      width * 0.03,
                                      height * 0.06),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      child: Text(
                                        categoriesAndOffers
                                            .elementAt(cat)['name'],
                                        style: TextStyle(
                                            fontSize: size * 45,
                                            fontWeight: FontWeight.w600,
                                            color: Utils.header),
                                      ),
                                    ),
                                  )),
                            if(categoriesAndOffers.elementAt(cat)['offers'].length>0)
                            GridView.count(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              // Create a grid with 2 columns. If you change the scrollDirection to
                              // horizontal, this produces 2 rows.
                              crossAxisCount: 2,
                              addAutomaticKeepAlives: true,
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
                                                style: TextStyle(
                                                    fontSize: size * 35,
                                                    color: Utils.header),
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
                            else
                              Center(child: Text("No Offers"))
                          ],
                        );
                      });
                }
              }));
    } catch (Exception) {
      print(Exception);
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
