import 'dart:io' show Platform;

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:vegitabledelivery/models/address.dart';
import 'package:vegitabledelivery/models/user.dart';
import 'package:vegitabledelivery/services/auth.dart';

class UserDatabaseService {
  final String uid;
  UserDatabaseService({this.uid});
  final CollectionReference userInfoCollection =
      Firestore.instance.collection('user_info');
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final _auth = AuthService();

  Future saveUserInfo(
      {String firstName, String lastName, String email, String phone}) async {
    var bytes = utf8.encode(phone);
    String phoneUid = sha256.convert(bytes).toString();
    String fcmToken = await _fcm.getToken();
    DocumentReference tokenRef = userInfoCollection
        .document(uid)
        .collection('tokens')
        .document(fcmToken);
    await tokenRef.setData({
      'token': fcmToken,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'platform': Platform.operatingSystem,
      'type': 'notification'
    });

    return await userInfoCollection.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone_uid': phoneUid
    });
  }

  Future<bool> isUserRegistered(String phone) async {
    var bytes = utf8.encode(phone);
    String phoneUid = sha256.convert(bytes).toString();
    QuerySnapshot data = await userInfoCollection
        .where('phone_uid', isEqualTo: phoneUid)
        .getDocuments();
    if (data.documents.length > 0) {
      return true;
    }
    return false;
  }

  Future saveNewAddress(Map<String, dynamic> address) async {
    User uid = await _auth.user.first;
    DocumentReference addressRef =
        userInfoCollection.document(uid.uid).collection('address').document();
    await addressRef.setData({
      'address': address,
      'createdAt': DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<List<Address>> getAllAddress() async {
    List<Address> finalData = [];
    User uid = await _auth.user.first;
    QuerySnapshot addressRef = await userInfoCollection
        .document(uid.uid)
        .collection('address')
        .getDocuments();
    addressRef.documents.forEach((DocumentSnapshot element) {
      finalData.add(Address(element.documentID,
          createdTime: element.data['createdAt'],
          administrativeArea: element.data['address']['administrativeArea'],
          country: element.data['address']['country'],
          house: element.data['address']['house'],
          landmark: element.data['address']['landmark'],
          lat: element.data['address']['lat'],
          locality: element.data['address']['locality'],
          long: element.data['address']['long'],
          postalCode: element.data['address']['postalCode'],
          saveAs: element.data['address']['saveAs'],
          subLocality: element.data['address']['subLocality'],
          subThoroughfare: element.data['address']['subThoroughfare']));
    });
    return finalData;
  }
}
