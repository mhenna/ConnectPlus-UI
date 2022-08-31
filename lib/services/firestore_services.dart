import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final FirebaseFirestore _fs = FirebaseFirestore.instance;

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

  Future<String> getUsername(String uid) async {
    var collectionRef = _fs.collection('users');
    var doc = await collectionRef.doc(uid).get();
    return doc.data()['username'];
  }

  Future<bool> checkIfUserRegistered(String uid, String eventId) async {
    var snapshots = await _fs
        .collection('event-registrations')
        .where('uid', isEqualTo: uid)
        .where('eventId', isEqualTo: eventId)
        .get();
    if (snapshots.docs.length >= 1) return true;
    return false;
  }

  Future<void> addUserEventRegistration(String uid, String eventId) async {
    await _fs.collection('event-registrations').add({
      'uid': uid,
      'eventId': eventId,
      'registrationTime': DateTime.now().toString()
    });
  }
}
