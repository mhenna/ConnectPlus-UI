import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connect_plus/models/announcement.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class AnnouncementWidget extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementWidget({Key key, @required this.announcement})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text(announcement.name),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 100),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Utils.secondaryColor,
              Utils.primaryColor,
            ],
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: AnnouncementImage(announcement: announcement),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InfoSheet(announcement: announcement),
            ),
          ],
        ),
      ),
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
    return CachedNetworkImage(
      height: MediaQuery.of(context).size.height * 0.3,
      imageUrl: WebAPI.baseURL + announcement.poster.url,
      placeholder: (_, __) => SizedBox(
        height: 40,
        width: 40,
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class InfoSheet extends StatelessWidget {
  const InfoSheet({
    Key key,
    @required this.announcement,
  }) : super(key: key);

  final Announcement announcement;

  TextStyle _style(BuildContext context) => TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
        fontSize: MediaQuery.of(context).size.aspectRatio * 35,
      );

  Future<void> _goTo(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _deadlineDate() {
    if (announcement.deadline != null) {
      final date = DateFormat.yMMMMd('en_US').format(announcement.deadline);
      return "Date: $date";
    } else {
      return "";
    }
  }

  String _deadlineTime() {
    if (announcement.deadline != null) {
      final time = DateFormat.Hm('en_US').format(announcement.deadline);
      return "Time: $time";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: DraggableScrollableSheet(
        minChildSize: 0.4,
        initialChildSize: 0.4,
        maxChildSize: 0.6,
        builder: (_, cont) {
          return Container(
            padding: EdgeInsets.only(top: Utils.padding.top),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40),
              ),
            ),
            child: ListView(
              controller: cont,
              physics: ClampingScrollPhysics(),
              padding: const EdgeInsets.only(top: 12, left: 12),
              children: [
                Align(alignment: Alignment.center, child: DraggableIndicator()),
                SizedBox(height: 20),
                SelectableText(
                  'On Behalf of: ${announcement.onBehalfOf}',
                  style: _style(context),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10,
                ),
                Visibility(
                  visible: announcement.deadline != null,
                  child: SelectableText(
                    _deadlineDate(),
                    style: _style(context),
                  ),
                ),
                Divider(
                  color: Colors.transparent,
                  height: 10,
                ),
                Visibility(
                  visible: announcement.deadline != null,
                  child: SelectableText(
                    _deadlineTime(),
                    style: _style(context),
                  ),
                ),
                // trivia button
                TriviaButton(
                  announcement: announcement,
                  onPressed: () => _goTo(announcement.trivia),
                ),
                LinkButton(
                  announcement: announcement,
                  onPressed: () => _goTo(announcement.link),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DraggableIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      width: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Utils.header,
      ),
    );
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton({
    Key key,
    @required this.announcement,
    @required this.onPressed,
  }) : super(key: key);

  final Announcement announcement;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: announcement.link != null,
      child: Center(
        child: RaisedButton(
          onPressed: onPressed,
          color: Utils.iconColor,
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Utils.iconColor)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                colors: [
                  Utils.secondaryColor,
                  Utils.primaryColor,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(25, 7, 25, 7),
            child: Text(
              'Details',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}

class TriviaButton extends StatelessWidget {
  const TriviaButton({
    Key key,
    @required this.announcement,
    @required this.onPressed,
  }) : super(key: key);

  final Announcement announcement;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: announcement.trivia != null,
      child: Center(
        child: RaisedButton(
          onPressed: onPressed,
          color: Utils.iconColor,
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Utils.iconColor)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                colors: [
                  Utils.secondaryColor,
                  Utils.primaryColor,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(25, 7, 25, 7),
            child: Text(
              'Trivia Link',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
