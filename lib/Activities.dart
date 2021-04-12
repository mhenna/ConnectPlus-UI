import 'dart:math';

import 'package:connect_plus/ActivityWidget.dart';
import 'package:connect_plus/models/activity.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/utils/map_indexed.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:localstorage/localstorage.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Activities extends StatefulWidget {
  Activities({
    Key key,
  }) : super(key: key);
  static final _rand = new Random();

  @override
  MyActivitiesPageState createState() => MyActivitiesPageState();
}

class MyActivitiesPageState extends State<Activities>
    with AutomaticKeepAliveClientMixin<Activities> {
  @override
  bool get wantKeepAlive => true;

  List<Activity> activities = [];
  List<Activity> searchActivities = [];
  num randIndex;
  bool emptyActivities = true;
  final LocalStorage localStorage = new LocalStorage("Connect+");
  List<String> selectedCountList = [];
  List<String> ergsList;
  List<dynamic> _filteredData;
  bool activitiesLoaded = false;
  void initState() {
    _filteredData = [];
    ergsList = [];
    searchActivities = [];
    super.initState();
    getActivities();
    getERGS();
  }

  void getActivities() async {
    final allActivities = await WebAPI.getActivities();
    if (this.mounted) {
      setState(() {
        activities = allActivities;
        if (activities.length != 0) {
          emptyActivities = false;
        }
        randIndex = Activities._rand.nextInt(activities.length);
      });
      activitiesLoaded = true;
    }
    if (!emptyActivities) _filteredData.addAll(activities);
    getSearchData();
  }

  getSearchData() {
    searchActivities = this.activities;
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
    for (final data in activities) {
      if (selectedCountList.indexOf(data.erg.name) != -1) {
        _filteredData.add(data);
      }
    }
    setState(() {});
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

  Widget featuredImage() {
    try {
      final featuruedActivity = activities[randIndex];
      final imageURL = WebAPI.baseURL + featuruedActivity.poster.url;
      return FittedBox(
        fit: BoxFit.fill,
        child: CachedNetworkImage(
          placeholder: (context, url) => CircularProgressIndicator(),
          imageUrl:
            imageURL,
        ),
      );
    } catch (Exception) {
      return Scaffold(body: ImageRotate());
    }
  }

  Widget urlToImage(String imageUrl) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width *
          0.5, // otherwise the logo will be tiny
      child: FittedBox(fit: BoxFit.fill,
        child: CachedNetworkImage(
          placeholder: (context, url) => CircularProgressIndicator(),
          imageUrl:
            imageUrl,
        ),
      ),
    );
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
                hintText: " Search for Activities")),
        suggestionsCallback: (pattern) async {
          return getActivitySuggestions(pattern);
        },
        itemBuilder: (context, dynamic suggestedObject) {
          return ListTile(
            leading: Icon(Icons.event),
            title: Text(suggestedObject.name),
          );
        },
        onSuggestionSelected: (suggestion) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityWidget(
                activity: suggestion,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    try {
      if (!activitiesLoaded) {
        return Scaffold(
          body: ImageRotate(),
        );
      } else if (activitiesLoaded && emptyActivities)
        return RefreshIndicator(
            onRefresh: _refreshData,
            child: Scaffold(
                appBar: AppBar(
                  // Here we take the value from the MyHomePage object that was created by
                  // the App.build method, and use it to set our appbar title.
                  title: Text("Events & Webinars"),
                  centerTitle: true,
                  bottom: PreferredSize(
                    child: search(),
                    preferredSize: Size.fromHeight(kToolbarHeight + 10),
                  ),
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
                body: Center(child: Text("No Recent Activities."))));
      else
        return RefreshIndicator(
            onRefresh: _refreshData,
            child: Scaffold(
                appBar: AppBar(
                  // Here we take the value from the MyHomePage object that was created by
                  // the App.build method, and use it to set our appbar title.
                  title: Text("Activities"),
                  centerTitle: true,
                  bottom: PreferredSize(
                    child: search(),
                    preferredSize: Size.fromHeight(kToolbarHeight + 10),
                  ),
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
                        SizedBox(
                          height: 10,
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          children:
                              mapIndexed(_filteredData, (index, activity) {
                            return Center(
                                child: SizedBox(
                              width: width * 0.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    activity.name.toString(),
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
                                      elevation: 7.0,
                                      clipBehavior: Clip.antiAlias,
                                      margin: EdgeInsets.all(12.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0))),
                                      child: InkWell(
                                        child: urlToImage(WebAPI.baseURL +
                                            activity.poster.url),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ActivityWidget(
                                                      activity: activity),
                                            ),
                                          );
                                        },
                                      )),
                                  SizedBox(
                                    height: 30,
                                  )
                                ],
                              ),
                            ));
                          }).toList(),
                        ),
                      ]),
                    )))));
    } catch (err) {
      return Scaffold(
        body: ImageRotate(),
      );
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _filteredData.clear();
      ergsList.clear();
      getActivities();
      getERGS();
    });
  }

  List<Activity> getActivitySuggestions(String pattern) {
    if (pattern == "") return null;
    final filter = searchActivities
        .where(
          (entry) => entry.name.toLowerCase().startsWith(pattern.toLowerCase()),
        )
        .toList();
    return filter;
  }
}
