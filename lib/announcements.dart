import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_plus/models/announcement.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class Announcements extends StatefulWidget {
  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  List<String> onBehalfOfFilter;

  bool filter(Announcement announcement) {
    return onBehalfOfFilter.contains(announcement.onBehalfOf);
  }

  Future<void> _showFilters(List<Announcement> announcements) async {
    final selectedFilters = onBehalfOfFilter.isEmpty
        ? announcements.map((a) => a.onBehalfOf).toList()
        : onBehalfOfFilter;
    return await FilterListDialog.display(
      context,
      allTextList: announcements.map((a) => a.onBehalfOf).toList(),
      height: 480,
      borderRadius: 20,
      headlineText: "Select Announcements on Behalf of",
      applyButonTextBackgroundColor: Utils.header,
      allResetButonColor: Utils.header,
      selectedTextBackgroundColor: Utils.header,
      searchFieldHintText: "Search Here",
      selectedTextList: selectedFilters,
      onApplyButtonClick: (onBehalfOfFilterList) {
        setState(() {
          onBehalfOfFilter = onBehalfOfFilterList;
        });
        Navigator.pop(context);
      },
    );
  }

  Future<List<Announcement>> _getAnnouncements() async {
    final announcements = await WebAPI.getUnexpiredAnnouncements();

    if (onBehalfOfFilter == null) {
      // will only run once
      onBehalfOfFilter = announcements.map((a) => a.onBehalfOf).toList();
    }
    return announcements;
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return FutureBuilder<List<Announcement>>(
      future: _getAnnouncements(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Scaffold(body: LoadingIndicator());
        final List<Announcement> announcements = snapshot.data;
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.filter_list),
            onPressed: () async {
              await _showFilters(announcements);
            },
          ),
          appBar: AppBar(
            title: Text("Announcements"),
            centerTitle: true,
            bottom: PreferredSize(
              child: SearchBar(
                toSuggest: (pattern) {
                  if (pattern == "") return null;
                  return announcements
                      .where((a) => filter(a) && a.name.startsWith(pattern))
                      .take(5); // suggests only 5
                },
              ),
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
          body: Padding(
            padding: EdgeInsets.only(
              top: screen.height * 0.02,
              bottom: screen.height * 0.02,
              left: screen.width * 0.02,
              right: screen.width * 0.02,
            ),
            child: ListView(
              children: announcements.where(filter).map((announcement) {
                return Center(
                  child: SizedBox(
                    width: screen.width * 0.8,
                    child: AnnouncementCard(announcement: announcement),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  const AnnouncementCard({
    Key key,
    @required this.announcement,
  }) : super(key: key);

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnnouncementName(announcement: announcement),
        SizedBox(height: 5),
        Card(
          elevation: 7.0,
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(12.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          child: InkWell(
            child: AnnouncementImage(announcement: announcement),
            onTap: () {
              //TODO: Navigate to announcement widget
            },
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}

class AnnouncementImage extends StatelessWidget {
  const AnnouncementImage({
    Key key,
    @required this.announcement,
  }) : super(key: key);

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.5,
      child: CachedNetworkImage(
        fit: BoxFit.fill,
        placeholder: (context, url) => LoadingIndicator(),
        imageUrl: WebAPI.baseURL + announcement.poster.url,
      ),
    );
  }
}

class AnnouncementName extends StatelessWidget {
  const AnnouncementName({
    Key key,
    @required this.announcement,
  }) : super(key: key);

  final Announcement announcement;

  @override
  Widget build(BuildContext context) {
    return Text(
      announcement.name,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 23,
        color: Colors.black87,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final FutureOr<Iterable<Announcement>> Function(String pattern) toSuggest;

  const SearchBar({Key key, @required this.toSuggest}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 10),
      child: TypeAheadField<Announcement>(
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
            hintText: " Search ",
          ),
        ),
        suggestionsCallback: toSuggest,
        itemBuilder: (context, dynamic suggestedObject) {
          return ListTile(
            leading: Icon(Icons.announcement),
            title: Text(suggestedObject.name),
          );
        },
        onSuggestionSelected: (announcement) {
          //TODO navigate to announcement widget
        },
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 60,
        width: 60,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
