import 'package:flutter/material.dart';
import 'package:connect_plus/models/wire_magazine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:connect_plus/widgets/pdf_viewer_from_url.dart';


class WireMagazineCard extends StatefulWidget {
  const WireMagazineCard({Key key, @required this.wireMagazine,
  }) : super(key: key);
  final WireMagazine wireMagazine;

  @override
  _WireMagazineCardState createState() => _WireMagazineCardState(this.wireMagazine);
}

class _WireMagazineCardState extends State<WireMagazineCard> {
  final WireMagazine wireMagazine;
  _WireMagazineCardState(this.wireMagazine);
  Widget urlToImage(String imageUrl) {
    ImageCache _imageCache = PaintingBinding.instance.imageCache;
    if (_imageCache.currentSize >= 55 << 20 ||
        (_imageCache.currentSize + _imageCache.liveImageCount) >= 20) {
      _imageCache.clear();
      _imageCache.clearLiveImages();
    }

    return SizedBox(
        width: MediaQuery.of(context).size.width*0.625,
        height: MediaQuery.of(context).size.height *
            0.675, // otherwise the logo will be tiny
        child: FittedBox(
            fit: BoxFit.fill,
            child: CachedNetworkImage(
              filterQuality: FilterQuality.high,
              imageUrl: imageUrl,
              memCacheWidth: (MediaQuery.of(context).size.width * 1).toInt(),
              memCacheHeight: (MediaQuery.of(context).size.width * 0.5).toInt(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Text(
          "The Wire Edition ${wireMagazine.edition}",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.w500),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
            elevation: 2.0,
            clipBehavior: Clip.antiAlias,
            margin: EdgeInsets.only(left:30.0,right:30.0,top:15,bottom: 30),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: InkWell(
              child: urlToImage(WebAPI.baseURL + wireMagazine.cover.url),
                onTap: () async {
                  if (wireMagazine.pdf.url != null) {
                    String pathPDF = WebAPI.baseURL + wireMagazine.pdf.url;
                    Navigator.push(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (_) =>
                            PDFViewerCachedFromUrl(
                              url: pathPDF,
                              title: "The Wire Edition ${wireMagazine.edition}",
                            ),
                      ),
                    );
                  }
                }
            )),

      ],
    );
  }
}
