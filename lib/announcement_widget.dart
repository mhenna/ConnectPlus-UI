import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/Utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/CachedImageBox.dart';
import 'package:connect_plus/models/announcement.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:connect_plus/widgets/pdf_viewer_from_url.dart';

class AnnouncementWidget extends StatefulWidget {
  final Announcement announcement;

  const AnnouncementWidget({Key key, @required this.announcement})
      : super(key: key);

  @override
  _AnnouncementWidgetState createState() => _AnnouncementWidgetState();
}

class _AnnouncementWidgetState extends State<AnnouncementWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.announcement.name),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 112),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.topLeft,
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
              child: AnnouncementImage(announcement: widget.announcement),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: InfoSheet(announcement: widget.announcement),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 7, 25, 7),
      child: CachedImageBox(
        imageurl: WebAPI.baseURL + announcement.poster.url,
      ),
    );
  }
}

class InfoSheet extends StatefulWidget {
  const InfoSheet({
    Key key,
    @required this.announcement,
  }) : super(key: key);

  final Announcement announcement;

  @override
  _InfoSheetState createState() => _InfoSheetState();
}

class _InfoSheetState extends State<InfoSheet> {
  TextStyle _style(BuildContext context) => TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w500,
        fontSize: MediaQuery.of(context).size.aspectRatio * 35,
      );

  Future<void> _goTo(String url) async {
    if (!await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _deadlineDate() {
    if (widget.announcement.deadline != null) {
      final date =
          DateFormat.yMMMMd('en_US').format(widget.announcement.deadline);
      return "Date: $date";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: DraggableScrollableSheet(
        minChildSize: 0.5,
        initialChildSize: 0.5,
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
                Text(
                  "Description",
                  style: _style(context),
                ),
                SelectableText(widget.announcement.description),
                Divider(color: Colors.transparent, height: 10),
                SelectableText(
                  'On Behalf of: ${widget.announcement.onBehalfOf}',
                  style: _style(context),
                ),
                Divider(color: Colors.transparent, height: 10),
                Visibility(
                  visible: widget.announcement.deadline != null,
                  child: SelectableText(
                    _deadlineDate(),
                    style: _style(context),
                  ),
                ),
                Divider(color: Colors.transparent, height: 10),

                // trivia button
                TriviaButton(
                  announcement: widget.announcement,
                  onPressed: () => _goTo(widget.announcement.trivia),
                ),
                LinkButton(
                  announcement: widget.announcement,
                  onPressed: () => _goTo(widget.announcement.link),
                ),

                AttachmentButton(
                  announcement: widget.announcement,
                  onPressed: () =>
                      _launchAttachment(widget.announcement.attachment),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _launchAttachment(String url) async {
    String pathPDF = WebAPI.baseURL + url;
    print(pathPDF);
    if (url != null)
      Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (_) => PDFViewerCachedFromUrl(
            url: pathPDF,
            title: widget.announcement.name,
          ),
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
              'Registration Link',
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

class AttachmentButton extends StatelessWidget {
  const AttachmentButton({
    Key key,
    @required this.announcement,
    @required this.onPressed,
  }) : super(key: key);

  final Announcement announcement;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: announcement.attachment != null,
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
              'More Details',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
