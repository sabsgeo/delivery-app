import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:vegitabledelivery/models/fresh_green.dart';
import 'package:vegitabledelivery/singletons/app_data.dart';

List<FreshGreen> _polupateItemEntry(QuerySnapshot itemList) {
  List<FreshGreen> finalData = [];
  itemList.documents.forEach((DocumentSnapshot docSnapshot) {
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
  final CollectionReference freshGreenCollection =
      Firestore.instance.collection('fresh_green');
  FreshGreenDatabaseService();

  Future<List<FreshGreen>> getAllFreshGreen({refreshData: false}) async {
    if (appData.freshGreen.length < 1 || refreshData ) {
      QuerySnapshot tmpList = await freshGreenCollection.getDocuments();
      List<FreshGreen> finalData = await compute(_polupateItemEntry, tmpList);
      appData.freshGreen = finalData;
    }
    return appData.freshGreen;
  }
}
