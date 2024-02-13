import 'package:connect_plus/Navbar.dart';
import 'package:connect_plus/models/category.dart';
import 'package:connect_plus/models/offer.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/ImageRotate.dart';
import 'package:connect_plus/widgets/pdf_viewer_from_url.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/Utils.dart';
import 'package:connect_plus/widgets/CachedImageBox.dart';

class OfferWidget extends StatefulWidget {
  OfferWidget({
    Key key,
    @required this.offer,
    @required this.category,
  }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final Category category;
  final Offer offer;

  @override
  _OfferState createState() => _OfferState();
}

class _OfferState extends State<OfferWidget> with TickerProviderStateMixin {
  List<Offer> relatedOffers = [];
  final LocalStorage localStorage = new LocalStorage("Connect+");

  bool loading = true;

  AnimationController controller;
  Animation<double> animation;
  _OfferState();

  void initState() {
    super.initState();
    getOffers();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> getOffers() async {
    final offers = await WebAPI.getOffersByCategory(widget.category);
    if (this.mounted)
      setState(() {
        this.relatedOffers = offers;
        loading = false;
      });
  }

  Widget urlToImage(String imageURL) {
    return Expanded(
      child: SizedBox(
        width: MediaQuery.of(context)
            .size
            .width, // otherwise the logo will be tiny
        child: CachedImageBox(
          imageurl: imageURL,
        ),
      ),
    );
  }

  List<Widget> constructRelatedOffers() {
    List<Widget> list = List<Widget>();
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size.aspectRatio;

    relatedOffers.sort((b, a) => b.expiration.compareTo(a.expiration));

    for (var offer in relatedOffers) {
      if (offer.id != widget.offer.id) {
        list.add(Container(
            padding: EdgeInsets.fromLTRB(width * 0.01, 0.0, width * 0.01, 0.0),
            width: width * 0.48,
            child: Center(
              child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OfferWidget(
                          category: offer.category,
                          offer: offer,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        urlToImage(offer.logo),
                        ButtonBar(
                          alignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                offer.name,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: size * 30, color: Colors.black87),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OfferWidget(
                                      category: offer.category,
                                      offer: offer,
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  )),
            )));
      }
    }
    return list;
  }

  Widget _offerPoster() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: CachedImageBox(
            imageurl:  widget.offer.logo,
          ),
        )
      ],
    );
  }

  Widget moreDetails() {
    if (widget.offer.attachment != null) {
      return Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          InkWell(
            child: Text(
              "Offer Attachment",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16.0,
              ),
            ),
            onTap: () async {
              String pathPDF = widget.offer.attachment;
              if (widget.offer.attachment != null)
                Navigator.push(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (_) => PDFViewerCachedFromUrl(
                      url: pathPDF,
                      title: widget.offer.name,
                    ),
                  ),
                );
            },
          )
        ],
      );
    } else {
      return SizedBox(height: 1);
    }
  }

  Widget _relatedOffers() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    final _scrollController = ScrollController();
    if (relatedOffers.isNotEmpty) {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
              0,
              height * 0.08,
              0,
              height * 0.02,
            ),
            child: Text(
              " Related Offers",
              style: TextStyle(fontSize: size * 45, color: Utils.header),
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, width * 0.02, height * 0.02),
              child: SizedBox(
                  height: height * 0.28,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListView(
                        controller: _scrollController,
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: constructRelatedOffers(),
                      )))),
        ],
      );
    } else {
      return SizedBox(height: 1);
    }
  }

  Widget _detailWidget() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var size = MediaQuery.of(context).size.aspectRatio;
    final _scrollController = ScrollController();

    return DraggableScrollableSheet(
      maxChildSize: .6,
      initialChildSize: .5,
      minChildSize: .4,
      builder: (context, scrollController) {
        return Container(
          padding: Utils.padding.copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Utils.background),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: width * 0.1,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Utils.header,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${widget.offer.discount.toString()}",
                        style: TextStyle(
                            fontSize: size * 50,
                            color: Utils.headline,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _description(),

                moreDetails(),
                // TODO: Hide this section when we don't have related offers.
                _relatedOffers(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _description() {
    var size = MediaQuery.of(context).size.aspectRatio;
    var text = "";
    if (widget.offer.location != null) {
      text += "\n\nLocation: " + widget.offer.location.toString();
    }
    if (widget.offer.contact != null) {
      text += "\n\nContact: " + widget.offer.contact.toString();
    }
    if (widget.offer.expiration != null) {
      text += "\n\nExpires: " +
          DateFormat.yMMMMd("en_US").format(widget.offer.expiration) +
          "\n";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SelectableText(
          widget.offer.details,
          style: TextStyle(
            color: Utils.header,
            fontSize: size * 31,
          ),
        ),
        SelectableText(
          text,
          style: TextStyle(
            color: Colors.black87,
            fontSize: size * 30,
          ),
        ),
        ClickableButton(
            link: widget.offer.link,
            text: 'Offer Link',
            launchURL: _launchURL)
      ],
    );
  }

  _launchURL(String url) async {
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    if (loading == true) {
      return Scaffold(
        body: ImageRotate(),
      );
    } else
      return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.offer.name),
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
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Utils.secondaryColor,
                Utils.primaryColor,
              ],
              begin: Alignment.topRight,
              end: Alignment.topLeft,
            ),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: Utils.paddingPoster,
                    height: height * 0.30,
                    child: _offerPoster(),
                  )
                ],
              ),
              _detailWidget(),
            ],
          ),
        ),
      );
  }
}

class ClickableButton extends StatelessWidget {
  const ClickableButton({Key key, this.link, this.text, this.launchURL})
      : super(key: key);
  final String link;
  final String text;
  final void Function(String) launchURL;

  @override
  Widget build(BuildContext context) {
    return link == '' || link == null
        ? Container()
        : Center(
            child: RaisedButton(
              onPressed: () => launchURL(link ?? ''),
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
                  this.text,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
  }
}
