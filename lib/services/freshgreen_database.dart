import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegitabledelivery/models/fresh_green.dart';
import 'dart:async';

List<FreshGreen> _polupateItemEntry(QuerySnapshot itemList) {
  List<FreshGreen> finalData = [];
  itemList.documents.forEach((DocumentSnapshot docSnapshot) {
    print(docSnapshot.documentID);
    finalData.add(FreshGreen(
        uid: docSnapshot.documentID,
        name: docSnapshot.data['name'],
        price: docSnapshot.data['price'],
        image: docSnapshot.data['image'],
        isVeg: docSnapshot.data['isVeg'],
        minQuantity: docSnapshot.data['minQuantity']));
  });
  return finalData;
}

class FreshGreenDatabaseService {
  final _db = Firestore.instance;
  final CollectionReference freshGreenCollection =
      Firestore.instance.collection('fresh_green');
  FreshGreenDatabaseService();

  Stream <List<FreshGreen>> getAllItemsFromCategory(category) {
    return _db.collection('fresh_green').where('group', isEqualTo: category).snapshots().map((list) => list.documents.map((doc) => FreshGreen.fromFireStore(doc)).toList());
  }
}
