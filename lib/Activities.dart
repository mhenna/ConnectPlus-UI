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
    if (this.mounted)
      setState(() {
        activities = allActivities;
        if (activities.length != 0) {
          emptyActivities = false;
        }
        randIndex = Activities._rand.nextInt(activities.length);
      });
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
        fit: BoxFit.contain,
        child: Image.network(imageURL),
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
      child: Image.network(imageUrl),
    );
  }

  Widget search() {
    return Container(
      child: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
                border: OutlineInputBorder(), hintText: "Search")),
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
    var size = MediaQuery.of(context).size.aspectRatio;

    try {
      if (emptyActivities)
        return Scaffold(
            appBar: AppBar(
              // Here we take the value from the MyHomePage object that was created by
              // the App.build method, and use it to set our appbar title.
              title: Text("Activities"),
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
              title: Text("Activities"),
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
                      children: mapIndexed(_filteredData, (index, activity) {
                        return Center(
                          child: Padding(
                              padding: EdgeInsets.only(bottom: height * 0.02),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  height:
                                      MediaQuery.of(context).size.height * 0.40,
                                  child: Card(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        urlToImage(WebAPI.baseURL +
                                            activity.poster.url),
                                        Container(
                                          height: 50,
                                          child: ButtonBar(
                                            alignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              FlatButton(
                                                child: Text(
                                                  activity.name,
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      TextStyle(fontSize: 22),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ActivityWidget(
                                                              activity:
                                                                  activity),
                                                    ),
                                                  );
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
                  ]),
                ))));
    } catch (err) {
      return Scaffold(
        body: ImageRotate(),
      );
    }
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
