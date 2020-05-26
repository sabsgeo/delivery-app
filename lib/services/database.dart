import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference userInfoCollection =
      Firestore.instance.collection('user_info');

  Future saveUserInfo({String firstName, String lastName, String email, String phone}) async {
    var bytes = utf8.encode(phone);
    String phoneUid = sha256.convert(bytes).toString();
    return await userInfoCollection.document(uid).setData(
        {'firstName': firstName, 'lastName': lastName, 'email': email, 'phone_uid': phoneUid});
  }

  Future<bool> isUserRegistered(String phone) async {
    var bytes = utf8.encode(phone);
    String phoneUid = sha256.convert(bytes).toString();
    QuerySnapshot data = await userInfoCollection.where('phone_uid', isEqualTo: phoneUid).getDocuments();
    if(data.documents.length > 0) {
      return true;
    }
    return false;
  }
}
