import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:connect_plus/Activities.dart';
import 'package:connect_plus/ActivityWidget.dart';
import 'package:connect_plus/EventWidget.dart';
import 'package:connect_plus/Events.dart';
import 'package:connect_plus/OfferWidget.dart';
import 'package:connect_plus/Offers.dart';
import 'package:connect_plus/WebinarWidget.dart';
import 'package:connect_plus/announcement_widget.dart';
import 'package:connect_plus/emergencyContact.dart';
import 'package:connect_plus/homepage.dart';
import 'package:connect_plus/models/activity.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/offer.dart';
import 'package:connect_plus/models/webinar.dart';
import 'package:connect_plus/models/announcement.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:get/get.dart';

class PushNotificationsService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseFunctions _fbFunctions = FirebaseFunctions.instance;
  Future<String> get token => _fcm.getToken();
  final NavigationService navService = NavigationService();
  Future initialize() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        Get.snackbar(message, message, snackPosition: SnackPosition.TOP);
        print("onMessage: $message");
        serializeAndNavigate(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        serializeAndNavigate(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        serializeAndNavigate(message);
      },
    );
    // For testing purposes print the Firebase Messaging token
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");
  }

  void serializeAndNavigate(Map<String, dynamic> message) async {
    var notificationData = message['data'];
    var view = notificationData['view'];

    Event event;
    Offer offer;
    Activity activity;
    Webinar webinar;
    Announcement announcement;

    if (view != null) {
      // Add new routes here
      if (view == 'home') {
        Get.to(MyHomePage());
      } else if (view == 'emergency contacts') {
        Get.to(Emergency());
      } else if (view == 'events') {
        if (notificationData['event'] != null) {
          event = await WebAPI.getEventByName(notificationData['event']);
          Get.to(EventWidget(
            event: event,
          ));
        } else
          Get.to(Events());
      } else if (view == 'offers') {
        if (notificationData['offer'] != null) {
          offer = await WebAPI.getOfferByName(notificationData['offer']);
          Get.to(
            OfferWidget(
              offer: offer,
              category: offer.category,
            ),
          );
        } else
          Get.to(Offers());
      } else if (view == 'activities') {
        if (notificationData['activity'] != null) {
          activity =
              await WebAPI.getActivityByName(notificationData['activity']);
          Get.to(ActivityWidget(
            activity: activity,
          ));
        } else
          Get.to(Activities());
      } else if (view == 'webinars') {
        if (notificationData['webinar'] != null) {
          webinar = await WebAPI.getWebinarByName(notificationData['webinar']);
          Get.to(WebinarWidget(
            webinar: webinar,
          ));
        } else
          Get.to(Events());
      } else if (view == 'announcements') {
        if (notificationData['announcement'] != null) {
          announcement = await WebAPI.getAnnouncementByName(
              notificationData['announcement']);
          Get.to(AnnouncementWidget(
            announcement: announcement,
          ));
        } else
          Get.to(Events());
      }
    }
  }

  Future<NotificationResponse> sendNotificationToCarOwner({
    @required String carPlate,
  }) async {
    try {
      final HttpsCallable callable =
          _fbFunctions.httpsCallable('alertCarOwner');
      final response = await callable.call({'carPlate': carPlate});
      final bool carFound = response.data['carFound'] == true;
      final bool sentSuccessfully = response.data['sent'] == true;
      if (sentSuccessfully) return NotificationResponse.Success;
      if (!carFound) return NotificationResponse.CarNotFound;
      return NotificationResponse.GenericError;
    } catch (e) {
      return NotificationResponse.GenericError;
    }
  }
}

enum NotificationResponse {
  Success,
  CarNotFound,
  GenericError,
}
