import 'package:cloud_functions/cloud_functions.dart';
import 'package:connect_plus/services/firestore_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseFunctionsServices {
  final FirebaseFunctions _fbFunctions = FirebaseFunctions.instance;
  final FirestoreServices _fs = FirestoreServices();

  Future<bool> sendEventReportByMail(
  {String email, String eventId, String eventName}) async {
    bool emailExists = await _fs.checkIfEmailExists(email: email);
    if (!emailExists) return false;
    final HttpsCallable callable =
        _fbFunctions.httpsCallable('sendEventReportByMail');
    try {
      callable
          .call({'email': email, 'eventName': eventName, 'eventId': eventId});
    } catch (e) {
      return false;
    }
    return true;
  }

  Future<bool> sendEmail(
      {String receiverId, String subject, String body}) async {
    final HttpsCallable callable =
    _fbFunctions.httpsCallable('sendEmail');
    try {
      callable
          .call({'uid': receiverId, 'subject': subject, 'body': body,});
    } catch (e) {
      return false;
    }
    return true;
  }
}
