import 'package:connect_plus/Activities.dart';
import 'package:connect_plus/ActivityWidget.dart';
import 'package:connect_plus/EventWidget.dart';
import 'package:connect_plus/Events.dart';
import 'package:connect_plus/OfferWidget.dart';
import 'package:connect_plus/Offers.dart';
import 'package:connect_plus/WebinarWidget.dart';
import 'package:connect_plus/emergencyContact.dart';
import 'package:connect_plus/homepage.dart';
import 'package:connect_plus/models/activity.dart';
import 'package:connect_plus/models/event.dart';
import 'package:connect_plus/models/offer.dart';
import 'package:connect_plus/models/webinar.dart';
import 'package:connect_plus/services/web_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:get/get.dart';

class PushNotificationService {
  final NavigationService navService = NavigationService();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialize() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: $message");
        serializeAndNavigate(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        //print("onLaunch: $message");
        serializeAndNavigate(message);
      },
      onResume: (Map<String, dynamic> message) async {
        //print("onResume: $message");
        serializeAndNavigate(message);
      },
    );
    // For testing purposes print the Firebase Messaging token
    String token = await _fcm.getToken();
    print("FirebaseMessaging token: $token");
  }

  void serializeAndNavigate(Map<String, dynamic> message) async {
    var notificationData = message;
    var view = notificationData['view'];
    Event event;
    Offer offer;
    Activity activity;
    Webinar webinar;

    if (view != null) {
      // Add new routes here
      if (view == 'home') {
        Get.to(MyHomePage());
      } else if (view == 'emergency contacts') {
        Get.to(emergencyContact());
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
      }
    } else if (view == 'webinars') {
      if (notificationData['webinar'] != null) {
        webinar = await WebAPI.getWebinarByName(notificationData['webinar']);
        Get.to(WebinarWidget(
          webinar: webinar,
        ));
      } else
        Get.to(Events());
    }
  }
}
