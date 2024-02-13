import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:connect_plus/models/user.dart' as user_model;
import 'package:cloud_functions/cloud_functions.dart';
import 'package:connect_plus/models/registration_status.dart';

class AuthService {
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  user_model.User _user;
  Future<String> getCustomClaim(fbUser) async{
    final idTokenResult=await fbUser.getIdTokenResult(true);
    final claims = idTokenResult.claims;
    if(claims['qrCodeScanner']==true)
      return 'qrCodeScanner';
    else if (claims['bookSwapsAdmin']==true)
      return 'bookSwapsAdmin';
    else return '';
  }

  Future<user_model.User> getUser() async {
    final fbUser = _fbAuth.currentUser;
    if (fbUser != null) {
      final userDoc = await _fs.collection('users').doc(fbUser.uid).get();
      final userData=userDoc.data();
      userData['customClaim']=await getCustomClaim(fbUser);
      _user = user_model.User.fromJson(userData);
      print("claims: ${_user.customClaim}");
      print("gender: ${_user.gender}");
      _user.setEmailVerified(fbUser.emailVerified);
      return _user;
    }
    return null;
  }

  /// Registration
  Future<RegistrationStatus> register({
    @required String email,
    @required String password,
    @required String username,
    @required String phoneNumber,
    @required String pushNotificationToken,
    @required String gender,
    List<String> carPlates,
    String businessUnit,
  }) async {
    try {
      final UserCredential cred = await _fbAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User fbUser = cred.user;

      if (fbUser != null) {
        await _fs.collection('users').doc(cred.user.uid).set({
          'username': username,
          'email': email,
          'phoneNumber': phoneNumber,
          'carPlates': carPlates,
          'createdAt': DateTime.now().toString(),
          'updatedAt': DateTime.now().toString(),
          'blocked': false,
          'id': cred.user.uid,
          'businessUnit': businessUnit,
          'pushNotificationToken': pushNotificationToken,
          'gender':gender
        });
        String response = await sendVerificationEmail();
        if (response != "") {
          logRegistrationError(typedEmail: email, error: response);
          return RegistrationStatus(success: false, error: response);
        }
        return RegistrationStatus(success: true);
      }
      return RegistrationStatus(success: false, error: "Unknown error");
    } catch (e) {
      String error = e.toString();
      logRegistrationError(typedEmail: email, error: error);
      return RegistrationStatus(success: false, error: error);
    }
  }

  Future<void> logRegistrationError(
      {@required String typedEmail, @required String error}) async {
    await _fs.collection('registration-error-logs').add({
      'typedEmail': typedEmail,
      'error': error,
      'timestamp': DateTime.now().toString()
    });
  }

  Future<AuthState> login({
    @required String email,
    @required String password,
  }) async {
    try {
      final userCred = await _fbAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCred.user.emailVerified) {
        return AuthState.Loggedin;
      }

      return AuthState.Unverified;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AuthState.UserNotFound;
      } else if (e.code == 'wrong-password') {
        return AuthState.WrongPassword;
      }
      return AuthState.Unregistered;
    } catch (e) {
      return AuthState.Unregistered;
    }
  }

  Future<void> updateProfile({
    String username,
    String phoneNumber,
    List<String> carPlates,
    String businessUnit,
    String pushNotificationToken,
  }) async {
    final userUid = _fbAuth.currentUser.uid;
    await _fs.collection('users').doc(userUid).update({
      'username': username ?? _user.username,
      'phoneNumber': phoneNumber ?? _user.phoneNumber,
      'carPlates': carPlates ?? _user.carPlates,
      'businessUnit': businessUnit ?? _user.businessUnit,
      'pushNotificationToken':
          pushNotificationToken ?? _user.pushNotificationToken,
      'updatedAt': DateTime.now().toString(),
    });
    _user = _user.copyWith(
      username: username,
      phoneNumber: phoneNumber,
      carPlates: carPlates,
      businessUnit: businessUnit,
      pushNotificationToken: pushNotificationToken,
    );
  }

  Future<user_model.User> get user async {
    if (_user == null) {
      _user = await getUser();
      return _user;
    } else {
      return _user;
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await _fbAuth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> logout() async {
    _user=null;
    return await _fbAuth.signOut();
  }

  Future<void> resendVerificationEmail({
    @required String email,
    @required String password,
  }) async {
    final userCred = await _fbAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return await sendVerificationEmail();
  }

  Future<void> updatePushNotificationToken(String pnToken) async {
    final userUid = _fbAuth.currentUser.uid;
    return await _fs
        .collection('users')
        .doc(userUid)
        .update({'pushNotificationToken': pnToken});
  }

  Future<String> sendVerificationEmail() async {
    final FirebaseFunctions _fbFunctions = FirebaseFunctions.instance;
    try {
      final HttpsCallable callable =
          _fbFunctions.httpsCallable('sendVerificationEmail');
      final response = await callable.call();
      final String err = response.data['error'];

      return err;
    } catch (e) {
      return e;
    }
  }
}

enum AuthState {
  Unregistered,
  Unverified,
  Loggedin,
  UserNotFound,
  WrongPassword
}
