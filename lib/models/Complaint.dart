import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Complaint {
  String time;
  String userId;
  String fullName;
  String email;
  String image;
  String text;
  String id;
  String referenceNumber;

  Complaint({
    this.id,
    this.time,
    @required this.userId,
    @required this.fullName,
    @required this.email,
    @required this.image,
    @required this.text,
    this.referenceNumber,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'],
      time: DateFormat('dd MMMM yyyy, hh:mm a').format(json['time'].toDate()),
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
      image: json['image'],
      text: json['text'], referenceNumber: json['referenceNumber'],
    );
  }
  String generateReferenceNumber() {
    Random random = Random();
    int randomNumber = random.nextInt(90000) + 10000; // Generates a random number between 10000 and 99999
    String randomString = 'REF-$randomNumber';
    return randomString;
  }

  Map<String, dynamic> toJson() {
    return {
      'time': Timestamp.fromDate(DateTime.now()),
      'userId': userId,
      'fullName': fullName,
      'email': email,
      'image': image,
      'text': text,
      'referenceNumber': generateReferenceNumber()
    };
  }
}
