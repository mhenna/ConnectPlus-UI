import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:no_context_navigation/no_context_navigation.dart';

class PushNotificationService {
  final NavigationService navService = NavigationService();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialize() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
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
  }

  void serializeAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var view = notificationData['view'];

    if (view != null) {
      // Add new routes here
      if (view == 'Events') {
        navService.pushNamed('/events');
      } else if (view == 'Offers') {
        navService.pushNamed('/offers');
      }
    }
  }
}