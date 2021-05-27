import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class PushNotificationsService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final FirebaseFunctions _fbFunctions = FirebaseFunctions.instance;
  Future<String> get token => _fcm.getToken();

  Future<NotificationResponse> sendNotificationToCarOwner({
    @required String carPlate,
  }) async {
    try {
      final HttpsCallable callable =
          _fbFunctions.httpsCallable('alertCarOwner');
      final response = await callable.call({'carPlate': carPlate});
      final bool carFound = response.data['carFound'];
      final bool sentSuccessfully = response.data['sent'];
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
