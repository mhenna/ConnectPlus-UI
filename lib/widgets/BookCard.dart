import "dart:ui";
import 'package:connect_plus/models/BookPost.dart';
import 'package:connect_plus/utils/enums.dart';
import 'package:connect_plus/widgets/app_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../BookSwapsViewRequests.dart';

class BookCard extends StatelessWidget {
  final String bookCoverUrl;
  final VoidCallback onTap;
  final String bookInfoText;
  final String bookName;
  final BookPost bookPost;

  const BookCard({
    Key key,
    @required this.bookCoverUrl,
    @required this.bookInfoText,
    @required this.bookName,
    @required this.onTap,
    this.bookPost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    _viewRequests() {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BookSwapsViewRequests(bookPost: bookPost)),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    bookCoverUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  bookName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  bookInfoText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (bookPost != null &&
                    bookPost.postStatus != BookPostStatus.rejectedByAdmin &&
                    bookPost.postStatus != BookPostStatus.pendingAdminApproval)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                    child: AppButton(
                        title: 'View Requests', onPress: _viewRequests),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
