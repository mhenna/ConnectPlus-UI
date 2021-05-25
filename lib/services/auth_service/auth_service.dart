import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:connect_plus/models/user.dart' as user_model;

class AuthService {
  final FirebaseAuth _fbAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fs = FirebaseFirestore.instance;
  user_model.User _user;

  Future<user_model.User> getUser() async {
    final fbUser = _fbAuth.currentUser;
    if (fbUser != null) {
      final userDoc = await _fs.collection('users').doc(fbUser.uid).get();
      _user = user_model.User.fromJson(userDoc.data());
      return _user;
    }
    return null;
  }

  /// Registration
  Future<bool> register({
    @required String email,
    @required String password,
    @required String username,
    @required String phoneNumber,
    List<String> carPlates,
    String businessUnit,
  }) async {
    try {
      final UserCredential cred = await _fbAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User fbUser = cred.user;
      await fbUser.sendEmailVerification();
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
        });
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<AuthState> login({@required String email, @required password}) async {
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

  Future<void> updateProfile(
      {String username,
      String phoneNumber,
      List<String> carPlates,
      String businessUnit}) async {
    final userUid = _fbAuth.currentUser.uid;
    await _fs.collection('users').doc(userUid).update({
      'username': username ?? _user.username,
      'phoneNumber': phoneNumber ?? _user.phoneNumber,
      'carPlates': carPlates ?? _user.carPlates,
      'businessUnit': businessUnit ?? _user.businessUnit,
    });
    _user = _user.copyWith(
      username: username,
      phoneNumber: phoneNumber,
      carPlates: carPlates,
      businessUnit: businessUnit,
    );
  }

  Future<user_model.User> get user async {
    if (_user == null) {
      return await getUser();
    } else {
      return _user;
    }
  }

  Future<String> resetPassword(String email) async {
    try {
      await _fbAuth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      print(e.toString());
      return e.toString();
    }
  }

  Future<void> logout() async {
    return await _fbAuth.signOut();
  }
}

enum AuthState {
  Unregistered,
  Unverified,
  Loggedin,
  UserNotFound,
  WrongPassword
}
