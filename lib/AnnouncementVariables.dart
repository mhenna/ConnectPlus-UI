import 'package:flutter/material.dart';
import 'package:connect_plus/models/announcement.dart';
import 'package:localstorage/localstorage.dart';
import 'package:connect_plus/services/web_api.dart';
import 'announcement_widget.dart';
import 'package:connect_plus/widgets/CachedImageBox.dart';

class AnnouncementVariables extends StatefulWidget {
  AnnouncementVariables({Key key, @required this.announcements})
      : super(key: key);

  final List<Announcement> announcements;

  @override
  State<StatefulWidget> createState() {
    return new _AnnouncementVariables(this.announcements);
  }
}

class _AnnouncementVariables extends State<AnnouncementVariables>
    with TickerProviderStateMixin {
  List<Announcement> announcements = [];
  bool emptyList = false;
  final LocalStorage localStorage = new LocalStorage("Connect+");

  _AnnouncementVariables(this.announcements);

  @override
  void initState() {
    super.initState();
    if (announcements.isEmpty) emptyList = true;
    announcements.sort((b, a) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  Widget build(BuildContext context) {
    final _scrollController = ScrollController();
    var height = MediaQuery.of(context).size.height;
    if (emptyList)
      return Center(child: Text("No Recent Announcements, Coming Soon"));
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 6, right: 6),
          child:
              Container(height: height * 0.3, child: _mostRecentAnnouncement()),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 6, right: 7, top: 5),
            child: ListView(
              controller: _scrollController,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: constructAnnouncements(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _mostRecentAnnouncement() {
    if (announcements.isNotEmpty)
      return Single_Announcement(announcements.first);
    return null;
  }

  List<Widget> constructAnnouncements() {
    List<Widget> list = List<Widget>();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    bool first = true;
    final LIST_SIZE = 6;
    for (var i = 0; i < LIST_SIZE && i < announcements.length; i++) {
      Widget child = Padding(
        padding: EdgeInsets.only(right: 10),
        child: SizedBox(
          height: height,
          width: 0.97 * 0.23 * height * 3 / 2,
          child: Single_Announcement(announcements[i]),
        ),
      );
      if (!first) {
        list.add(child);
      }
      first = false;
    }
    return list;
  }
}

class Single_Announcement extends StatelessWidget {
  final Announcement announcement;

  //constructor
  Single_Announcement(this.announcement);
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height,
      child: Card(
        child: Hero(
          tag: announcement.id,
          child: Material(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnnouncementWidget(
                      announcement: announcement,
                    ),
                  ),
                );
              },
              child: GridTile(
                  footer: Container(
                    color: Colors.white70,
                    child: ListTile(
                      title: Column(
                        children: <Widget>[
                          Text(
                            announcement.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          )
                        ],
                      ),
                    ),
                  ),
                  child: CachedImageBox(
                    imageurl: announcement.poster,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
