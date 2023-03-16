import 'package:connect_plus/utils/enums.dart';
import 'package:flutter/cupertino.dart';

class BookPost {
  DateTime postedAt;
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
  String borrowerId;
  String borrowerFullName;
  String borrowerEmail;
  String borrowerBU;

  // Constructor
  BookPost({
    @required this.postedAt,
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
    @required this.borrowerId,
    @required this.borrowerEmail,
    @required this.borrowerFullName,
    @required this.borrowerBU,
  });

  // Deserialize JSON data into BookPost object
  factory BookPost.fromJson(Map<String, dynamic> json) {
    return BookPost(
      postedAt: DateTime.parse(json['postedAt']),
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
      borrowerId:json['borrowerId'],
      borrowerEmail: json['borrowerEmail'],
      borrowerFullName: json['borrowerFullName'],
      borrowerBU: json['borrowerBU']
    );
  }

  // Serialize BookPost object into JSON data
  Map<String, dynamic> toJson() {
    return {
      'postedAt': postedAt.toIso8601String(),
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
      'borrowerId': borrowerId,
      'borrowerFullName': borrowerFullName,
      'borrowerEmail': borrowerEmail,
      'borrowerBU': borrowerBU
    };
  }
}
