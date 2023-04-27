import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connect_plus/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreServices {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  final String _uid = FirebaseAuth.instance.currentUser.uid;

  Future<bool> checkIfUserExists(String uid) async {
    bool exists;
    try {
      var collectionRef = _fs.collection('users');
      var doc = await collectionRef.doc(uid).get();
      exists = doc.exists;
    } catch (e) {
      exists = false;
    }
    return exists;
  }

  Future<bool> checkIfEmailExists({String email}) async {
    try {
      var snapshots = await _fs
          .collection('users')
          .where('email', isEqualTo: email.trim().toLowerCase())
          .get();
      if (snapshots.docs.length >= 1) return true;
    } catch (e) {
      return false;
    }
    return false;
  }


  Future<String> getUsername(String uid) async {
    var collectionRef = _fs.collection('users');
    var doc = await collectionRef.doc(uid).get();
    return doc.data()['username'];
  }

  Future<String> getFcmToken(String uid) async {
    var collectionRef = _fs.collection('users');
    var doc = await collectionRef.doc(uid).get();
    return doc.data()['pushNotificationToken'];
  }

  Future<String> getCurrentUserEmail() async {
    var collectionRef = _fs.collection('users');
    var doc = await collectionRef.doc(_uid).get();
    return doc.data()['email'];
  }

  Future<void> addGender(String gender) async {
    await _fs.collection('users').doc(_uid).update({"gender":gender});
  }

  Future<bool> checkIfUserRegistered({String uid, String eventId}) async {
    try {
      var snapshots = await _fs
          .collection('event-registrations')
          .where('uid', isEqualTo: uid)
          .where('eventId', isEqualTo: eventId)
          .get();
      if (snapshots.docs.length >= 1) return true;
    } catch (e) {
      return false;
    }
    return false;
  }

  Future<void> addUserEventRegistration({String uid, String eventId}) async {
    await _fs.collection('event-registrations').add({
      'uid': uid,
      'eventId': eventId,
      'registrationTime': DateTime.now().toString(),
      'registeredBy': _uid
    });
  }
}
