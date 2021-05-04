import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageBox extends StatelessWidget {
  CachedImageBox({Key key, @required this.imageurl}) : super(key: key);
  final String imageurl;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => Center(
        child: SizedBox(
          height: 40,
          width: 40,
          child: CircularProgressIndicator(),
        ),
      ),
      imageUrl: imageurl,
      fit: BoxFit.fill,
    );
  }
}
