import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationsService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future<String> get token => _fcm.getToken();
}
