import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegitabledelivery/models/fresh_green.dart';
import 'dart:async';

class FreshGreenDatabaseService {
  final _db = Firestore.instance;
  final CollectionReference freshGreenCollection =
      Firestore.instance.collection('fresh_green');
  FreshGreenDatabaseService();

  Stream <List<FreshGreen>> getAllItemsFromCategory(category) {
    return _db.collection('fresh_green').where('group', isEqualTo: category).snapshots().map((list) => list.documents.map((doc) => FreshGreen.fromFireStore(doc)).toList());
  }

  Future addNewItems(Map<String, dynamic> data) async {
    await _db.collection('fresh_green').document().setData(data);
  }

  Future updateItems(String id, Map<String, dynamic> data) async {
    await _db.collection('fresh_green').document(id).updateData(data);
  }

  Future deleteItems(String id) async {
    await _db.collection('fresh_green').document(id).delete();
  }
}
