import 'package:connect_plus/WebinarWidget.dart';
import 'package:connect_plus/models/erg.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/webinar.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/utils/map_indexed.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/EventWidget.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:math';

class Events extends StatefulWidget {
  Events({
    Key key,
  }) : super(key: key);
  static final _random = new Random();

  @override
  MyEventsPageState createState() => MyEventsPageState();
}

class MyEventsPageState extends State<Events>
    with AutomaticKeepAliveClientMixin<Events> {
  @override
  bool get wantKeepAlive => true;

//  String token;
  List<Event> events = [];
  List<Webinar> webinars = [];
  List<Event> searchDataEvents = [];
  List<Webinar> searchDataWebinars = [];
  List<dynamic> searchAll;
  num randIndex;
  num randIndexWeb;
  bool emptyEvents = true;
  bool emptyWebinars = true;
  List<dynamic> _all;
  final LocalStorage localStorage = new LocalStorage("Connect+");
  List<String> selectedCountList = [];
  List<String> ergsList;
  List<dynamic> _filteredData;

  void initState() {
    _all = [];
    _filteredData = [];
    ergsList = [];
    super.initState();
    getEvents();
    getWebinars();
    getERGS();
  }

  void getEvents() async {
    final allEvents = await WebAPI.getEvents();
    if (this.mounted)
      setState(() {
        events = allEvents;
        if (events.length != 0) {
          emptyEvents = false;
        }
        randIndex = Events._random.nextInt(events.length);
      });
    if (!emptyEvents) {
      _all.addAll(events);
      _filteredData.addAll(events);
    }
  }

  void getWebinars() async {
    final allWebinars = await WebAPI.getWebinars();
    if (this.mounted)
      setState(() {
        webinars = allWebinars;
        if (webinars.length != 0) {
          emptyWebinars = false;
        }
        //randIndexWeb = Webinars._random.nextInt(webinars.length);
      });
    if (!emptyWebinars) {
      _all.addAll(webinars);
      _filteredData.addAll(webinars);
    }
    getSearchData();
  }

  getSearchData() {
    searchDataEvents = this.events;
    searchDataWebinars = this.webinars;
    searchAll = this._all;
  }

  void getERGS() async {
    final ergs = await WebAPI.getERGS();
    ergsList = [];
    for (final erg in ergs) {
      ergsList.add(erg.name);
    }
    selectedCountList = List.from(ergsList);
  }

  void filterData() async {
    _filteredData = [];
    for (final data in _all) {
      if (selectedCountList.indexOf(data.erg.name) != -1) {
        _filteredData.add(data);
      }
    }
    setState(() {});
  }

  Widget featuredImage() {
    try {
      final featuredEvent = events[randIndex];
      final imageURL = WebAPI.baseURL + featuredEvent.poster.url;
      return FittedBox(
        fit: BoxFit.contain,
        child: Image.network(imageURL),
      );
    } catch (Exception) {
      return Scaffold(
        body: ImageRotate(),
      );
    }
  }

  Widget urlToImage(String imageUrl) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width *
          0.50, // otherwise the logo will be tiny
      child: Image.network(imageUrl),
    );
  }

  Widget search() {
    return Container(
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Search ")),
        suggestionsCallback: (pattern) async {
          return getEventsSuggestions(pattern);
        },
        itemBuilder: (context, dynamic suggestedObject) {
          return ListTile(
            leading: Icon(Icons.event),
            title: Text(suggestedObject.name),
          );
        },
        onSuggestionSelected: (suggestion) {
          if (suggestion.runtimeType == Event) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventWidget(
                  event: suggestion,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WebinarWidget(
                  webinar: suggestion,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _openFilterDialog() async {
    await FilterListDialog.display(context,
        allTextList: ergsList,
        height: 480,
        borderRadius: 20,
        headlineText: "Select Committees",
        applyButonTextBackgroundColor: Utils.header,
        allResetButonColor: Utils.header,
        selectedTextBackgroundColor: Utils.header,
        searchFieldHintText: "Search Here",
        selectedTextList: selectedCountList, onApplyButtonClick: (list) {
      if (list != null) {
        setState(() {
          selectedCountList = List.from(list);
          filterData();
        });
      }
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    try {
      Scaffold(
        body: ImageRotate(),
      );
      if (emptyEvents)
        return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Events & Webinars"),
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
      else
        return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Events & Webinars"),
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
            floatingActionButton: FloatingActionButton(
              onPressed: _openFilterDialog,
              child: Icon(Icons.filter_list),
            ),
            body: Padding(
                padding: EdgeInsets.only(
                    top: height * 0.02,
                    bottom: height * 0.02,
                    left: width * 0.02,
                    right: width * 0.02),
                child: Container(
                    child: SingleChildScrollView(
                        child: Column(children: <Widget>[
                  search(),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    children: mapIndexed(_filteredData, (index, event) {
                      return Center(
                        child: Padding(
                            padding: EdgeInsets.only(bottom: height * 0.02),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                height:
                                    MediaQuery.of(context).size.height * 0.40,
                                child: Card(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      urlToImage(
                                          WebAPI.baseURL + event.poster.url),
                                      Container(
                                        height: 50,
                                        child: ButtonBar(
                                          alignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                event.name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 22),
                                              ),
                                              onPressed: () {
                                                if (event.runtimeType ==
                                                    Event) {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EventWidget(
                                                              event: event),
                                                    ),
                                                  );
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          WebinarWidget(
                                                              webinar: event),
                                                    ),
                                                  );
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ))),
                      );
                    }).toList(),
                  ),
                ])))));
    } catch (err) {
      return Scaffold(
        body: ImageRotate(),
      );
    }
  }

  List<dynamic> getEventsSuggestions(String pattern) {
    if (pattern == "") return null;
    final filter = searchAll
        .where(
          (entry) => entry.name.toLowerCase().startsWith(pattern.toLowerCase()),
        )
        .toList();
    return filter;
  }
}
