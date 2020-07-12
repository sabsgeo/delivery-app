import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
class FireStorageService extends ChangeNotifier {
  final StorageReference strRef = FirebaseStorage.instance.ref();
  FireStorageService();
  Future<String> loadImage(String image) async {
    return await strRef.child(image).getDownloadURL();
  }
}