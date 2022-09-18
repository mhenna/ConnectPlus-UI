import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_plus/WebinarWidget.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/webinar.dart';
import 'package:connect_plus/qr_code_scanner_event_widget.dart';
import 'package:connect_plus/services/auth_service/auth_service.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/EventWidget.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'injection_container.dart';
import 'login.dart';

class QrCodeScannerHomeScreen extends StatefulWidget {
  QrCodeScannerHomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _QrCodeScannerHomeScreenState createState() => _QrCodeScannerHomeScreenState();
}

class _QrCodeScannerHomeScreenState extends State<QrCodeScannerHomeScreen>
{

//  String token;
  List<Event> events = [];
  List<Event> searchDataEvents = [];
  List<dynamic> searchAll;
  num randIndex;
  num randIndexWeb;
  bool emptyEvents = true;
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
    final allEvents = await WebAPI.getAllEvents();
    if (this.mounted) {
      eventsLoaded = true;

      setState(() {
        events = allEvents;
        if (events.length != 0) {
          emptyEvents = false;
        }
      });
    }
    if (!emptyEvents) {
      _all.addAll(events);
      _filteredData.addAll(events);
    }
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

  }

  getSearchData() {
    searchDataEvents = this.events;
    searchAll = this._all;
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QrCodeScannerEventWidget(event: event),
                            ),
                          );
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
      if (!eventsLoaded)
        return Scaffold(
          body: ImageRotate(),
        );
      else if (_filteredData.isEmpty && eventsLoaded)
        return RefreshIndicator(
            onRefresh: _refreshData,
            child: WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                  appBar: AppBar(
                    // Here we take the value from the MyHomePage object that was created by
                    // the App.build method, and use it to set our appbar title.
                      automaticallyImplyLeading: false,
                      title: Text("Events"),
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
                      actions: <Widget>[
                  IconButton(
                  icon: const Icon(Icons.logout),
                tooltip: 'Log out',
                onPressed: () async {
                  await sl<AuthService>().logout();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Login()),
                          (Route<dynamic> route) => false);
                },
              ),
              ]
                  ),
                  body: Center(child: Text("No Recent Events"))),
            ));
      else
        return RefreshIndicator(
            onRefresh: _refreshData,
            child: WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
                  appBar: AppBar(
                    // Here we take the value from the MyHomePage object that was created by
                    // the App.build method, and use it to set our appbar title.
                      automaticallyImplyLeading: false,
                      title: Text("Events"),
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
                      actions: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.logout),
                          tooltip: 'Log out',
                          onPressed: () async {
                           await sl<AuthService>().logout();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (context) => Login()),
                                    (Route<dynamic> route) => false);
                          },
                        ),
                      ]
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
                              ]))))),
            ));
    } catch (err) {
      return Scaffold(
        body: ImageRotate(),
      );
    }
  }

  List<dynamic> getEventsSuggestions(String pattern) {
    if (pattern == "") return null;
    print(pattern);
    print(_all.length);
    final filter = _filteredData
        .where(
          (entry) => entry.name.toLowerCase().contains(pattern.toLowerCase()),
    )
        .toList();
    return filter;
  }
}
