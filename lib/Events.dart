import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_plus/WebinarWidget.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/webinar.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/EventWidget.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Events extends StatefulWidget {
  Events({
    Key key,
  }) : super(key: key);

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
  bool webinarsLoaded = false;
  bool eventsLoaded = false;

  List<dynamic> _all;
  List<String> selectedCountList = [];
  List<String> ergsList;
  List<dynamic> _filteredData;

  void initState() {
    _all = [];
    _filteredData = [];
    ergsList = [];
    super.initState();
    getEvents();
    getERGS();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _filteredData.clear();
      ergsList.clear();
      _all.clear();
      getEvents();
      getERGS();
    });
  }

  void getEvents() async {
    final allEvents = await WebAPI.getEvents();
    if (this.mounted) {
      eventsLoaded = true;

      setState(() {
        events = allEvents;
        if (events.length != 0) {
          emptyEvents = false;
        }
      });
      getWebinars();
    }
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
      sortData();
    } else {
      webinarsLoaded = true;
    }
    getSearchData();
  }

  sortData() {
    _all.sort((b, a) {
      DateTime n = a.startDate;
      DateTime m = b.startDate;
      return n.compareTo(m);
    });
    _filteredData.sort((b, a) {
      DateTime n = a.startDate;
      DateTime m = b.startDate;
      return n.compareTo(m);
    });

    webinarsLoaded = true;
  }

  getSearchData() {
    searchDataEvents = this.events;
    searchDataWebinars = this.webinars;
    searchAll = this._all;
    webinars.clear();
    events.clear();
    _all.clear();
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

  Widget urlToImage(String imageUrl) {
    ImageCache _imageCache = PaintingBinding.instance.imageCache;

    if (_imageCache.currentSize >= 55 << 20 ||
        (_imageCache.currentSize + _imageCache.liveImageCount) >= 20) {
      _imageCache.clear();
      _imageCache.clearLiveImages();
    }

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width *
            0.50, // otherwise the logo will be tiny
        child: FittedBox(
            fit: BoxFit.fill,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              memCacheWidth: (MediaQuery.of(context).size.width * 1).toInt(),
              memCacheHeight: (MediaQuery.of(context).size.width * 0.5).toInt(),
            )));
  }

  Widget search() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 10),
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                suffixIcon: Icon(Icons.search),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Utils.header),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Utils.header),
                  borderRadius: BorderRadius.circular(10),
                ),
                hintText: " Search ")),
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

  List<Widget> getContent() {
    var width = MediaQuery.of(context).size.width;
    List<Widget> list = [];
    for (final event in _filteredData) {
      list.add(Center(
          child: SizedBox(
        width: width * 0.8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              event.name.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
                elevation: 2.0,
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.all(12.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: InkWell(
                  child: urlToImage(WebAPI.baseURL + event.poster.url),
                  onTap: () {
                    if (event.runtimeType == Event) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventWidget(event: event),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WebinarWidget(webinar: event),
                        ),
                      );
                    }
                  },
                )),
            SizedBox(
              height: 30,
            )
          ],
        ),
      )));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    try {
      if (!webinarsLoaded || !eventsLoaded)
        return Scaffold(
          body: ImageRotate(),
        );
      else if (_filteredData.isEmpty && eventsLoaded && webinarsLoaded)
        return RefreshIndicator(
            onRefresh: _refreshData,
            child: Scaffold(
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
                body: Center(child: Text("No Recent Events or Webinars."))));
      else
        return RefreshIndicator(
            onRefresh: _refreshData,
            child: Scaffold(
                appBar: AppBar(
                  // Here we take the value from the MyHomePage object that was created by
                  // the App.build method, and use it to set our appbar title.
                  title: Text("Events & Webinars"),
                  centerTitle: true,
                  backgroundColor: Utils.header,
                  bottom: PreferredSize(
                    child: search(),
                    preferredSize: Size.fromHeight(kToolbarHeight + 10),
                  ),
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: SingleChildScrollView(
                          child: Column(
                            children: getContent(),
                          ),
                        ),
                      ),
                    ]))))));
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
