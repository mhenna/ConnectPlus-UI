import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_plus/utils/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class BookRequest {
  String requestedAt;
  String requestedByFullName;
  String requestedByEmail;
  String requestedById;
  String requestedByBU;
  BookRequestStatus requestStatus;
  String bookName;
  String bookPagesRange;
  String bookCategory;
  String bookDescription;
  String postId;
  String postedByEmail;
  String postedByFullName;
  String postedById;
  String bookCoverUrl;
  String requestDuration;
  String requestId;

  BookRequest(
      {this.requestedAt,
      @required this.requestedByFullName,
      @required this.requestedByEmail,
      @required this.requestedById,
      @required this.requestedByBU,
      @required this.requestStatus,
      @required this.bookName,
      @required this.bookPagesRange,
      @required this.bookCategory,
      @required this.bookDescription,
      @required this.postId,
      @required this.postedByEmail,
      @required this.postedByFullName,
      @required this.postedById,
      @required this.bookCoverUrl,
      @required this.requestDuration,
      this.requestId});

  factory BookRequest.fromJson(Map<String, dynamic> json) {
    return BookRequest(
        requestedAt: DateFormat('dd MMMM yyyy, hh:mm a').format(json['requestedAt'].toDate()),
        requestedByFullName: json['requestedByFullName'],
        requestedByEmail: json['requestedByEmail'],
        requestedById: json['requestedById'],
        requestedByBU: json['requestedByBU'],
        requestStatus: bookRequestStatusValues.entries
            .firstWhere((entry) => entry.value == json['requestStatus'])
            .key,
        bookName: json['bookName'],
        bookPagesRange: json['bookPagesRange'],
        bookCategory: json['bookCategory'],
        bookDescription: json['bookDescription'],
        postId: json['postId'],
        postedByEmail: json['postedByEmail'],
        postedByFullName: json['postedByFullName'],
        postedById: json['postedById'],
        bookCoverUrl: json['bookCoverUrl'],
        requestDuration: json['requestDuration'],
        requestId: json['requestId']);
  }

  Map<String, dynamic> toJson() {
    if (requestId != null)
      return {
        'requestedAt': Timestamp.fromDate(DateTime.now()),
        'requestedByFullName': requestedByFullName,
        'requestedByEmail': requestedByEmail,
        'requestedById': requestedById,
        'requestedByBU': requestedByBU,
        'requestStatus': bookRequestStatusValues[requestStatus],
        'bookName': bookName,
        'bookPagesRange': bookPagesRange,
        'bookCategory': bookCategory,
        'bookDescription': bookDescription,
        'postId': postId,
        'postedByEmail': postedByEmail,
        'postedByFullName': postedByFullName,
        'postedById': postedById,
        'bookCoverUrl': bookCoverUrl,
        'requestDuration': requestDuration,
        'requestId': requestId
      };
    else {
      return {
        'requestedAt': Timestamp.fromDate(DateTime.now()),
        'requestedByFullName': requestedByFullName,
        'requestedByEmail': requestedByEmail,
        'requestedById': requestedById,
        'requestedByBU': requestedByBU,
        'requestStatus': bookRequestStatusValues[requestStatus],
        'bookName': bookName,
        'bookPagesRange': bookPagesRange,
        'bookCategory': bookCategory,
        'bookDescription': bookDescription,
        'postId': postId,
        'postedByEmail': postedByEmail,
        'postedByFullName': postedByFullName,
        'postedById': postedById,
        'bookCoverUrl': bookCoverUrl,
        'requestDuration': requestDuration,
      };
    }
  }
}
