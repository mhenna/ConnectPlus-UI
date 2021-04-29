import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageBox extends StatelessWidget {
  CachedImageBox({Key key, @required this.imageurl}) : super(key: key);
  final String imageurl;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => Expanded(
        child: Container(color: Colors.grey[300]),
      ),
      imageUrl: imageurl,
      fit: BoxFit.fill,
    );
  }
}
