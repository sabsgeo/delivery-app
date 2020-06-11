import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:vegitabledelivery/models/user.dart';
import 'package:vegitabledelivery/services/user_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map> createVerifyUser(String phone, {
    String email,
    String password,
  }) async {
    Completer c = new Completer<Map>();
    AuthResult emailAuthResult;
    try {
      if (email != null && password != null) {
        emailAuthResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      await _verifyPhone(phone: phone, authResult: emailAuthResult, completer: c);
    } catch (e) {
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        await _verifyPhone(phone: phone, authResult: emailAuthResult, completer: c);
      } else {
        c.complete({'state': 'TRY_AGAIN', 'data': null});
      }
    }
    return c.future;
  }

  Future _verifyPhone({String phone, AuthResult authResult,  Completer completer}) async {
    await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) {
          completer.complete({
            'state': 'VERIFICATION_COMPLETE',
            'data': {
              'authCredential': authCredential,
              'emailAuthResult': authResult
            }
          });
        },
        verificationFailed: null,
        codeSent: (String verificationId, [int forceResendingToken]) async {
          completer.complete({
            'state': 'CODE_SENT',
            'data': {
              'verificationId': verificationId,
              'emailAuthResult': authResult
            }
          });
        },
        codeAutoRetrievalTimeout: null);
  }

  User _userFromFirebaseUser(FirebaseUser user) {
    return user !=null ? User(uid: user.uid): null;
  }

  Future<User> registerSignIn({ AuthCredential authCredential, String code, String verificationId, AuthResult authResult, String firstName, String lastName, String email, String phone }) async {
    if (authCredential == null) {
      authCredential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: code);
    }

    if (authResult == null) {
      authResult = await _auth.signInWithCredential(authCredential);
    } else {
      await authResult.user.linkWithCredential(authCredential);
      UserDatabaseService userDb =
          UserDatabaseService(uid: authResult.user.uid);
      await userDb.saveUserInfo(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone);
    }
    return _userFromFirebaseUser(authResult.user);
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
  }

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch(e) {
      return null;
    }

  }
}
