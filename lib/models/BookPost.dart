import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_plus/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class BookPost {
  String postedAt;
  String postedByFullName;
  String postedByEmail;
  String postedById;
  String postedByBU;
  String bookName;
  String bookPagesRange;
  String bookCategory;
  String bookDescription;
  BookPostStatus postStatus;
  String bookCoverUrl;
  String borrowerFullName;
  String postId;

  // Constructor
  BookPost({
    this.postedAt,
    @required this.postedByFullName,
    @required this.postedByEmail,
    @required this.postedById,
    @required this.postedByBU,
    @required this.bookName,
    @required this.bookPagesRange,
    @required this.bookCategory,
    @required this.bookDescription,
    @required this.postStatus,
    @required this.bookCoverUrl,
    @required this.borrowerFullName,
    this.postId,
  });

  // Deserialize JSON data into BookPost object
  factory BookPost.fromJson(Map<String, dynamic> json) {
    return BookPost(
        postedAt: DateFormat('dd MMMM yyyy, hh:mm a')
            .format(json['postedAt'].toDate()),
        postedByFullName: json['postedByFullName'],
        postedByEmail: json['postedByEmail'],
        postedById: json['postedById'],
        postedByBU: json['postedByBU'],
        bookName: json['bookName'],
        bookPagesRange: json['bookPagesRange'],
        bookCategory: json['bookCategory'],
        bookDescription: json['bookDescription'],
        postStatus: bookPostStatusValues.entries
            .firstWhere((entry) => entry.value == json['postStatus'])
            .key,
        bookCoverUrl: json['bookCoverUrl'],
        borrowerFullName: json['borrowerFullName'],
        postId: json['postId']);
  }

  // Serialize BookPost object into JSON data
  Map<String, dynamic> toJson() {
    if (postId != null)
      return {
        'postedAt': Timestamp.fromDate(DateTime.now()),
        'postedByFullName': postedByFullName,
        'postedByEmail': postedByEmail,
        'postedById': postedById,
        'postedByBU': postedByBU,
        'bookName': bookName,
        'bookPagesRange': bookPagesRange,
        'bookCategory': bookCategory,
        'bookDescription': bookDescription,
        'postStatus': bookPostStatusValues[postStatus],
        'bookCoverUrl': bookCoverUrl,
        'borrowerFullName': borrowerFullName,
        'postId': postId
      };
    else {
      return {
        'postedAt': Timestamp.fromDate(DateTime.now()),
        'postedByFullName': postedByFullName,
        'postedByEmail': postedByEmail,
        'postedById': postedById,
        'postedByBU': postedByBU,
        'bookName': bookName,
        'bookPagesRange': bookPagesRange,
        'bookCategory': bookCategory,
        'bookDescription': bookDescription,
        'postStatus': bookPostStatusValues[postStatus],
        'bookCoverUrl': bookCoverUrl,
        'borrowerFullName': borrowerFullName,
      };
    }
  }

  String getPostStatusString() {
    if (this.postStatus == BookPostStatus.requestAccepted)
      return bookPostStatusValues[this.postStatus]
          .replaceAll("User", "${this.borrowerFullName}'s");
    else
      return bookPostStatusValues[this.postStatus]
          .replaceAll("User", this.borrowerFullName);
  }
}
